local wezterm = require 'wezterm'
local host_cfg = require('host_cfg')

local modAlt = host_cfg.modAlt
local modWin = host_cfg.modWin
local modCtrl = host_cfg.modCtrl

local M = {}

local pane_split_mod = modAlt..'|SHIFT'
local pane_switch_mod = modAlt..'|'..modWin

M.keys = {
  -- Pane splitting
  {
    key = 'h',
    mods = pane_split_mod,
    action = wezterm.action.SplitPane { direction = 'Left' },
  },
  {
    key = 'j',
    mods = pane_split_mod,
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'k',
    mods = pane_split_mod,
    action = wezterm.action.SplitPane { direction = 'Up' },
  },
  {
    key = 'l',
    mods = pane_split_mod,
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Pane navigation
  {
    key = 'h',
    mods = pane_switch_mod,
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = pane_switch_mod,
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = pane_switch_mod,
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = pane_switch_mod,
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'e',
    mods = modAlt,
    action = wezterm.action.TogglePaneZoomState,
  },
  -- actions
  { key = 'w',
    mods = modAlt,
    action = wezterm.action.CloseCurrentPane { confirm = false }, },

  -- Clear terminal, for now set both alt and control for different modkey schemas
  { key = ';',
    mods = modCtrl,
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport', },
  { key = ';',
    mods = modAlt,
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport', },

  -- copy/paste
  {
    key = "c",
    mods = modAlt,
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(
          wezterm.action{CopyTo="ClipboardAndPrimarySelection"},
          pane)
        window:perform_action("ClearSelection", pane)
      else
        window:perform_action(
          wezterm.action{SendKey={key="c", mods='CTRL'}},
          pane)
      end
    end)
  },

  {
    key = "c",
    mods = modCtrl,
    action = wezterm.action{SendKey={key="c", mods='CTRL'}}
  },
  -- paste with physical alt (logical ctrl) + v
  {
    key = "v",
    mods = modAlt,
    action = wezterm.action.PasteFrom("Clipboard")
  },
  -- map modAlt (physical ctrl) to send C-v which allows conventional C-v usage
  {
     key = "v",
     mods = modCtrl,
     action=wezterm.action{SendKey={key="v", mods="CTRL"}},
  },
}

-- Add conditional keybinds for hosts where alt is remapped to ctrl
if host_cfg.remap_alt_to_ctrl then
  -- On hosts where left alt is remapped to control (like thinkpad):
  -- Ctrl+C and Ctrl+V for copy/paste
  table.insert(M.keys, {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(
          wezterm.action{CopyTo="ClipboardAndPrimarySelection"},
          pane)
        window:perform_action("ClearSelection", pane)
      else
        -- Do nothing for no selection on plain Ctrl+C to avoid conflicts
      end
    end)
  })

  table.insert(M.keys, {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom("Clipboard")
  })

  -- Ctrl+Shift+C and Ctrl+Shift+V for original terminal functions
  table.insert(M.keys, {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action{SendKey={key="c", mods='CTRL'}}
  })

  table.insert(M.keys, {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action{SendKey={key="v", mods="CTRL"}}
  })
end

return M
