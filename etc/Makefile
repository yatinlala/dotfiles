TARGET := /etc
PACKAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -name Makefile -exec basename {} \;)

all:
	sudo stow --dotfiles --target=$(TARGET) $(PACKAGES)

clean:
	sudo stow --dotfiles -D --target=$(TARGET) $(PACKAGES)

stow:
	@if [ -z "$(PACKAGE)" ]; then \
		echo "Error: Please specify a PACKAGE. Usage: make stow PACKAGE=<package_name>"; \
		exit 1; \
	fi
	sudo stow --dotfiles --target=$(TARGET) $(PACKAGE)

unstow:
	@if [ -z "$(PACKAGE)" ]; then \
		echo "Error: Please specify a PACKAGE. Usage: make unstow PACKAGE=<package_name>"; \
		exit 1; \
	fi
	sudo stow --dotfiles -D --target=$(TARGET) $(PACKAGE)
