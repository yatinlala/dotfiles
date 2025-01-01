TARGET := $(HOME)
PACKAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -name Makefile -exec basename {} \;)

all:
	stow --dotfiles --target=$(TARGET) $(PACKAGES)

clean:
	stow --dotfiles -D --target=$(TARGET) $(PACKAGES)

stow:
	@if [ -z "$(PACKAGE)" ]; then \
		echo "Error: Please specify a PACKAGE. Usage: make stow PACKAGE=<package_name>"; \
		exit 1; \
	fi
	stow --dotfiles --target=$(TARGET) $(PACKAGE)

unstow:
	@if [ -z "$(PACKAGE)" ]; then \
		echo "Error: Please specify a PACKAGE. Usage: make unstow PACKAGE=<package_name>"; \
		exit 1; \
	fi
	stow --dotfiles -D --target=$(TARGET) $(PACKAGE)
