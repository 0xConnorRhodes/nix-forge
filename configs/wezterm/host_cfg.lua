local wezterm = require 'wezterm'

local hostname = wezterm.hostname()

local host_cfg = {}

if hostname == 'mpro' then
  host_cfg.font_size = 18
  host_cfg.modAlt = 'CTRL'
elseif hostname == 'latitude' then
  host_cfg.font_size = 17
  host_cfg.modAlt = 'CTRL'
elseif hostname == 'macbookpro.lan' then
  host_cfg.font_size = 21
  host_cfg.modAlt = 'CMD'
else
  host_cfg.font_size = 21
  host_cfg.modAlt = 'ALT'
end

return host_cfg
