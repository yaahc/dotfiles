if status --is-interactive
    atuin init fish | source
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
    base16-default-dark

    fnm env --use-on-cd --shell fish | source

    # exports
    set --export LOCALSTACK_AUTH_TOKEN ls-mAbuLegu-9647-jUyU-2041-BAQiloLA465b
    set --export EDITOR nvim

    ulimit -n 4096

    fish_vi_key_bindings
    set PATH $PATH /Users/jlusby/.dotfiles/bin

    zellij setup --generate-completion fish | source

    function notify_long_commands --on-event fish_postexec
        # $CMD_DURATION is measured in milliseconds.
        if test $CMD_DURATION -ge 5000
            # Send a terminal bell / beep character
            echo -e "\a"
        end
    end
end

# Created by `pipx` on 2026-07-02 22:37:57
set PATH $PATH /Users/jlusby/.local/bin
starship init fish | source
