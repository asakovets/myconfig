from install_core import *

if isMac or isLinux:
    doInst(File("fish/config.fish"), Dir("~/.config/fish/"))

doInst(File("wezterm/wezterm.lua"), Dir("~/.config/wezterm/"))

if isMac or isLinux:
    doInst(File("tmux/tmux.conf"), File("~/.tmux.conf"))

if isMac or isLinux:
    doInst(Dir("kitty"), Dir("~/.config/kitty/"))
