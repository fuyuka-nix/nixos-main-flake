{
  inputs = {
    fuyupkgs = {
      type = "path";
      path = "./packages";
    };
  };

  outputs =
    {
      fuyupkgs,
      ...
    }:
    {
      nixosConfigurations = import ./hosts fuyupkgs;
    };
}
