lib:
{
  default = {
    home.stateVersion = "25.11";
  };
}
// (lib.genAttrs [
  "git"
  "zsh"
  "xdg"
] (moduleName: ./${moduleName}))

