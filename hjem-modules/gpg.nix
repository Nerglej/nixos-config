{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.gpg;

  gpg = "${pkgs.gnupg}/bin";
  gnupgHome = "${config.xdg.data.directory}/gnupg";

  # With a non-default GNUPGHOME, gnupg places the agent sockets in a
  # subdirectory of the runtime dir named "d.<hash>", where the hash derives
  # from the homedir path. Socket activation must listen on that exact path, so
  # ask gpgconf what it is rather than hardcoding the hash.
  socketDir = lib.removeSuffix "\n" (
    builtins.readFile (
      pkgs.runCommand "gnupg-socketdir" { } ''
        export GNUPGHOME='${gnupgHome}'
        basename "$(${gpg}/gpgconf --list-dirs socketdir)" > $out
      ''
    )
  );
in
{
  options.wil.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      gnupg
      pinentry-qt
    ];

    environment.sessionVariables.GNUPGHOME = gnupgHome;

    xdg.data.files."gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
    '';

    systemd.sockets.gpg-agent = {
      description = "GnuPG cryptographic agent and passphrase cache";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "%t/gnupg/${socketDir}/S.gpg-agent";
        FileDescriptorName = "std";
        SocketMode = "0600";
        DirectoryMode = "0700";
      };
    };

    systemd.services.gpg-agent = {
      description = "GnuPG cryptographic agent and passphrase cache";
      requires = [ "gpg-agent.socket" ];
      after = [ "gpg-agent.socket" ];
      environment.GNUPGHOME = gnupgHome;
      unitConfig.RefuseManualStart = true;
      serviceConfig = {
        ExecStart = "${gpg}/gpg-agent --supervised";
        ExecReload = "${gpg}/gpgconf --reload gpg-agent";
      };
    };
  };
}
