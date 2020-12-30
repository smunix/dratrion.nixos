{
  description = "";
  inputs = {
    nixpkgs.url = github:NixOs/nixpkgs/nixpkgs-unstable;
    nixos.url = github:NixOs/nixpkgs/nixos-unstable-small;
    nur.url = github:nix-community/NUR;
  };
  outputs = { nixpkgs, nixos, nix, self, ... }@inputs: {
    nixosConfigurations.dratrion = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./configuration.nix)
      ];
      specialArgs = {
        inherit inputs;
      };
    };
  };
}
