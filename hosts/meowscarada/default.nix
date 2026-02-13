{outputs, ...}: {
  imports = [
    outputs.nixosModules.base
    ./configuration.nix
  ];
}
