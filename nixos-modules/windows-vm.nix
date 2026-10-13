{
  flake.nixosModules.windows-vm =
    { pkgs, ... }:
    let
      ovmf = pkgs.OVMFFull.fd;

      windowsVm = pkgs.writeShellApplication {
        name = "windows-vm";
        runtimeInputs = [
          pkgs.qemu
          pkgs.swtpm
          pkgs.virt-viewer
          pkgs.socat
          pkgs.coreutils
        ];
        text = ''
          VM_DIR="''${VM_DIR:-$HOME/vms/win11}"

          # spice: virtio-gpu served over SPICE to a local client, which can
          #        draw the cursor host-side once spice-vdagent is installed.
          # gtk:   same virtio-gpu, drawn by QEMU's own GTK window. Fallback.
          VM_DISPLAY="''${VM_DISPLAY:-spice}"

          mode="''${1:-session}"
          case "$mode" in
            session | --install | --drivers) ;;
            *)
              echo "windows-vm: usage: windows-vm [--install | --drivers]" >&2
              exit 1
              ;;
          esac

          case "$VM_DISPLAY" in
            spice | gtk) ;;
            *)
              echo "windows-vm: VM_DISPLAY must be 'spice' or 'gtk', got '$VM_DISPLAY'" >&2
              exit 1
              ;;
          esac

          mkdir -p "$VM_DIR/tpm"

          # Sockets go in the runtime dir, not next to the disk image: unix
          # socket paths are capped at 108 bytes, and these are per-boot state.
          XDG_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
          RUN_DIR="$XDG_DIR/windows-vm"
          mkdir -p "$RUN_DIR"
          chmod 700 "$RUN_DIR"
          TPM_SOCK="$RUN_DIR/tpm.sock"
          SPICE_SOCK="$RUN_DIR/spice.sock"
          MON_SOCK="$RUN_DIR/monitor.sock"
          trap 'rm -f "$TPM_SOCK" "$SPICE_SOCK" "$MON_SOCK"' EXIT

          # Writable copy of the UEFI variable store (boot entries, Secure Boot state)
          if [ ! -f "$VM_DIR/OVMF_VARS.fd" ]; then
            install -m 644 ${ovmf}/FV/OVMF_VARS.fd "$VM_DIR/OVMF_VARS.fd"
          fi

          # 80 GB sparse disk; only uses space as Windows fills it
          if [ ! -f "$VM_DIR/disk.qcow2" ]; then
            qemu-img create -f qcow2 "$VM_DIR/disk.qcow2" 80G
          fi

          # Software TPM 2.0; --terminate makes it exit together with QEMU
          rm -f "$TPM_SOCK"
          swtpm socket --tpm2 \
            --tpmstate dir="$VM_DIR/tpm" \
            --ctrl type=unixio,path="$TPM_SOCK" \
            --terminate &
          for _ in $(seq 50); do
            [ -S "$TPM_SOCK" ] && break
            sleep 0.1
          done

          args=(
            -name "Windows 11"
            -enable-kvm
            -machine "q35,smm=on"
            -rtc "base=localtime,driftfix=slew"
            -cpu "host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_vpindex,hv_synic,hv_stimer,hv_stimer_direct,hv_runtime,hv_frequencies,hv_tlbflush,hv_ipi,hv_reset"
            -smp "8,sockets=1,cores=8,threads=1"
            -m 8G
            -global "driver=cfi.pflash01,property=secure,value=on"
            -drive "if=pflash,format=raw,readonly=on,file=${ovmf}/FV/OVMF_CODE.fd"
            -drive "if=pflash,format=raw,file=$VM_DIR/OVMF_VARS.fd"
            -chardev "socket,id=chrtpm,path=$TPM_SOCK"
            -tpmdev "emulator,id=tpm0,chardev=chrtpm"
            -device "tpm-crb,tpmdev=tpm0"
            -drive "file=$VM_DIR/disk.qcow2,if=virtio,discard=unmap"
            -nic "user,model=virtio-net-pci"
            -device qemu-xhci
            -device virtio-tablet-pci
            -device virtio-keyboard-pci
            -device ich9-intel-hda
            -device "hda-duplex,audiodev=snd0"
          )

          # QEMU aborts outright if the PipeWire socket is missing, and at login
          # that often just means the user's PipeWire has not come up yet. Wait
          # briefly, then fall back to silence rather than killing the session.
          audiodev="none,id=snd0"
          for _ in $(seq 50); do
            if [ -S "$XDG_DIR/pipewire-0" ]; then
              audiodev="pipewire,id=snd0"
              break
            fi
            sleep 0.1
          done
          if [ "$audiodev" = "none,id=snd0" ]; then
            echo "windows-vm: PipeWire socket not found, starting without audio" >&2
          fi
          args+=(-audiodev "$audiodev")

          # Attach ISOs only when asked: --install for a fresh Windows install,
          # --drivers to install or update drivers from the virtio-win CD.
          case "$mode" in
            --install)
              args+=(
                -drive "file=$VM_DIR/win11.iso,media=cdrom,readonly=on"
                -drive "file=$VM_DIR/virtio-win.iso,media=cdrom,readonly=on"
              )
              ;;
            --drivers)
              args+=(-drive "file=$VM_DIR/virtio-win.iso,media=cdrom,readonly=on")
              ;;
          esac

          case "$VM_DISPLAY" in
            spice)
              rm -f "$SPICE_SOCK" "$MON_SOCK"
              args+=(
                -device virtio-vga-gl
                # gl=on hands the guest framebuffer to the client as a dmabuf,
                # so nothing is copied or encoded. virtio-vga-gl refuses to
                # start without it. One head only in this mode.
                -spice "unix=on,addr=$SPICE_SOCK,disable-ticketing=on,agent-mouse=on,gl=on"
                # vdagent channel. Client mouse mode (host-drawn cursor) was
                # seen working from the absolute tablet alone, but installing
                # spice-vdagent in Windows makes it reliable and adds clipboard
                # sharing plus resolution that follows the client window.
                -device virtio-serial-pci
                -chardev "spicevmc,id=vdagent,name=vdagent"
                -device "virtserialport,chardev=vdagent,name=com.redhat.spice.0"
                -monitor "unix:$MON_SOCK,server=on,wait=off"
                -display none
              )
              ;;
            gtk)
              args+=(
                -device virtio-vga-gl
                -display "gtk,gl=on,full-screen=on"
              )
              ;;
          esac

          if [ "$VM_DISPLAY" = gtk ]; then
            exec qemu-system-x86_64 "''${args[@]}"
          fi

          qemu-system-x86_64 "''${args[@]}" &
          qemu_pid=$!

          for _ in $(seq 100); do
            [ -S "$SPICE_SOCK" ] && break
            if ! kill -0 "$qemu_pid" 2>/dev/null; then
              echo "windows-vm: QEMU exited before the SPICE socket appeared" >&2
              wait "$qemu_pid" || exit 1
              exit 1
            fi
            sleep 0.1
          done

          # Only the login session takes over the screen; the ISO modes stay
          # windowed so they can be driven from a normal desktop.
          viewer=(remote-viewer --title "Windows 11")
          if [ "$mode" = session ]; then
            viewer+=(--kiosk --kiosk-quit=on-disconnect --full-screen)
          fi
          viewer+=("spice+unix://$SPICE_SOCK")

          "''${viewer[@]}" || true

          # Normally the viewer quits because Windows shut down and QEMU exited.
          # If the viewer died first, ask the guest to power off rather than
          # leaving an invisible VM behind; only force it if that is ignored.
          if kill -0 "$qemu_pid" 2>/dev/null; then
            echo "windows-vm: viewer exited while the VM is up; requesting shutdown" >&2
            printf 'system_powerdown\n' \
              | socat - "unix-connect:$MON_SOCK" >/dev/null 2>&1 || true
            for _ in $(seq 120); do
              kill -0 "$qemu_pid" 2>/dev/null || break
              sleep 1
            done
            if kill -0 "$qemu_pid" 2>/dev/null; then
              kill "$qemu_pid" 2>/dev/null || true
            fi
          fi

          wait "$qemu_pid" 2>/dev/null || true
        '';
      };

      windowsSession =
        (pkgs.writeTextDir "share/wayland-sessions/windows-vm.desktop" ''
          [Desktop Entry]
          Name=Windows VM
          Comment=Windows 11 in QEMU, fullscreen
          Exec=${pkgs.cage}/bin/cage -s -- ${windowsVm}/bin/windows-vm
          Type=Application
        '')
        // {
          providedSessions = [ "windows-vm" ];
        };
    in
    {
      services.displayManager.sessionPackages = [ windowsSession ];
      environment.systemPackages = [ windowsVm ];
    };
}
