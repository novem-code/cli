# Novem CLI

This is the public distribution repository for the Novem terminal application
and command-line interface. Release binaries and checksums are published here.
Signing and package-manager distribution are planned.

## Downloads

Download the latest binary from
[GitHub Releases](https://github.com/novem-code/cli/releases/latest):

| Platform | Asset |
| --- | --- |
| Linux x86_64 | `novem-x86_64-unknown-linux-musl` |
| Linux ARM64 | `novem-aarch64-unknown-linux-musl` |
| macOS Apple Silicon | `novem-aarch64-apple-darwin` |
| macOS Intel | `novem-x86_64-apple-darwin` |
| Windows x86_64 | `novem-x86_64-pc-windows-msvc.exe` |

Linux releases are statically linked. The macOS and Linux downloads may need
to be made executable after download:

```sh
chmod +x novem-*
```

Verify downloads against the `SHA256SUMS` file attached to the same release.

Installation through Homebrew, WinGet, npm, and PyPI is planned. Until those
channels are available, the GitHub Release assets are the canonical binaries.

## Nix

The flake installs the prebuilt release binary, verified against a pinned SHA-256
hash. It supports `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, and
`aarch64-darwin`. Both `packages.<system>.novem` and
`packages.<system>.default` provide the CLI.

With flakes enabled (`experimental-features = nix-command flakes`), add this
input to your configuration's flake:

```nix
inputs.novem = {
  url = "github:novem-code/cli";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Include `novem` in your flake's `outputs` arguments. For example, a NixOS
configuration can install it like this:

```nix
outputs = { nixpkgs, novem, ... }: {
  nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      ({ pkgs, ... }: {
        environment.systemPackages = [
          novem.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      })
    ];
  };
};
```

Use the same package in `environment.systemPackages` for nix-darwin or
`home.packages` for Home Manager. Intel macOS requires nixpkgs 26.05; omit the
`follows` line if your own nixpkgs input no longer supports that platform.

Alternatively, add `novem.overlays.default` to `nixpkgs.overlays` and install
`pkgs.novem`.

To try Novem without adding it to your configuration or profile:

```sh
nix run github:novem-code/cli -- --version
```

The package definition is in `nix/package.nix` and can also be used with
`pkgs.callPackage ./nix/package.nix { }`. Release versions, targets, and hashes
are stored in `nix/release.json`. To package a new release, update its version
and all four hashes there using that release's `SHA256SUMS` (convert
each hash with `nix hash convert --hash-algo sha256 --to sri <hex-hash>`).
Run `nix flake check` to build and smoke-test the package on the current system;
`nix flake check --all-systems --no-build` evaluates every supported platform.
The committed `flake.lock` pins nixpkgs; update it with `nix flake update nixpkgs`.

For product documentation, visit [novem.io](https://novem.io).
