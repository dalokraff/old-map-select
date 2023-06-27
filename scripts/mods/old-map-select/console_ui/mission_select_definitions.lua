
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
local info_window_size = {
	window_size[1],
	window_size[2] + 50
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

definitions.scenegraph_definition.info_window = {
    vertical_alignment = "top",
    parent = "window",
    horizontal_alignment = "right",
    size = info_window_size,
    position = {
        info_window_size[1],
        0,
        1
    }
}

definitions.scenegraph_definition.area_map_edge_top = {
    vertical_alignment = "top",
    parent = "window_background",
    horizontal_alignment = "center",
    size = {
        large_window_size[1]-42,
        42
    },
    position = {
        0,
        42,
        4
    }
}
definitions.scenegraph_definition.area_map_edge_bottom = {
    vertical_alignment = "bottom",
    parent = "window_background",
    horizontal_alignment = "center",
    size = {
        large_window_size[1]-42,
        42
    },
    position = {
        0,
        -42,
        4
    }
}
definitions.scenegraph_definition.area_map_edge_left = {
    vertical_alignment = "center",
    parent = "window_background",
    horizontal_alignment = "left",
    size = {
        42,
        770 -42
    },
    position = {
        -42,
        0,
        4
    }
}
definitions.scenegraph_definition.area_map_edge_right = {
    vertical_alignment = "center",
    parent = "window_background",
    horizontal_alignment = "right",
    size = {
        42,
        770 -42
    },
    position = {
        42,
        0,
        4
    }
}

definitions.scenegraph_definition.area_map_corner_bottom_left = {
    vertical_alignment = "bottom",
    parent = "window_background",
    horizontal_alignment = "left",
    size = {
        151,
        151
    },
    position = {
        -6-42,
        -6-42,
        5
    }
}
definitions.scenegraph_definition.area_map_corner_bottom_right = {
    vertical_alignment = "bottom",
    parent = "window_background",
    horizontal_alignment = "right",
    size = {
        151,
        151
    },
    position = {
        6+42,
        -6-42,
        5
    }
}
definitions.scenegraph_definition.area_map_corner_top_left = {
    vertical_alignment = "top",
    parent = "window_background",
    horizontal_alignment = "left",
    size = {
        151,
        151
    },
    position = {
        -6-42,
        6+42,
        5
    }
}
definitions.scenegraph_definition.area_map_corner_top_right = {
    vertical_alignment = "top",
    parent = "window_background",
    horizontal_alignment = "right",
    size = {
        151,
        151
    },
    position = {
        6+42,
        6+42,
        5
    }
}

return definitions