
local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_console_definitions")

local window_default_settings = UISettings.game_start_windows
local window_frame = window_default_settings.frame
local window_size = window_default_settings.size
local window_spacing = window_default_settings.spacing
local window_frame_width = UIFrameSettings[window_frame].texture_sizes.vertical[1]
local window_text_width = window_size[1] - (window_frame_width * 2 + 60)
local large_window_size = {
	window_size[1] * 2 + window_spacing,
	window_size[2]
}

definitions.scenegraph_definition.window_background = {
    vertical_alignment = "center",
	parent = "window",
	horizontal_alignment = "left",
	size = {
		large_window_size[1],
		770
	},
	position = {
		-75,
		0,
		0
	}
}


return definitions