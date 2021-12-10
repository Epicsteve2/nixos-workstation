{ pkgs ? import <nixpkgs> { } }:
# TODO: Completions here
# https://github.com/go-task/task/blob/master/completion/zsh/_task
pkgs.mkShell { nativeBuildInputs = [ pkgs.go-task ]; }
