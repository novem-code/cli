# Novem CLI

This is the public distribution repository for the Novem terminal application
and command-line interface. Release binaries, checksums, signatures, and
package-manager metadata are published here.

## Downloads

Download the latest binary from
[GitHub Releases](https://github.com/novem-code/cli/releases/latest):

| Platform | Asset |
| --- | --- |
| Linux x86_64 | `novem-x86_64-unknown-linux-musl` |
| macOS Apple Silicon | `novem-aarch64-apple-darwin` |
| Windows x86_64 | `novem-x86_64-pc-windows-msvc.exe` |

Linux releases are statically linked. The macOS and Linux downloads may need
to be made executable after download:

```sh
chmod +x novem-*
```

Verify downloads against the `SHA256SUMS` file attached to the same release.

Installation through Homebrew, WinGet, npm, and PyPI is planned. Until those
channels are available, the GitHub Release assets are the canonical binaries.

For product documentation, visit [novem.io](https://novem.io).
