local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Abernathy'
config.initial_cols = 210
config.initial_rows = 210
config.window_close_confirmation = 'NeverPrompt'

config.font = wezterm.font 'GeistMono Nerd Font'
config.font_size = 21

--disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

return config