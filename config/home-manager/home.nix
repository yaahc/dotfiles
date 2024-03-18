{ config, pkgs, ... }:

{
    home.username = "yaahc";
    home.homeDirectory = "/home/yaahc";

# Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

        home.packages = [
        pkgs.gdb
            pkgs.meld
            pkgs.jujutsu
            pkgs.rr
            pkgs.neovim
            pkgs.ripgrep
            pkgs.fzf
            pkgs.git
            pkgs.discord
            pkgs.rcm
            pkgs.rustup
            pkgs.sccache
            pkgs.tmux
            pkgs.nodejs_20
            pkgs.clang
            pkgs.wl-clipboard
            pkgs.delta
            pkgs.universal-ctags
            pkgs.topgrade
            pkgs.openssl.dev
            pkgs.pkg-config
            pkgs.gh
            pkgs.nushell
# todo manage base16-shell declaratively somehow
            ];
}
