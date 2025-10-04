local wezterm = require('wezterm')

local M = {}

-- Function to set up Alt_L to Control_L remapping based on host configuration
function M.setup_alt_to_ctrl_remapping(config, host_cfg, keybinds)
  if not host_cfg.remap_alt_to_ctrl then
    return
  end

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
  -- local control_keys = {
  --   'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  --   'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  --   '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
  --   '-', '=', '[', ']', '\\', ';', "'", ',', '.', '/',
  --   'Space', 'Tab', 'Enter', 'Escape', 'Backspace', 'Delete',
  --   'Home', 'End', 'PageUp', 'PageDown',
  --   'LeftArrow', 'RightArrow', 'UpArrow', 'DownArrow',
  --   'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'
  -- }
  local control_keys = {
    'c', 'k', 'r'
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

return M
