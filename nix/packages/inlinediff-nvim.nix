{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "inlinediff-nvim";
  version = "main";

  doCheck = false;

  src = pkgs.fetchFromGitHub {
    owner = "grphq1";
    repo = "inlinediff-nvim";
    rev = "61ff12a5d1987563e20f61ea09f53b6ec8817504";
    sha256 = "sha256-PS7QN7BTnfcIIRIQuPHPj9v4aNyFQl89/7wrrGEs1E4=";
  };
}

