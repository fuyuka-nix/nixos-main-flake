{
  den,
  ...
}:
{
  den.aspects.fonts.nixos = { pkgs, ... }: {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.hack
        # jetbrains-mono
        # openmoji-color
        noto-fonts-color-emoji
        # nerd-fonts.dejavu-sans-mono
        # nerd-fonts.noto
        libre-caslon
        babelstone-han
      ];

      fontconfig = {
        hinting.autohint = true;
        # defaultFonts = {
        #   sansSerif = [ "Noto Sans" "Hack Nerd Font" ];
        #   serif = [ "Libre Caslon Text" ];
        #   monospace = [ "Hack Nerd Font Mono" ];
        #   emoji = [ "OpenMoji Color" ];
        # };
      };
    };
  };
}
