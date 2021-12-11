# { pkgs ? import <nixpkgs> { } }:
# TODO: Completions here
# https://github.com/go-task/task/blob/master/completion/zsh/_task
# pkgs.mkShell { nativeBuildInputs = [ pkgs.go-task ]; }

with import <nixpkgs> { };
mkShell rec {
  buildInputs = [
    pkgs.go-task
  ];

  shellHook = ''
    zinit ice as"completion"; zinit snippet https://github.com/go-task/task/raw/master/completion/zsh/_task
  '';
}
