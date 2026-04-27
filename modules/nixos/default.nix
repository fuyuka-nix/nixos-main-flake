lib:
{
  nixvim-profiles = {
    frosted-editor = ./nixvim/frosted-editor;
  };
  starship = ./starship;
  default = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        systemd-boot.editor = false;
        efi.canTouchEfiVariables = true;
        timeout = 25;
      };
    };

    nix = {
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';
    };
  };
}
// (lib.genAttrs [
  "fonts"
  "locale-es-cr"
  "pipewire"
  "steam"
  "arrpc"
] (moduleName: ./${moduleName}.nix))

