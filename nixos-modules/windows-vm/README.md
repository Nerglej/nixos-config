# Windows VM with NixOS

## Overview

This setup adds a **Windows VM** entry to your login screen; picking it starts
Windows 11 fullscreen, and shutting Windows down returns you to the login
screen. Your normal desktop sessions stay untouched.

The chain that runs when you pick the session:

1. The display manager starts **cage**, a single-window Wayland kiosk compositor.
2. cage runs the **windows-vm** launcher script.
3. The script starts **swtpm** (a software TPM 2.0, which Windows 11 requires).
4. It starts **QEMU** headless (`-display none`) with UEFI firmware (OVMF), the
   TPM, virtio disk/network/input, and a **virtio-gpu** display served over a
   **SPICE** unix socket.
5. It runs **remote-viewer** against that socket in kiosk mode, which is the
   only window cage has to show.
6. When Windows shuts down, QEMU exits, the SPICE connection drops,
   remote-viewer quits (`--kiosk-quit=on-disconnect`), and the session ends.

### Why SPICE rather than QEMU's own window

Driving `virtio-vga-gl` through QEMU's own `-display gtk` window makes the mouse
feel laggy: the cursor is composited by the guest, so every pointer movement has
to round-trip through Windows before you see it move.

Serving the same virtio-gpu over SPICE enables **client mouse mode**: the guest
reports absolute coordinates and the SPICE client draws the cursor locally on the
host, so pointer movement never waits on the guest. `gl=on` passes the guest
framebuffer to the client as a dmabuf, so no pixels are copied or encoded —
`virtio-vga-gl` refuses to start without it, and that mode drives one head only.

Confirm client mouse mode is active with:

```sh
printf 'info spice\nquit\n' | socat - unix-connect:"$XDG_RUNTIME_DIR/windows-vm/monitor.sock"
```

`mouse-mode: client` is what you want to see (`server` means the cursor is being
drawn by the guest again).

## Commands

| Command | What it does |
| --- | --- |
| `windows-vm` | Normal run. Kiosk/fullscreen, no ISOs attached. |
| `windows-vm --drivers` | Attaches `virtio-win.iso`, windowed, for installing or updating guest drivers. |
| `windows-vm --install` | Attaches `win11.iso` + `virtio-win.iso`, windowed, for a fresh install. |

Environment overrides:

| Variable | Default | Purpose |
| --- | --- | --- |
| `VM_DIR` | `$HOME/vms/win11` | Disk image, UEFI vars and TPM state. |
| `VM_DISPLAY` | `spice` | Set to `gtk` to let QEMU draw its own window instead. |

Runtime sockets live in `$XDG_RUNTIME_DIR/windows-vm/` (not next to the disk
image) because unix socket paths are capped at 108 bytes.

## Downloads

Both ISOs go in `~/vms/win11/` under the exact names below.

| File | Where to get it | Save as |
| --- | --- | --- |
| Windows 11 installer | [microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11), "Download Windows 11 Disk Image (ISO) for x64 devices" | `~/vms/win11/win11.iso` |
| virtio-win drivers | [Stable virtio-win ISO (Fedora)](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) | `~/vms/win11/virtio-win.iso` |

```sh
mkdir -p ~/vms/win11
curl -L -o ~/vms/win11/virtio-win.iso \
  https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
# Windows ISO: download through the Microsoft page in a browser (the link is
# generated per session), then: mv ~/Downloads/Win11_*.iso ~/vms/win11/win11.iso
```

Keep `virtio-win.iso` after installing — it carries every guest driver. You can
delete `win11.iso`.

## Installing Windows

Do the install once from your normal desktop, so you keep a terminal next to the
VM. After a rebuild, log out and back in so the `kvm` group membership applies.

1. Run `windows-vm --install`. It creates the disk, TPM state and UEFI vars on
   first run.
2. When "Press any key to boot from CD or DVD" appears, press a key immediately.
   If you miss it, close the window and run the command again.
3. Continue to **Where do you want to install Windows?** The list is empty,
   because Windows has no virtio disk driver yet.
4. **Load driver** → **Browse** → the virtio-win CD → `viostor\w11\amd64`. The
   disk appears.
5. **Load driver** again → `NetKVM\w11\amd64`, so networking works during setup.
6. Select the disk and continue; Windows reboots a few times on its own.
7. Finish the setup screens and reach the desktop.
8. Open the virtio-win CD in Explorer and run `virtio-win-guest-tools.exe` for
   the remaining drivers: GPU (`viogpudo`), balloon, serial, guest agent.
9. Shut Windows down normally.

### A note on QXL

An earlier version of this setup used `qxl-vga` with the `qxldod` driver, because
QXL has in-guest 2D acceleration that virtio-gpu lacks. Do not bother: the
`qxldod` on the virtio-win ISO is dated February 2021, ships only under `w10`
(no `w11`), and will not install on Windows 11. QXL is deprecated upstream in
favour of virtio-gpu, so virtio is the maintained path.

Client mouse mode is what actually fixes the pointer latency, and that is a SPICE
feature — it does not depend on the guest GPU driver.

### Optional: clipboard and resolution matching

The virtio-win ISO does **not** include `spice-vdagent`. Client mouse mode was
observed working without it (the absolute tablet device is enough), so the
latency fix does not depend on it. Install it if you want host/guest clipboard
sharing and a guest resolution that follows the window, from
[spice-space.org/download/windows/vdagent](https://www.spice-space.org/download/windows/vdagent/).
The vdagent channel is already wired up on the QEMU side.

## Daily use

At the login screen pick **Windows VM** from the session menu. Windows boots
fullscreen with sound, network and absolute-pointer input.

| Keys | What it does |
| --- | --- |
| Shift+F12 | Release the pointer/keyboard grab (only needed in server mouse mode) |
| Ctrl+Alt+F2 | Switch to a Linux text console (escape hatch if the VM hangs) |

To leave, shut Windows down from the Start menu. Avoid killing QEMU while
Windows is running, which is like pulling the power cord. If remote-viewer dies
while the VM is up, the launcher sends an ACPI `system_powerdown` and waits two
minutes before forcing anything, so Windows still shuts down cleanly.

## Troubleshooting

For a session that drops straight back to the login screen, read the error with
`journalctl --user -b | grep -iE 'qemu|swtpm|cage|remote-viewer'`, or run
`windows-vm` in a terminal to see it directly.

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Session missing from login screen | `.desktop` name doesn't match `providedSessions` | Both must be `windows-vm`; rebuild |
| "Could not access KVM kernel module: Permission denied" | User not in `kvm` group yet | Log out and back in after the rebuild |
| "This PC can't run Windows 11" | TPM or UEFI not attached | Check `tpm.sock` exists in `$XDG_RUNTIME_DIR/windows-vm/` |
| No disk shown during install | virtio storage driver not loaded | Load `viostor\w11\amd64` from the virtio-win CD |
| Setup demands internet or a Microsoft account | Network driver missing | Load `NetKVM\w11\amd64` during install |
| Stuck at a low resolution | virtio GPU driver missing | Run `virtio-win-guest-tools.exe` from the virtio-win CD |
| Mouse still laggy | Guest fell back to server mouse mode | Check `info spice` reports `mouse-mode: client`; installing `spice-vdagent` makes it reliable |
| "Failed to connect to PipeWire instance" | PipeWire not up yet | The launcher now waits 5s then starts without audio; check `systemctl --user status pipewire` |
| Sluggish overall, not just the mouse | Try the other display path | `VM_DISPLAY=gtk windows-vm` to compare |

To start completely fresh, delete `~/vms/win11/disk.qcow2`, `OVMF_VARS.fd` and
the `tpm/` folder, then run `windows-vm --install` again.
