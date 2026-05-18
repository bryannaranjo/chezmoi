-- ~/.wezterm.lua
-- WezTerm configuration tuned for running yazi on Windows.

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

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

-- 80% opaque window. Lower = more see-through. Range: 0.0 (fully transparent)
-- to 1.0 (fully opaque).
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
-- Key bindings
-- =========================================================================

config.keys = {
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = 'F', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab { args = { 'yazi' } } },
}

return config
