if status is-interactive
    # Commands to run in interactive sessions can go here
end

if ! type --query mise
    curl https://mise.run | sh
end

if type --query mise
    mise activate fish | source
end

set -x EDITOR nvim

alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../../'

alias	o open
alias	cls clear

alias ob objdump
alias re readelf
alias ni ninja

alias +x 'chmod +x'
alias psg 'ps aux | rg'

fish_add_path -p -m ~/.local/bin/

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

if string length -q -- $TMUX
    function nt
        tmux new-window $argv -- fish
    end
end

