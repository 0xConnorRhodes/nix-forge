local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Abernathy'
config.initial_cols = 210
config.initial_rows = 210
config.window_close_confirmation = 'NeverPrompt'

config.font = wezterm.font 'GeistMono Nerd Font'

-- set font size based on hostname
local hostname = wezterm.hostname()
if hostname == 'mpro' then
  config.font_size = 18
elseif hostname == 'latitude' then
  config.font_size = 17
else
  config.font_size = 21
end

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.hide_mouse_cursor_when_typing = false

config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
}

config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'ssh',
}

return config
