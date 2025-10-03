local wezterm = require 'wezterm'

local hostname = wezterm.hostname()

local host_cfg = {}

if hostname == 'mpro' then
  host_cfg.font_size = 18
  host_cfg.modAlt = 'CTRL'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'ALT'
  host_cfg.remap_alt_to_ctrl = true  -- Enable Alt_L to Control_L remapping
elseif hostname == 'latitude' then
  host_cfg.font_size = 17
  host_cfg.modAlt = 'CTRL'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'ALT'
  host_cfg.remap_alt_to_ctrl = true  -- Enable Alt_L to Control_L remapping
elseif wezterm.target_triple:find("darwin") then
  host_cfg.font_size = 21
  host_cfg.modAlt = 'CMD'
  host_cfg.modWin = 'OPT'
  host_cfg.modCtrl = 'CTRL'
  host_cfg.remap_alt_to_ctrl = false  -- Disable Alt_L to Control_L remapping on macOS
else
  host_cfg.font_size = 21
  host_cfg.modAlt = 'ALT'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'CTRL'
  host_cfg.remap_alt_to_ctrl = false  -- Disable Alt_L to Control_L remapping by default
end

return host_cfg
