# SHELL := $(shell which bash)
# .SHELLFLAGS := -eu -o pipefail -c

# RED := $(shell tput setaf 1)
# GREEN := $(shell tput setaf 2)
# YELLOW := $(shell tput setaf 3)
# BLUE := $(shell tput setaf 4)
# MAGENTA := $(shell tput setaf 5)
# CYAN := $(shell tput setaf 6)
# RESETCOLOR := $(shell tput sgr0)

.PHONY: rebuild
rebuild:
	@#echo $(GREEN)rebuild$(RESETCOLOR)
	$(MAKE) rebuild-switch || $(MAKE) rebuild-fail

.PHONY: rebuild-switch
rebuild-switch:
	@#echo $(GREEN)rebuild-switch$(RESETCOLOR)
	cp --verbose /etc/nixos/configuration.nix .current-configuration.nix || true
	delta .current-configuration.nix configuration.nix || true
	sudo cp --verbose configuration.nix /etc/nixos/configuration.nix || true
	sudo nixos-rebuild switch

.PHONY: rebuild-fail
rebuild-fail:
	@#echo $(GREEN)rebuild-fail$(RESETCOLOR)
	sudo cp --verbose .current-configuration.nix /etc/nixos/configuration.nix