{
  description = "meowix: nixos configuration with sillyness added to it!";
  inputs = {
    ###########
    # nixpkgs #
    ###########

    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # Also see the 'stable-packages' overlay at 'overlays/default.nix'.

    ################
    # home-manager #
    ################
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ##############
    # nix-darwin #
    ##############
    nix-darwin = {
      url = "github.nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    ##########
    # System #
    ##########
    # Supported architecture for your flake packages, shell, etc.
    #FIXME: Change if you are copying the repo!
    systems = [
      # "aarch64-linux"
      # "i686-linux"
      "x86_64-linux"
      # "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    ###################
    # Custom Packages #
    ###################
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    #############
    # Formatter #
    #############
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    ############
    # Overlays #
    ############

    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs outputs;};

    ###########
    # Modules #
    ###########
    # This default.nix will automatically import both home-manager and nixos
    nixosModules = import ./modules;

    ##########################
    # NixOS Configuration(s) #
    ##########################

    # NOTE: 'nixos' is the default hostname
    nixosConfigurations = {
      "meowscarada" = nixpkgs.lib.nixosSystem {
        modules = [./hosts/meowscarada];
        specialArgs = {inherit inputs outputs;};
      };
      "lucario" = nixpkgs.lib.nixosSystem {
        modules = [./hosts/lucario];
        specialArgs = {inherit inputs outputs;};
      };
    };
    #################################
    # Home-Manager Configuratoin(s) #
    #################################
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "monyx@meowscarada" = home-manager.lib.homeManagerConfiguration {
        # Home-manager requires 'pkgs' instance
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # FIXME replace x86_64-linux with your architecure
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/linux];
      };
      "monyx@lucario" = home-manager.lib.homeManagerConfiguration {
        # Home-manager requires 'pkgs' instance
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # FIXME replace x86_64-linux with your architecure
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/linux];
      };
      "monyx@anubis" = home-manager.lib.homeManagerConfiguration {
        # Home-manager requires 'pkgs' instance
        pkgs = nixpkgs.legacyPackages.x86_64-darwin; # FIXME replace x86_64-linux with your architecure
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/macos]; # FIXME: WIP
      };
    };
    ###############################
    # nix-darwin Configuration(s) #
    ###############################
    # Standalone nix-darwin configuration entrypoint
    # Available through 'darwin-rebuild --flake .#your-hostname
    darwinConfigurations = {
      "anubis" = nix-darwin.lib.darwinSystem {
        modules = [./hosts/anubis]; # FIXME: WIP
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
