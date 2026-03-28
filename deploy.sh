set -e

repodir=$(realpath $(dirname "$BASH_SOURCE"))
echo "repodir ${repodir}"

if [[ "$#" -eq 1 && "$1" == "-n" ]]; then
    dolink ()
    {
        echo "$2 -> ${repodir}/$1"
    }
else
    dolink ()
    {
        echo "$2 -> ${repodir}/$1"
        ln -sf "${repodir}/$1" "$2"
    }

fi

ens ()
{
    mkdir -p "$1"
}

ens ~/.config/fish && \
    dolink ~/.config/fish/fish.config fish/fish.config

ens ~/.config/wezterm && \
    dolink ~/.config/wezterm/wezterm.lua wezterm/wezterm.lua

dolink ~/.tmux.conf tmux/tmux.conf
