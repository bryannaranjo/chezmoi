-- ~/.wezterm.lua
-- WezTerm configuration tuned for running yazi on Windows.

local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- =========================================================================
-- Appearance
-- =========================================================================

-- Matches your yazi theme.toml (catppuccin-frappe).
config.color_scheme = 'Catppuccin Frappe'

-- A Nerd Font is required for yazi's file-type icons to render correctly.
-- Install with: winget install --id=DEVCOM.JetBrainsMonoNerdFont
-- Fallback order: primary font → broad Nerd Font symbol coverage →
-- Windows emoji → plain mono fallbacks. The Symbols Nerd Font Mono entry
-- covers any Material Design / Devicon / Octicon glyphs that the main
-- JetBrainsMono Nerd Font build might be missing.
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'Symbols Nerd Font Mono',
  'Segoe UI Emoji',
  'Segoe UI Symbol',
  'JetBrains Mono',
  'Consolas',
}

-- Silence the "no fonts contain glyphs for codepoints" warning for
-- truly unknown codepoints (after the fallback chain has tried).
config.warn_about_missing_glyphs = false
config.font_size = 11.0

-- Trim padding so yazi gets more room.
config.window_padding = {
  left = 4,
  right = 4,
  top = 2,
  bottom = 2,
}

-- Always show the tab bar, even with a single tab. Fancy style = native-
-- looking rounded tabs at the top.
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = true

-- Cursor
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0

-- =========================================================================
-- Shell / Startup
-- =========================================================================

config.default_prog = { 'pwsh.exe', '-NoLogo' }
config.default_cwd = wezterm.home_dir

-- =========================================================================
-- Window behavior
-- =========================================================================

config.initial_cols = 140
config.initial_rows = 38
config.window_close_confirmation = 'NeverPrompt'
config.audible_bell = 'Disabled'

-- 50% opaque window (0.0 = fully transparent, 1.0 = solid).
-- Toggle solid/see-through with Leader then O.
config.window_background_opacity = 0.5

-- Windows-only frosted-glass effect behind the transparent window.
-- Options: 'Auto', 'Disable', 'Acrylic' (frosted glass), 'Mica' (subtle
-- wallpaper tint, Win11 only), 'Tabbed' (Mica variant). Set to 'Disable'
-- for plain transparency without blur.
config.win32_system_backdrop = 'Disable'

-- =========================================================================
-- Image rendering (relevant for yazi)
-- =========================================================================

config.enable_kitty_graphics = true

-- =========================================================================
-- Panes, scrollback & launch menu
-- =========================================================================

-- Dim panes that don't have focus
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }
config.scrollback_lines = 10000

-- Shells for the Leader+M menu (and the top of the right-click + menu)
local shells = {
  { label = 'PowerShell 7',       args = { 'pwsh.exe', '-NoLogo' } },
  { label = 'Windows PowerShell', args = { 'powershell.exe', '-NoLogo' } },
  { label = 'Command Prompt',     args = { 'cmd.exe' } },
}

-- WSL distros (found automatically). docker-desktop is skipped: it has no
-- usable shell. The unused unix mux "Attach domain" entry is removed too.
local wsl = {}
for _, d in ipairs(wezterm.default_wsl_domains()) do
  if not d.distribution:lower():find('docker') then
    table.insert(wsl, d)
    table.insert(shells, { label = d.distribution .. ' (WSL)', domain = { DomainName = d.name } })
  end
end
config.wsl_domains = wsl
config.unix_domains = {}

config.launch_menu = shells

-- Short shell picker, used by Leader+M and by right-clicking the + button
local shell_picker = act.InputSelector {
  title = 'Open shell in new tab',
  fuzzy = false,
  choices = (function()
    local c = {}
    for i, sh in ipairs(shells) do table.insert(c, { id = tostring(i), label = sh.label }) end
    return c
  end)(),
  action = wezterm.action_callback(function(window, pane, id, label)
    if id then
      local sh = shells[tonumber(id)]
      window:perform_action(act.SpawnCommandInNewTab { args = sh.args, domain = sh.domain }, pane)
    end
  end),
}

-- Right-click on + shows the short picker instead of the full launcher.
-- Left-click still opens a normal new tab.
wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
  if button == 'Right' then
    window:perform_action(shell_picker, pane)
    return false
  end
end)


-- Optional backgrounds (uncomment one to try)
-- config.window_background_gradient = { colors = { '#303446', '#232634' }, orientation = 'Vertical' }
-- config.win32_system_backdrop = 'Acrylic'

-- =========================================================================
-- Status bar: LEADER indicator + clock (Catppuccin Frappe colors)
-- =========================================================================

wezterm.on('update-status', function(window, pane)
  local leader = window:leader_is_active() and '  LEADER  ' or ''
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#e5c890' } }, { Text = leader },
    { Foreground = { Color = '#8caaee' } }, { Text = wezterm.strftime(' %a %H:%M ') },
  })
end)

-- Leader + O: toggle between solid and see-through background
wezterm.on('toggle-opacity', function(window)
  local o = window:get_config_overrides() or {}
  if o.window_background_opacity then
    o.window_background_opacity = nil
  else
    o.window_background_opacity = 1.0
  end
  window:set_config_overrides(o)
end)

-- =========================================================================
-- Key bindings
-- =========================================================================

-- Leader key: press Ctrl+B, release, then the next key (like tmux).
-- Used because komorebi owns most Alt shortcuts.
-- 2 seconds to press the next key after Ctrl+B
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = {
  -- Panes
  -- Split left/right: Leader then \ (same key as |, no Shift needed).
  -- '|' is bound both with and without SHIFT because Windows keyboards
  -- report it differently.
  { key = '\\', mods = 'LEADER',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '|',  mods = 'LEADER',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '|',  mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER',       action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  -- Workspaces, opacity, launcher
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = 'o', mods = 'LEADER', action = act.EmitEvent 'toggle-opacity' },
  { key = 'm', mods = 'LEADER', action = shell_picker },
  -- Press Ctrl+B twice to send a real Ctrl+B to the shell
  { key = 'b', mods = 'LEADER|CTRL', action = act.SendKey { key = 'b', mods = 'CTRL' } },
  -- Tabs
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = 'F', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab { args = { 'yazi' } } },
}

return config
