lib:
{
  default = {
    home.stateVersion = "26.05";
  };
}
// (lib.genAttrs [
  "git"
  "zsh"
  "xdg"
] (moduleName: ./${moduleName}))

