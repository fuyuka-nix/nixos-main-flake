{
  den,
  inputs,
  ...
}:
{
  den.default.includes = [
    (den.batteries.unfree [
      "affinity-extracted-sources"
      "affinity-v3"
      "steam"
      "steam-unwrapped"
      "osu-lazer-bin"
      "osu-resources"
      "lucy-hyprcursor"
      "lucy-wincursor"
    ])
  ];
  den.default.nixos = { pkgs, ... }: {
    imports = [ inputs.copyparty.nixosModules.default ];
    system.stateVersion = "26.05";
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 25;
      };
    };

    nix = {
      settings.auto-optimise-store = true;
      extraOptions = ''
        experimental-features = nix-command flakes pipe-operators
        keep-outputs = true
        keep-derivations = true
      '';
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 2d";
      };
    };

    nixpkgs.overlays = [
      inputs.affinity-nix.overlays.default
      inputs.freesm.overlays.default
      inputs.copyparty.overlays.default
      (prev: final: {
        linux_hardened = final.linuxPackagesFor (final.callPackage ./../../_packages/linux-hardened.nix { });
        osu-resources = final.callPackage ./../../_packages/osu-resources.nix { };
        cdda-mods = final.callPackage ./../../_packages/cdda-mods { };
        seanime = inputs.custompkgs.packages.${final.stdenv.hostPlatform.system}.seanime;
        lucy-hyprcursor = inputs.hyprskiicursors.packages.${final.stdenv.hostPlatform.system}.lucy-hyprcursor.override { inherit (final) requireFile; };
        zen-browser = final.wrapFirefox
          inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.zen-browser-unwrapped
          {
            extraPolicies = {
              DisableTelemetry = true;
              SearchEngines = {
                Default = "ddg";
                Add = [
                  {
                    Name = "nixpkgs packages";
                    URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                    IconURL = "https://wiki.nixos.org/favicon.ico";
                    Alias = "@np";
                  }
                  {
                    Name = "NixOS options";
                    URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                    IconURL = "https://wiki.nixos.org/favicon.ico";
                    Alias = "@no";
                  }
                  {
                    Name = "NixOS Wiki";
                    URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                    IconURL = "https://wiki.nixos.org/favicon.ico";
                    Alias = "@nw";
                  }
                  {
                    Name = "noogle";
                    URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                    IconURL = "https://noogle.dev/favicon.ico";
                    Alias = "@ng";
                  }
                ];
              };
            };
          };
      })
    ];
  };
}

