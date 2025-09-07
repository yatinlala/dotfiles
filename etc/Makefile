TARGET   := /etc
PACKAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n')

all:
	sudo stow --dotfiles --target=$(TARGET) $(PACKAGES)

clean:
	sudo stow --dotfiles -D --target=$(TARGET) $(PACKAGES)

stow-%:
	sudo stow --dotfiles --target=$(TARGET) $*

unstow-%:
	sudo stow --dotfiles -D --target=$(TARGET) $*
