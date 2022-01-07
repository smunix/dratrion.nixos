{
  description = "dratrion configuration";
  inputs = {
    # nixpkgs.url = github:NixOs/nixpkgs/nixpkgs-unstable;
    # nixpkgs.url = github:NixOs/nixpkgs/master;
    # https://github.com/nix-community/home-manager
    # https://github.com/nix-community/nix-doom-emacs
    # https://github.com/nix-community/home-manager/issues/1877
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix.url = "github:nixos/nix?ref=master";
    nixos.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-hls.url = "github:haskell/haskell-language-server?ref=master";
    nix-haskell-updates.url = "github:NixOS/nixpkgs/haskell-updates";
    nix-smunix-pkgs.url = "github:smunix/nixpkgs-unfree?ref=main";
    nix-colmena.url = "github:zhaofengli/colmena?ref=main";
  };
  outputs = { self, nixpkgs, nixos, nix, home-manager, nix-doom-emacs
    , emacs-overlay, nix-haskell-updates, nix-smunix-pkgs, nix-hls, nix-colmena
    , ... }@inputs: {
      nixosConfigurations.dratrion = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./configuration.nix)
          home-manager.nixosModule
          {
            home-manager = {
              backupFileExtension = "backup.hm";
              useGlobalPkgs = false;
              useUserPackages = true;
              users.smunix = import ./smunix.home.nix inputs;
              users.root = import ./root.home.nix inputs;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
