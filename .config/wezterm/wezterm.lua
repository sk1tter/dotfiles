local wezterm = require("wezterm")

local act = wezterm.action
local mod = "SHIFT|SUPER"

local theme = "nord"
local wez_theme = wezterm.color.get_builtin_schemes()[theme]

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	return {
		{ Text = " " .. tab.active_pane.title .. " " },
	}
end)

return {
	font = wezterm.font_with_fallback({
		"Fira Code",
		{ family = "Symbols Nerd Font Mono", scale = 0.8 },
		"Noto Color Emoji",
		"D2Coding",
	}), -- [JetBrains Mono]
	font_size = 13,

	color_scheme = theme,
	colors = {
		tab_bar = {
			inactive_tab_edge = wezterm.color.parse(wez_theme.background):darken(0.8),
			active_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			inactive_tab = {
				bg_color = wezterm.color.parse(wez_theme.background):lighten(0.1),
				fg_color = wezterm.color.parse(wez_theme.foreground):lighten(0.2),
			},
			inactive_tab_hover = {
				bg_color = wezterm.color.parse(wez_theme.background):lighten(0.2),
				fg_color = wezterm.color.parse(wez_theme.foreground):lighten(0.3),
			},
			new_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			new_tab_hover = {
				bg_color = wezterm.color.parse(wez_theme.background):lighten(0.1),
				fg_color = wez_theme.foreground,
			},
		},
	},

	window_decorations = "INTEGRATED_BUTTONS|RESIZE", -- Integrated Title Bar
	window_frame = {
		font = wezterm.font("Fira Code", { weight = "Bold" }),
		font_size = 12,
		active_titlebar_bg = wez_theme.brights[1],
		inactive_titlebar_bg = wezterm.color.parse(wez_theme.background):darken(0.8),
	},
	window_padding = {
		left = "0.1cell",
		right = "0.1cell",
		top = "0.2cell",
		bottom = "0.1cell",
	},

	default_cursor_style = "BlinkingUnderline",
	cursor_thickness = "200%",
	animation_fps = 1,

	scrollback_lines = 10000,

	keys = {
		{ mods = mod, key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ mods = mod, key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ mods = mod, key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ mods = mod, key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ mods = mod, key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ mods = mod, key = "_", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ mods = mod, key = ">", action = act.MoveTabRelative(1) },
		{ mods = mod, key = "<", action = act.MoveTabRelative(-1) },
		{ mods = mod, key = "l", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ mods = mod, key = "h", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "C", mods = "CTRL", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
	},
}
