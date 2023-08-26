# dotfiles

Have I mentioned that I use Arch?

These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/). 
To use my dotfiles for a particular program, clone this repo, cd into the root
directory, and type `stow <foldername>`.


## Note:

Keydrc needs to be linked to /etc/keyd/default.conf. Run

`sudo ln -sf ~/.dotfiles/keyd /etc/keyd`
