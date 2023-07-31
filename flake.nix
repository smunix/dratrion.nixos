{
  description = "λ well-tailored and configureable NixOS system!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=master";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # xmonad.url = "github:xmonad/xmonad?ref=9189d002dd8ed369b822b10dcaae4bb66d068670";
    xmonad.url = "github:xmonad/xmonad?ref=master";
    # TODO: (-) xmonad-contrib after "ConditionalLayoutModifier" merge
    xmonad-contrib.url = "github:icy-thought/xmonad-contrib";
    taffybar.url = "github:taffybar/taffybar";
    emacs.url = "github:nix-community/emacs-overlay";
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    rust.url = "github:oxalica/rust-overlay";
    zig-overlay.url = "github:mitchellh/zig-overlay?ref=main";
    zig = {
      url = "github:ziglang/zig?ref=master";
      # url = "github:ziglang/zig?rev=e863292fe2f280945d914e7e98fbc704b68f1004";
      flake = false;
    };
    gyro = {
      url = "github:mattnite/gyro?ref=master";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    inherit (lib.my) mapModules mapModulesRec mapHosts;
    system = "x86_64-linux";

    mkPkgs = pkgs: extraOverlays:
      import pkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
    pkgs = mkPkgs nixpkgs [self.overlays.default];
    pkgs' = mkPkgs nixpkgs-unstable [];

    lib = nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit pkgs inputs;
        lib = final;
      };
    });
  in {
    lib = lib.my;

    overlays =
      (mapModules ./overlays import)
      // {
        default = final: prev: {
          unstable = pkgs';
          my = self.packages.${system};
	  inherit (inputs.zig-overlay.overlays.default final prev) zigpkgs;
        };
      };

    packages."${system}" = mapModules ./packages (p: pkgs.callPackage p {});

    nixosModules =
      {
        snowflake = import ./.;
      }
      // mapModulesRec ./modules import;

    nixosConfigurations = mapHosts ./hosts {};

    devShells."${system}".default = import ./shell.nix {inherit pkgs;};

    templates.full =
      {
        path = ./.;
        description = "λ well-tailored and configureable NixOS system!";
      }
      // import ./templates;

    templates.default = self.templates.full;

    # TODO: deployment + template tool.
    # apps."${system}" = {
    #   type = "app";
    #   program = ./bin/hagel;
    # };
  };
}
