# dotfiles

![desktop](https://github.com/user-attachments/assets/4e7ab6fb-7bcf-4b56-9263-39cea55fb854)

My personal Arch Linux configuration. Take what you like.

These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/).

Using stow terminology: \
  `(sudo) make` installs every package in the Stow directory. \
  `make PACKAGE=<package-name>` installs à la carte.

## Notes:
1. `stow .` when `--target` and `--dir` is doesn't seem to work, though stowing individual packages is fine. For now, I'm using a makefile to expand a wildcard. I think there is a bug filed for this w/ Stow, but the project is abandoned?
2. Consider getting rid of makefiles and using .stowrc instead? Could be simpler.
