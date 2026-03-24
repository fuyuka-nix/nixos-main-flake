{
  pkgs,
  lib,
  ...
}:
let
  hackNerdFont = {
    package = pkgs.nerd-fonts.hack;
    name = "HackNerdFont";
  };
in
{
  options.stylix = {
    targets.starship.enable = lib.mkEnableOption "starship target"; # Not going to ask why this is not implemented but inlcuded in autoEnable
  };
  config.stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";
    image = ./solar-wallpaperbetter.jpg;
    fonts = {
      serif = hackNerdFont;
      sansSerif = hackNerdFont;
      monospace = hackNerdFont;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "NotoFontsColorEmoji";
      };
    };
  };
}
