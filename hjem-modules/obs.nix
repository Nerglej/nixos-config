{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib) optional;

  cfg = config.wil.obs;
in
{
  options.wil.obs = {
    enable = mkEnableOption "obs";
    cuda.enable = mkEnableOption "obs cuda support";
    amd.enable = mkEnableOption "obs amd support";
  };

  config = mkIf cfg.enable {
    packages =
      let
        obs-studio = pkgs.obs-studio.override {
          cudaSupport = cfg.cuda.enable;
        };

        obs = (pkgs.wrapOBS.override { inherit obs-studio; }) {
          plugins =
            with pkgs.obs-studio-plugins;
            [
              wlrobs
              obs-backgroundremoval
              obs-pipewire-audio-capture
              obs-gstreamer
              obs-vkcapture
            ]
            ++ optional cfg.amd.enable pkgs.obs-studio-plugins.obs-vaapi;
        };
      in
      [ obs ];
  };
}
