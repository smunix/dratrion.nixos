{
  description = "dratrion configuration";
  inputs = {
    # nixpkgs.url = github:NixOs/nixpkgs/nixpkgs-unstable;
    nixpkgs.url = github:NixOs/nixpkgs/master;
    nix.url = github:NixOs/nix/master;
    nixos.url = github:NixOs/nixpkgs/nixos-unstable-small;
    nur.url = github:nix-community/NUR;
  };
  outputs = { nixpkgs, nixos, nix, self, ... }@inputs: {
    nixosConfigurations.dratrion = nixos.lib.nixosSystem {
      system = builtins.currentSystem;
      modules = [
        (import ./configuration.nix)
      ];
      specialArgs = {
        inherit inputs;
      };
    };
  };
}
