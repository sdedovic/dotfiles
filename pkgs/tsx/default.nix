{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  tsx,
  pnpm_9,
  nodejs_22,
}:
stdenv.mkDerivation rec {
  pname = "tsx";
  version = "4.19.3";

  src = fetchFromGitHub {
    owner = "privatenumber";
    repo = "tsx";
    rev = "v${version}";
    hash = "sha256-wdv2oqJNc6U0Fyv4jT+0LUcYaDfodHk1vQZGMdyFF/E=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-57KDZ9cHb7uqnypC0auIltmYMmIhs4PWyf0HTRWEFiU=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_9.configHook
  ];

  buildInputs = [
    nodejs_22
  ];

  # if the docs directory is registered as a workspace, pnpm will symlink
  #  it and since we don't care about publishing HTML documentation, this
  #  causes nix to fail due to the dangling symlink
  patches = [./remove-docs.patch];

  # similar to above, this is required so pnmp doesn't create tons of
  #  dangling symlinks
  # pnmpInstallFlags = ["--shamefully-hoist"];
  buildPhase = ''
    npm run build

    pnpm prune --prod
    find node_modules -xtype l -delete
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/tsx}
    cp -r {dist,node_modules} $out/lib/tsx
    chmod +x $out/lib/tsx/dist/cli.mjs
    ln -s $out/lib/tsx/dist/cli.mjs $out/bin/tsx
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = tsx;
    };
  };

  meta = with lib; {
    description = "TypeScript Execute (tsx): The easiest way to run TypeScript in Node.js";
    homepage = "https://tsx.is";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "tsx";
  };
}
