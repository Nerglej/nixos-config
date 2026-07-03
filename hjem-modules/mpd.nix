{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkOption types;

  cfg = config.wil.mpd;
in
{
  options.wil.mpd = {
    enable = mkEnableOption "mpd service";

    package = lib.mkPackageOption pkgs "mpd" { };

    musicDir = mkOption {
      type = with types; either path str;
      default = null;
      example = "~/Music";
    };

    playlistDir = mkOption {
      type = types.path;
      default = "${config.xdg.data.directory}/playlists";
    };

    dataDir = mkOption {
      type = types.path;
      default = "${config.xdg.data.directory}/mpd";
    };

    stateDir = mkOption {
      type = types.path;
      default = "${config.xdg.state.directory}/mpd";
    };

    dbFile = mkOption {
      type = types.nullOr types.str;
      default = "${cfg.dataDir}/database";
    };

    network = {
      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "any";
        description = ''
          The address for the daemon to listen on.
          Use `any` to listen on all addresses.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 6600;
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        visible = pkgs.stdenv.hostPlatform.isLinux;
        readOnly = pkgs.stdenv.hostPlatform.isDarwin;
        description = ''
          Enable systemd socket activation. This is only supported on Linux.
        '';
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra directives added to the end of MPD's configuration
        file, {file}`mpd.conf`. Basic configuration
        like file location and uid/gid is added automatically to the
        beginning of the file. For available options see
        {manpage}`mpd.conf(5)`.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = ''
        Extra command-line arguments to pass to MPD.
      '';
    };
  };

  config =
    let
      mpdConfig = ''
        music_directory     "${cfg.musicDir}"
        playlist_directory  "${cfg.playlistDir}"
      ''
      + lib.optionalString (cfg.dbFile != null) ''
        db_file             "${cfg.dbFile}"
      ''
      # + lib.optionalString (pkgs.stdenv.hostPlatform.isDarwin) ''
      #   log_file            "${config.home.homeDirectory}/Library/Logs/mpd/log.txt"
      # ''
      + ''
        state_file          "${cfg.dataDir}/state"
        sticker_file        "${cfg.dataDir}/sticker.sql"
      ''
      + lib.optionalString (cfg.network.listenAddress != "any") ''
        bind_to_address     "${cfg.network.listenAddress}"
      ''
      + lib.optionalString (cfg.network.port != 6600) ''
        port                "${toString cfg.network.port}"
      ''
      + lib.optionalString (cfg.extraConfig != "") ''
        ${cfg.extraConfig}
      '';
      mpdConf = pkgs.writeText "mpd.conf" mpdConfig;
    in
    mkIf cfg.enable {
      systemd.services.mpd = {
        description = "Music Player Daemon";
        requires = [ "mpd.socket" ];
        after = [
          "network.target"
          "sound.target"
          "mpd.socket"
        ];

        # create directories if they don't exist
        preStart = ''${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/mkdir -p '${cfg.dataDir}' '${cfg.playlistDir}'"'';
        script = "${cfg.package}/bin/mpd --no-daemon ${mpdConf} ${lib.escapeShellArgs cfg.extraArgs}";

        serviceConfig = {
          Type = "notify";
        };
      };

      systemd.sockets.mpd = mkIf cfg.network.startWhenNeeded {
        socketConfig = {
          ListenStream =
            let
              listen =
                if cfg.network.listenAddress == "any" then
                  toString cfg.network.port
                else
                  "${cfg.network.listenAddress}:${toString cfg.network.port}";
            in
            [
              listen
              "%t/mpd/socket"
            ];

          Backlog = 5;
          KeepAlive = true;
        };

        wantedBy = [ "sockets.target" ];
      };

    };
}
