{
  pkgs,
  stdenv,
  makeWrapper,
  argc,
  ...
}:
let
  included-packages = with pkgs; [
    findutils
    which
    jq
    ripgrep

    doctl

    less
    groff
    awscli2

    docker-client
  ];
in
stdenv.mkDerivation rec {
  name = "ci-tool";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin

    ${argc}/bin/argc --argc-build ci-tool.sh $out/bin/

    mv $out/bin/ci-tool.sh $out/bin/ci-tool
    wrapProgram $out/bin/ci-tool \
      --prefix PATH : ${pkgs.lib.makeBinPath included-packages}
  '';
}
