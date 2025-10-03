local wezterm = require('wezterm')
local host_cfg = require('host_cfg')
local keybinds = require('keybinds')
local caps_alt_to_control = require('caps_alt_to_control')
local config = wezterm.config_builder()

config.color_scheme = 'Abernathy'
config.initial_cols = 210
config.initial_rows = 210
config.window_close_confirmation = 'NeverPrompt'

config.skip_close_confirmation_for_processes_named = {
  'bash', 'sh', 'zsh', 'fish', 'tmux', 'screen', 'ssh', 'et', 'mosh'
}

config.font = wezterm.font 'GeistMono Nerd Font'

config.font_size = host_cfg.font_size

-- Key remapping: Alt_L to Control_L based on host configuration
caps_alt_to_control.setup_alt_to_ctrl_remapping(config, host_cfg, keybinds)

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.hide_mouse_cursor_when_typing = false

config.keys = keybinds.keys

config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'ssh',
}

return config
