{
  description = "";
  inputs = {
    nixpkgs.url = github:NixOs/nixpkgs-channels/nixos-unstable;
    nur.url = github:nix-community/NUR;
  };
  outputs = { nixpkgs, nix, self, ... }@inputs: {
    nixosConfigurations.dratrion = nixpkgs.lib.nixosSystem {
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
