-- Pull in the wezterm API
local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices
config.set_environment_variables = {
	-- prepend the path to your utility and include the rest of the PATH
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

-- For example, changing the color scheme:
config.color_scheme = "Solarized Dark Higher Contrast (Gogh)"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- you can put the rest of your Wezterm config here

-- https://mwop.net/blog/2024-07-04-how-i-use-wezterm.html
config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ mods = "CTRL", key = "a" }),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ mods = "CTRL", key = "e" }),
	},
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "f",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	{
		key = "&",
		mods = "LEADER|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "=",
		mods = "LEADER",
		action = wezterm.action_callback(function(win)
			local new_tab, lhs, new_win = win:mux_window():spawn_tab({
				args = { "nvim" },
			})

			local rhs = lhs:split({
				direction = "Right",
				size = 0.5,
			})

			lhs:split({
				direction = "Bottom",
				size = 0.5,
			})

			rhs:split({
				direction = "Bottom",
				size = 0.25,
			})
		end),
	},
	-- Switch to a monitoring workspace, which will have `top` launched into it
	-- Create a new workspace with a random name and switch to it
	{ key = "i", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
}

config.switch_to_last_active_tab_when_closing_tab = true

-- smart_splits
smart_splits.apply_to_config(config)

-- and finally, return the configuration to wezterm
return config
