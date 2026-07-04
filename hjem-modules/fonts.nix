{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    getName
    listToAttrs
    ;

  cfg = config.wil.fonts;

  mkPrefer = generic: family: ''
    <alias binding="same">
      <family>${generic}</family>
      <prefer><family>${family}</family></prefer>
    </alias>
  '';

  mkFontOption = name: package: {
    name = mkOption {
      type = types.str;
      default = name;
    };

    package = mkOption {
      type = types.package;
      default = package;
    };
  };
in
{
  options.wil.fonts = {
    enable = mkEnableOption "fonts";

    packages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

    serif = mkFontOption "DejaVu Serif" pkgs.dejavu_fonts;
    sansSerif = mkFontOption "DejaVu Sans" pkgs.dejavu_fonts;
    monospace = mkFontOption "CommitMono Nerd Font" pkgs.nerd-fonts.commit-mono;
    emoji = mkFontOption "Noto Color Emoji" pkgs.noto-fonts-color-emoji;
  };

  config =
    let
      packages = cfg.packages ++ [
        cfg.serif.package
        cfg.sansSerif.package
        cfg.monospace.package
        cfg.emoji.package
      ];
    in
    mkIf cfg.enable {
      xdg.data.files = listToAttrs (
        map (p: {
          name = "fonts/${getName p}";
          value.source = "${p}/share/fonts";
        }) packages
      );

      xdg.config.files."fontconfig/fonts.conf".text = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
        <fontconfig>
        ${concatStringsSep "\n" [
          (mkPrefer "serif" cfg.serif.name)
          (mkPrefer "sans-serif" cfg.sansSerif.name)
          (mkPrefer "monospace" cfg.monospace.name)
          (mkPrefer "emoji" cfg.emoji.name)
        ]}
        </fontconfig>
      '';
    };
}
