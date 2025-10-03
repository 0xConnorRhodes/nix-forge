local wezterm = require('wezterm')
local host_cfg = require('host_cfg')
local keybinds = require('keybinds')
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
if host_cfg.remap_alt_to_ctrl then
  config.key_map_preference = "Physical"
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = true

  -- Map physical Alt_L to logical Control_L
  config.key_tables = {
    copy_mode = {},
    search_mode = {},
  }

  -- Add key mappings to remap Alt_L to Control_L
  local alt_to_ctrl_keys = {}

  -- Alt key combinations that should be remapped
  local control_keys = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
    '-', '=', '[', ']', '\\', ';', "'", ',', '.', '/',
    'Space', 'Tab', 'Enter', 'Escape', 'Backspace', 'Delete',
    'Home', 'End', 'PageUp', 'PageDown',
    'LeftArrow', 'RightArrow', 'UpArrow', 'DownArrow',
    'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'
  }

  for _, key in ipairs(control_keys) do
    table.insert(alt_to_ctrl_keys, {
      key = key,
      mods = 'ALT',
      action = wezterm.action.SendKey { key = key, mods = 'CTRL' }
    })
  end

  -- Merge the remapping keys with existing keybinds
  for _, key_mapping in ipairs(alt_to_ctrl_keys) do
    table.insert(keybinds.keys, key_mapping)
  end
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

config.keys = keybinds.keys

config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'ssh',
}

return config
