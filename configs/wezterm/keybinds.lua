local wezterm = require 'wezterm'
local host_cfg = require('host_cfg')

local modAlt = host_cfg.modAlt
local modWin = host_cfg.modWin
local modCtrl = host_cfg.modCtrl

local M = {}

M.keys = {
  { key = 'w',
    mods = modAlt,
    action = wezterm.action.CloseCurrentPane { confirm = false }, },
  -- Pane splitting
  {
    key = 'h',
    mods = modAlt..'|'..modWin,
    action = wezterm.action.SplitPane { direction = 'Left' },
  },
  {
    key = 'j',
    mods = modAlt..'|'..modWin,
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'k',
    mods = modAlt..'|'..modWin,
    action = wezterm.action.SplitPane { direction = 'Up' },
  },
  {
    key = 'l',
    mods = modAlt..'|'..modWin,
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Pane navigation
  {
    key = 'h',
    mods = modCtrl,
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = modCtrl,
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = modCtrl,
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = modCtrl,
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  -- Clear terminal
  {
    key = ';',
    mods = modCtrl,
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  {
    key = 'e',
    mods = modAlt,
    action = wezterm.action.TogglePaneZoomState,
  },
}

return M
