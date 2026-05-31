{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.starship.frosted-kebab;
in
{
  config.programs.starship = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = lib.concatStrings [
        "[╭─ $directory"
        "$git_branch$git_status"
        "$rust"
        "\n╰─ $username"
        "$cmd_duration"
        "$character"
        "](fg:base03)"
      ];

      username = {
        show_always = true;
        style_user = "fg:purple";
        style_root = "fg:red";
        format = "[󱄅](fg:cyan) [$user]($style)";
      };

      directory = {
        style = "fg:purple";
        truncation_length = 3;
        truncation_symbol = ".../";
        format = "[$path]($style)";

        substitutions = {
          "Documents" = "󰈙";
          "Downloads" = "";
          "Music" = "󰝚";
          "Pictures" = "";
        };
      };

      git_branch = {
        symbol = "";
        format = " ─ [$symbol $branch](fg:blue)";
      };

      git_status = {
        format = " ─ [(「$all_status $ahead_behind」)](fg:cyan)";
      };

      rust = {
        symbol = "";
        format = " ─ [$symbol ($version)](fg:orange)";
      };

      cmd_duration = {
        disabled = false;
        format = "[  in $duration](fg:base02)";
        show_milliseconds = true;
        show_notifications = true;
        min_time_to_notify = 15000;
      };

      line_break.disabled = true;
      character = {
        disabled = false;
        success_symbol = "[ ](bold fg:blue)";
        error_symbol = "[ ](bold fg:red)";
        vimcmd_symbol = "[ ](bold fg:blue)";
        vimcmd_replace_one_symbol = "[ ](bold fg:purple)";
        vimcmd_replace_symbol = "[ ](bold fg:purple)";
        vimcmd_visual_symbol = "[ ](bold fg:orange)";
      };
    };
  };
}
