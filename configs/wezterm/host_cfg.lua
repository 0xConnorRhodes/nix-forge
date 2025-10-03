local wezterm = require 'wezterm'

local hostname = wezterm.hostname()

local host_cfg = {}

if hostname == 'mpro' then
  host_cfg.font_size = 18
  host_cfg.modAlt = 'CTRL'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'ALT'
  host_cfg.remap_alt_to_ctrl = true
elseif hostname == 'latitude' then
  host_cfg.font_size = 17
  host_cfg.modAlt = 'CTRL'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'ALT'
  host_cfg.remap_alt_to_ctrl = true
elseif wezterm.target_triple:find("darwin") then
  host_cfg.font_size = 21
  host_cfg.modAlt = 'CMD'
  host_cfg.modWin = 'OPT'
  host_cfg.modCtrl = 'CTRL'
  host_cfg.remap_alt_to_ctrl = false
elseif hostname == 'thinkpad' then
  host_cfg.font_size = 21
  host_cfg.modAlt = 'ALT'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'CTRL'
  host_cfg.remap_alt_to_ctrl = true
else
  host_cfg.font_size = 21
  host_cfg.modAlt = 'ALT'
  host_cfg.modWin = 'WIN'
  host_cfg.modCtrl = 'CTRL'
  host_cfg.remap_alt_to_ctrl = false
end

return host_cfg
