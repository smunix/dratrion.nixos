{
  description = "dratrion configuration";
  inputs = {
    # nixpkgs.url = github:NixOs/nixpkgs/nixpkgs-unstable;
    # nixpkgs.url = github:NixOs/nixpkgs/master;
    # https://github.com/nix-community/home-manager
    # https://github.com/nix-community/nix-doom-emacs
    # https://github.com/nix-community/home-manager/issues/1877
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixF.url = "github:nixos/nix?rev=7ec244aec2d3ebe36b7495a2321a05f02f0b4186";
    nixos.url = "github:nixos/nixpkgs/master";
    # nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-hls.url = "github:haskell/haskell-language-server?ref=master";
    nix-smunix-pkgs.url = "github:smunix/nixpkgs-unfree?ref=main";
    nix-colmena.url = "github:zhaofengli/colmena?ref=main";
    smunix-nur.url = "gitlab:smunix.nixos/nur-packages?ref=master";
    moletrooper-dotfiles = {
      url = "github:smunix/dotfiles-1?ref=master";
      flake = false;
    };
    eww.url = "github:elkowar/eww?ref=master";
    jpicom = {
      url = "github:jonaburg/picom?ref=next";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixos, nixF, home-manager, nix-doom-emacs
    , emacs-overlay, nix-smunix-pkgs, nix-hls, nix-colmena, smunix-nur
    , moletrooper-dotfiles, eww, jpicom, ... }@inputs: {
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
              users = {
                smunix = import ./smunix.home.nix inputs;
                root = import ./root.home.nix inputs;
              };
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
