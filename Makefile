SHELL := $(shell which bash)
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := rebuild


RED := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
BLUE := $(shell tput setaf 4)
MAGENTA := $(shell tput setaf 5)
CYAN := $(shell tput setaf 6)
RESETCOLOR := $(shell tput sgr0)

.PHONY: rebuild
rebuild:
	@$(MAKE) rebuild-switch || $(MAKE) rebuild-fail

.PHONY: rebuild-switch
rebuild-switch:
	@echo "$(GREEN)rebuild-switch$(RESETCOLOR)"
	@echo "$(CYAN)Copying current configurations...$(RESETCOLOR)"
	@cp --verbose /etc/nixos/configuration.nix .current-configuration.nix || true
	@delta .current-configuration.nix configuration.nix || true
	@echo "$(CYAN)Moving changed configurations...$(RESETCOLOR)"
	@sudo cp --verbose configuration.nix /etc/nixos/configuration.nix || true
	@echo "$(CYAN)Rebuilding...$(RESETCOLOR)"
	@sudo nixos-rebuild switch

.PHONY: rebuild-fail
rebuild-fail:
	@echo
	@echo "$(RED)rebuild-fail$(RESETCOLOR)"
	@sudo cp --verbose .current-configuration.nix /etc/nixos/configuration.nix

.PHONY: home-manager
home-manager:
	@$(MAKE) home-manager-switch || $(MAKE) home-manager-fail

.PHONY: home-manager-switch
home-manager-switch:
	@echo "$(GREEN)rebuild-switch$(RESETCOLOR)"
	@echo "$(CYAN)Copying current home...$(RESETCOLOR)"
	@cp --verbose $${HOME}/.config/nixpkgs/home.nix .current-home.nix || true
	@delta .current-home.nix home.nix || true
	@echo "$(CYAN)Moving changed home...$(RESETCOLOR)"
	@cp --verbose home.nix $${HOME}/.config/nixpkgs/home.nix || true
	@echo "$(CYAN)Rebuilding...$(RESETCOLOR)"
	@home-manager -b backup switch

.PHONY: home-manager-fail
home-manager-fail:
	@echo
	@echo "$(RED)home-manager-fail$(RESETCOLOR)"
	@cp --verbose .current-home.nix $${HOME}/.config/nixpkgs/home.nix

help:
	@echo hi