{
  lib,
  stdenv,
  fetchurl,
  gmp,
  glibc,
  makeWrapper,
  withGlibc ? false
}:

stdenv.mkDerivation (finalAttrs: {
  name = "lambdananas";
  version = "2.4.3.2";

  src = let
    repo = "https://github.com/Epitech/lambdananas";
  in fetchurl {
    url = lib.strings.concatStringsSep "/" [
      repo
      "releases/download"
      "v${finalAttrs.version}"
      "lambdananas"
    ];
    hash = "sha256-WcZOYCwl/tuxxRMbCwia+zXDijnVR/wyGwM4PRKwxNc=";
  };

  dontUnpack = true;
  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = let
    ld-lib-path = lib.makeLibraryPath
     ([ gmp ] ++ (lib.optionals withGlibc [ glibc ]));
  in ''
    install -m755 -D $src $out/bin/lambdananas

    wrapProgram $out/bin/lambdananas \
      --set LD_LIBRARY_PATH "${ld-lib-path}"
  '';

  meta = {
    description = "Epitech haskell coding style checker";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
