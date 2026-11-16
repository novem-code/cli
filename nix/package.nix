{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  releaseInfo = lib.importJSON ./release.json;
  inherit (releaseInfo) version;
  releases = releaseInfo.platforms;
  release =
    releases.${stdenvNoCC.hostPlatform.system}
      or (throw "Novem has no prebuilt binary for ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "novem";
  inherit version;

  src = fetchurl {
    url = "https://github.com/novem-code/cli/releases/download/v${version}/novem-${release.target}";
    inherit (release) hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # Preserve the upstream binaries, including macOS code signatures.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/novem"
    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$("$out/bin/novem" --version)" = "novem ${version}"
    "$out/bin/novem" --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Novem terminal application and command-line interface";
    homepage = "https://novem.io";
    downloadPage = "https://github.com/novem-code/cli/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames releases;
    mainProgram = "novem";
  };
}
