local wezterm = require 'wezterm'

local hostname = wezterm.hostname()

local host_cfg = {}

if hostname == 'mpro' then
  host_cfg.font_size = 18
  host_cfg.modAlt = 'CTRL'
  host_cfg.modCtrl = 'ALT'
elseif hostname == 'latitude' then
  host_cfg.font_size = 17
  host_cfg.modAlt = 'CTRL'
  host_cfg.modCtrl = 'ALT'
elseif hostname == 'macbookpro.lan' then
  host_cfg.font_size = 21
  host_cfg.modAlt = 'CMD'
  host_cfg.modCtrl = 'CTRL'
else
  host_cfg.font_size = 21
  host_cfg.modAlt = 'ALT'
  host_cfg.modCtrl = 'CTRL'
end

return host_cfg
