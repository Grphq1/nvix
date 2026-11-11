{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "lsp-lens";
  version = "main";

  doCheck = false;

  src = pkgs.fetchFromGitHub {
    owner = "VidocqH";
    repo = "lsp-lens.nvim";
    rev = "48bb1a7e271424c15f3d588d54adc9b7c319d977";
    sha256 = "sha256-zj/Gn/40jnDNh05OFc23LNNuFn1PnIAUDfPquEWpAlk=";
  };
}

