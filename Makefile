SHELL := $(shell which bash)
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help


RED := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
BLUE := $(shell tput setaf 4)
MAGENTA := $(shell tput setaf 5)
CYAN := $(shell tput setaf 6)
RESETCOLOR := $(shell tput sgr0)

.PHONY: help ## Show this help
help:
	@grep -E '^\.PHONY: [a-zA-Z_-]+ .*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = "(: |##)"}; {printf "$(CYAN) %-30s$(RESETCOLOR) %s\n", $$2, $$3}' \
		| less --chop-long-lines --RAW-CONTROL-CHARS

.PHONY: home-manager ## Prints a diff of home-manager changes, then 
home-manager:
	@$(MAKE) home-manager-switch || $(MAKE) home-manager-fail

.PHONY: home-manager-switch
home-manager-switch:
	@echo "$(GREEN)rebuild-switch$(RESETCOLOR)"
	@echo "$(CYAN)Copying current home...$(RESETCOLOR)"
	@cp --verbose $${HOME}/.config/nixpkgs/home.nix .current-home.nix || true
	@cp --verbose $${HOME}/.config/nixpkgs/rofi.nix .current-rofi.nix || true
	@cp --verbose $${HOME}/.config/nixpkgs/polybar.nix .current-polybar.nix || true
	@delta --paging never -- .current-home.nix home.nix || true
	@delta --paging never -- .current-rofi.nix rofi.nix || true
	@delta --paging never -- .current-polybar.nix polybar.nix || true
	@delta --paging never -- .current-i3.nix i3.nix || true
	@echo "$(CYAN)Moving changed home...$(RESETCOLOR)"
	@cp --verbose home.nix $${HOME}/.config/nixpkgs/home.nix || true
	@cp --verbose rofi.nix $${HOME}/.config/nixpkgs/rofi.nix || true
	@cp --verbose polybar.nix $${HOME}/.config/nixpkgs/polybar.nix || true
	@cp --verbose i3.nix $${HOME}/.config/nixpkgs/i3.nix || true
	@echo "$(CYAN)Rebuilding...$(RESETCOLOR)"
	@home-manager -b backup switch

.PHONY: home-manager-fail
home-manager-fail:
	@echo
	@echo "$(RED)home-manager-fail$(RESETCOLOR)"
	@cp --verbose .current-home.nix $${HOME}/.config/nixpkgs/home.nix
	@cp --verbose .current-rofi.nix $${HOME}/.config/nixpkgs/rofi.nix
	@cp --verbose .current-polybar.nix $${HOME}/.config/nixpkgs/polybar.nix
	@cp --verbose .current-i3.nix $${HOME}/.config/nixpkgs/i3.nix

.PHONY: rebuild
rebuild:
	@$(MAKE) rebuild-switch || $(MAKE) rebuild-fail

.PHONY: rebuild-switch
rebuild-switch:
	@echo "$(GREEN)rebuild-switch$(RESETCOLOR)"
	@echo "$(CYAN)Copying current configurations...$(RESETCOLOR)"
	@cp --verbose /etc/nixos/configuration.nix .current-configuration.nix || true
	@delta --paging never -- .current-configuration.nix configuration.nix || true
	@echo "$(CYAN)Moving changed configurations...$(RESETCOLOR)"
	@sudo cp --verbose configuration.nix /etc/nixos/configuration.nix || true
	@echo "$(CYAN)Rebuilding...$(RESETCOLOR)"
	@sudo nixos-rebuild switch

.PHONY: rebuild-fail
rebuild-fail:
	@echo
	@echo "$(RED)rebuild-fail$(RESETCOLOR)"
	@sudo cp --verbose .current-configuration.nix /etc/nixos/configuration.nix
