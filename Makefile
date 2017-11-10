.PHONY: help install dependencies

help:
	@echo "install           Setup symlinks for dotfiles and copy system configuration files."
	@echo "dependencies      Install required system packages"


install:
	@echo "Symlinking dotfiles..."
	@echo "Copying system configuration files..."


dependencies: aur
	@echo "Installing system dependencies..."


aur: core
	@echo "Installing AUR package manager..."


core:
	@echo "Installing core packages..."
	sudo pacman -Syy
	sudo pacman -S --noconfirm base-devel wget

