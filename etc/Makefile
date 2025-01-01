TARGET := /etc
PACKAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -name Makefile -exec basename {} \;)

all:
	sudo stow --dotfiles --target=$(TARGET) $(PACKAGES)

clean:
	sudo stow --dotfiles -D --target=$(TARGET) $(PACKAGES)
