# dotfiles

Have I mentioned that I use Arch?

These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/). 
To use my dotfiles for a particular program, clone this repo, cd into the root
directory, and type `stow <foldername>`.

TODO 
stow doesn't --target and --dir doesn't work with stow . investigate further


## Note:

Keydrc needs to be linked to /etc/keyd/default.conf. Run

`sudo ln -sf ~/.dotfiles/keyd /etc/keyd`
