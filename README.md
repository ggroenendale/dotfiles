## Initial Readme for dotfiles repo.

In order to let gnu stow copy our dotfiles into our home directory, we first need to install gnu stow.

Debian/Ubuntu

```bash
sudo apt install stow
```

Arch

```bash
sudo pacman -S stow
```

Then we need to make sure our `/.dotfiles` folder lives in our home directory. So we can git clone
this repo into our home directory as .dotfiles.

```bash
cd ~
git clone https://github.com/ggroenendale/dotfiles.git .dotfiles
```

Then once we have all of the files onto the device that we want, we run gnu stow in order to symlink our dotfiles to the
home directory. The magic bit here about symlinking the folders into the home directory is due to stow symlinking to one
folder above by default.

```bash
cd ~/.dotfiles
stow .
```

> NOTE: stow by default ignores the `/.git` folder. If we want to ignore other files we can create a `.stow-local-ignore`
> file and make entries similar to .gitignore entries.
