local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local config = wezterm.config_builder()

local IS_MAC = wezterm.target_triple:find("darwin") ~= nil
local IS_WINDOWS = wezterm.target_triple:find("windows") ~= nil
local IS_LINUX = wezterm.target_triple:find("linux") ~= nil

-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

config.enable_scroll_bar = true
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.quick_select_remove_styling = true
config.warn_about_missing_glyphs = false

if IS_WINDOWS then
    config.default_prog = { 'pwsh.exe', '-NoLogo' }
end

-- config.window_background_opacity = 0.85
-- config.font_size = 13
-- config.font = wezterm.font("jetbrains mono", { weight = "Regular" })
-- config.color_scheme = 'Solarized (light) (terminal.sexy)'

local f,err = loadfile(wezterm.config_dir.."/wezterm-local.lua")
if err then
    wezterm.log_error(err)
else
    f().apply_to_config(config)
end

config.leader = { key = ",", mods = "CTRL" }
config.keys = {
    { key = "{", mods = "SHIFT|ALT", action = act.ActivateTabRelative(-1) },
    { key = "}", mods = "SHIFT|ALT", action = act.ActivateTabRelative(1) },
    { key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = ",", mods = "CTRL|LEADER", action = act.SendKey({ key = ",", mods = "CTRL" }) },

    { key = "l", mods = "ALT", action = act.ShowLauncher },
    { key = "m", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
        win:maximize()
    end) },
    { key = "f", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
        win:toggle_fullscreen()
    end) },

    { key = "Home", mods = "SHIFT", action = act.ScrollToTop },

    --= Panes
    { key = "b", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "v", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    -- Navigate panes
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
      -- Resize pane
    { key = "LeftArrow",  mods = "CTRL|ALT", action = act.AdjustPaneSize {"Left", 3}},
    { key = "RightArrow", mods = "CTRL|ALT", action = act.AdjustPaneSize {"Right", 3}},
    { key = "UpArrow",    mods = "CTRL|ALT", action = act.AdjustPaneSize {"Up", 3}},
    { key = "DownArrow",  mods = "CTRL|ALT", action = act.AdjustPaneSize {"Down", 3}},
}

for i = 1, 9 do
    table.insert(config.keys, { key = tostring(i), mods = "ALT", action = act.ActivateTab(i - 1) })
end

config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        action = act.ScrollByLine(-3),
    },
    {
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        action = act.ScrollByLine(3),
    },
    {
        event = { Down = { streak = 3, button = 'Left' } },
        action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
        mods = 'NONE',
    },
}

if IS_WINDOWS then
    local launch_menu = {}
    local ok, stdout, stderr =
        wezterm.run_child_process {
        "C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe",
        "-nologo",
        "-utf8",
        "-format",
        "json",
    }

    if ok then
        for _, vs in ipairs(wezterm.serde.json_decode(stdout)) do
            local installPath = vs["installationPath"]
            local productLine = vs["catalog"]["productLineVersion"]
            local vcvarsPath = installPath .. "\\VC\\Auxiliary\\Build\\vcvars64.bat"
            table.insert(
                launch_menu,
                {
                    label = "x64 Native Tools VS " .. productLine,
                    args = {
                        "cmd.exe",
                        "/k",
                        vcvarsPath
                    }
                }
            )
        end
    end

    config.launch_menu = launch_menu
end

return config
