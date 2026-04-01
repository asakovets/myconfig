set -e

repodir=$(realpath $(dirname "$BASH_SOURCE"))
echo "repodir ${repodir}"

linuxp() {
	[[ $OSTYPE = "linux-gnu" ]] || false
}

macp() {
	[[ $OSTYPE == "darwin"* ]] || false
}

winp() {
	[[ $OSTYPE = "msys" ]] || false
}

if [[ "$#" -eq 1 && "$1" == "-n" ]]; then
	dolink() {
		echo "$1 -> ${repodir}/$2"
	}
else
	dolink() {
		echo "$1 -> ${repodir}/$2"
		ln -sf "${repodir}/$2" "$1"
	}

fi

ens() {
	mkdir -p "$1"
}

(macp || linuxp) &&
	ens ~/.config/fish &&
	dolink ~/.config/fish/config.fish fish/config.fish

ens ~/.config/wezterm &&
	dolink ~/.config/wezterm/wezterm.lua wezterm/wezterm.lua

(macp || linuxp) &&
	dolink ~/.tmux.conf tmux/tmux.conf
