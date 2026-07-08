if status is-interactive
    set -U fish_greeting
    set -gx EDITOR hx
    set -gx COLORTERM truecolor
    set -gx TERM xterm-256color
    set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

    atuin init fish | source
    zoxide init fish | source
    keychain --quiet --eval ~/.ssh/id_ed25519 | source
end

function zellij_tab_name_update --on-variable PWD
    if set -q ZELLIJ
        set tab_name ''
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set git_root (basename (git rev-parse --show-toplevel))
            set git_prefix (git rev-parse --show-prefix)
            set tab_name "$git_root/$git_prefix"
            set tab_name (string trim -c / "$tab_name") # Remove trailing slash
        else
            set tab_name $PWD
            if test "$tab_name" = "$HOME"
                set tab_name "~"
            else
                set tab_name (basename "$tab_name")
            end
        end
        command nohup zellij action rename-tab $tab_name >/dev/null 2>&1 &
    end
end

# uv
fish_add_path "/home/michael/.local/bin"
