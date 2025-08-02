{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_latest,
  pnpm_9,
  cacert,
}: let
  version = "0.14.26"; # Updated version
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "tailwindcss-language-server";
    inherit version;

    src = fetchFromGitHub {
      owner = "tailwindlabs";
      repo = "tailwindcss-intellisense";
      rev = "v${finalAttrs.version}";
      hash = "sha256-XXRWxN+1fOuVULh+ZE+XRRBaoRzhCpw7n8SkBIorG9A=";
    };

    pnpmDeps = pnpm_9.fetchDeps {
      inherit
        (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        prePnpmInstall
        ;
      fetcherVersion = 1;
      hash = "sha256-SUEq20gZCiTDkFuNgMc5McHBPgW++8P9Q1MJb7a7pY8=";
    };

    nativeBuildInputs = [
      nodejs_latest
      pnpm_9.configHook
    ];

    buildInputs = [
      nodejs_latest
    ];

    pnpmWorkspaces = ["@tailwindcss/language-server..."];
    prePnpmInstall = ''
      pnpm config set dedupe-peer-dependents false
      export NODE_EXTRA_CA_CERTS="${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';

    buildPhase = ''
      runHook preBuild
      pnpm --filter "@tailwindcss/language-server..." build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,lib/tailwindcss-language-server}
      cp -r {packages,node_modules} $out/lib/tailwindcss-language-server
      chmod +x $out/lib/tailwindcss-language-server/packages/tailwindcss-language-server/bin/tailwindcss-language-server
      ln -s $out/lib/tailwindcss-language-server/packages/tailwindcss-language-server/bin/tailwindcss-language-server $out/bin/tailwindcss-language-server
      runHook postInstall
    '';

    meta = with lib; {
      description = "Tailwind CSS Language Server";
      homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense";
      license = licenses.mit;
      maintainers = [];
      mainProgram = "tailwindcss-language-server";
      platforms = platforms.all;
    };
  })
