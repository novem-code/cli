{
  description = "Prebuilt Novem command-line interface";

  # 26.05 also supports Intel macOS, which newer nixpkgs releases have dropped.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          novem = pkgs.callPackage ./nix/package.nix { };
        in
        {
          inherit novem;
          default = novem;
        }
      );

      apps = forAllSystems (system: {
        novem = {
          type = "app";
          program = "${self.packages.${system}.novem}/bin/novem";
          meta.description = self.packages.${system}.novem.meta.description;
        };
        default = self.apps.${system}.novem;
      });

      checks = forAllSystems (system: {
        inherit (self.packages.${system}) novem;
      });

      overlays.default = final: _prev: {
        novem = final.callPackage ./nix/package.nix { };
      };
    };
}
