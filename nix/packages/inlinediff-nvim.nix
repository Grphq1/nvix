{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "inlinediff-nvim";
  version = "feat/cursor-highlight-and-colorscheme-support";

  doCheck = false;

  src = pkgs.fetchFromGitHub {
    owner = "grphq1";
    repo = "inlinediff-nvim";
    rev = "1d8b4505f97eb22ac6ce9b05796d37440745571d";
    sha256 = "sha256-lxbFY7tai5RwTzRCuQ1DNEnhhWtgtT9zhkFpJzoxxto=";
  };
}

