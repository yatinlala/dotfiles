TARGET   := $(HOME)
PACKAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n')

all:
	stow --dotfiles --target=$(TARGET) $(PACKAGES)

clean:
	stow --dotfiles -D --target=$(TARGET) $(PACKAGES)

stow-%:
	stow --dotfiles --target=$(TARGET) $*

unstow-%:
	stow --dotfiles -D --target=$(TARGET) $*
