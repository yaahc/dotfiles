## Yaah's dotfiles

my personal configuration for linux machines

### Setup

setup 1password for ssh-agent (enabled in developer options): https://developer.1password.com/docs/ssh/get-started/

setup rcm and install dotfiles

```bash
git clone git@github.com:yaahc/dotfiles.git ~/.dotfiles
sudo apt install rcm
rcup
```

Setup all the other random things I need (not comprehensive)

* atuin (first so we can update notes here from history next time): https://atuin.sh/
* base16-shell: https://github.com/chriskempson/base16-shell?tab=readme-ov-file#installation
* starship: https://starship.rs/guide/#%F0%9F%9A%80-installation
    * nerdfont
* logseq
* neovim
    * vim plug: https://github.com/junegunn/vim-plug?tab=readme-ov-file#installation (I think I can automate this, or I might have already done so in the past, try the automated route next time)
        * `:PlugInstall` in vim
        * fzf will get installed automatically here from the repo
    * powerline fonts
* tmux
    * tpm: https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation
        * `tmux attach` to enter tmux
        * `<Space>+I` in tmux to install plugins
