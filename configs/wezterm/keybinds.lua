local wezterm = require 'wezterm'

local M = {}

M.keys = {
  { key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = false }, },
  -- Pane splitting
  {
    key = 'h',
    mods = 'CMD|OPT',
    action = wezterm.action.SplitPane { direction = 'Left' },
  },
  {
    key = 'j',
    mods = 'CMD|OPT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'k',
    mods = 'CMD|OPT',
    action = wezterm.action.SplitPane { direction = 'Up' },
  },
  {
    key = 'l',
    mods = 'CMD|OPT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Pane navigation
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  -- Clear terminal
  {
    key = ';',
    mods = 'CTRL',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
}

return M
