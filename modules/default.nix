{inputs, ...}: {
  # Reusable nixos modules you might want to export
  # These are usually stuff you would upstream into nixpkgs
  nixosModules = import ./nixos;
  # Reusable home-manager modules you might want to export
  # These are usually stuff you would upstream into home-manager
  homeManagerModules = import ./home-manager;
  # Reusable home-manager modules you might want to export
  # These are usually stuff you would upstream into nix-darwin
  darwinModules = import ./nix-darwin;
}
