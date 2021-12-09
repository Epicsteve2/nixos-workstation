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

HOME_FILES := home rofi polybar i3 alacritty picom vscode

.PHONY: help ## Show this help
help:
	@grep -E '^\.PHONY: [a-zA-Z_-]+ .*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = "(: |##)"}; {printf "$(CYAN) %-30s$(RESETCOLOR) %s\n", $$2, $$3}' \
		| less --chop-long-lines --RAW-CONTROL-CHARS

.PHONY: home-manager ## Prints a diff of home-manager changes, then switches
home-manager:
	@$(MAKE) home-manager-switch || $(MAKE) home-manager-fail

.PHONY: home-manager-switch ## Copy current files to ~/.config/nixpkgs, then switches
home-manager-switch:
	@echo "$(GREEN)rebuild-switch$(RESETCOLOR)"
	@echo "$(CYAN)Copying current home...$(RESETCOLOR)"
	@for FILE in $(HOME_FILES); do \
		cp --verbose $${HOME}/.config/nixpkgs/$${FILE}.nix .current-$${FILE}.nix || true; \
	done
	@for FILE in $(HOME_FILES); do \
		delta --paging never -- .current-$${FILE}.nix $${FILE}.nix || true; \
	done

	@echo "$(CYAN)Moving changed home...$(RESETCOLOR)"
	@for FILE in $(HOME_FILES); do \
		cp --verbose $${FILE}.nix $${HOME}/.config/nixpkgs/$${FILE}.nix || true; \
	done

	@echo "$(CYAN)Rebuilding...$(RESETCOLOR)"
	@home-manager -b backup switch

.PHONY: home-manager-fail
home-manager-fail:
	@echo
	@echo "$(RED)home-manager-fail$(RESETCOLOR)"
	@for FILE in $(HOME_FILES); do \
		cp --verbose .current-$${FILE}.nix $${HOME}/.config/nixpkgs/$${FILE}.nix || true; \
	done

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
