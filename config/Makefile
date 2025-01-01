TARGET := $(HOME)
PACKAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -name Makefile -exec basename {} \;)

all:
	stow --dotfiles --target=$(TARGET) $(PACKAGES)

clean:
	stow --dotfiles -D --target=$(TARGET) $(PACKAGES)
