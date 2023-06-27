local mod = get_mod("old-map-select")
local OldMapUtils = mod:dofile("scripts/mods/old-map-select/utils")
local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_console_definitions")

local window_default_settings = UISettings.game_start_windows
local window_size = window_default_settings.size
local window_spacing = window_default_settings.spacing

local window_frame = window_default_settings.frame
local window_frame_width = UIFrameSettings[window_frame].texture_sizes.vertical[1]
local window_text_width = window_size[1] - (window_frame_width * 2 + 60)

local large_window_size = {
	window_size[1] * 3 + window_spacing * 2,
	window_size[2]
}

local large_window_size_map = {
	window_size[1] * 2 + window_spacing,
	window_size[2]
}

local info_window_size = {
	window_size[1],
	window_size[2] + 50
}

local video_window_size = {
	window_size[1] * 3 + window_spacing * 2,
	window_size[2]
}

local requirements_not_met_text_style = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		3
	}
}
local not_owned_text_style = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		3
	}
}
local description_text_style = {
	word_wrap = true,
	localize = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 150),
	offset = {
		0,
		0,
		3
	}
}
local level_text_style = {
	font_size = 48,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}

definitions.scenegraph_definition.area_map = {
    vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			large_window_size_map[1],
			770
		},
		position = {
			75,
			0,
			2
		}
}

definitions.scenegraph_definition.area_map_edge_top = {
    vertical_alignment = "top",
    parent = "area_map",
    horizontal_alignment = "center",
    size = {
        large_window_size_map[1]-42,
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
    parent = "area_map",
    horizontal_alignment = "center",
    size = {
        large_window_size_map[1]-42,
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
    parent = "area_map",
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
    parent = "area_map",
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
    parent = "area_map",
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
    parent = "area_map",
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
    parent = "area_map",
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
    parent = "area_map",
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

definitions.scenegraph_definition.area_root = {
    vertical_alignment = "top",
    parent = "window",
    horizontal_alignment = "center",
    size = {
        180,
        180
    },
    position = {
        0,
        -60,
        3
    }
}

definitions.scenegraph_definition.info_window = {
    vertical_alignment = "center",
    parent = "window",
    horizontal_alignment = "center",
    size = info_window_size,
    position = {
        info_window_size[1],
        0,
        1
    }
}

definitions.scenegraph_definition.video = {
    vertical_alignment = "top",
    parent = "info_window",
    horizontal_alignment = "center",
    size = {
        info_window_size[1],
        video_window_size[2] * (info_window_size[1]/video_window_size[1])
    },
    position = {
        0,
        0,
        1
    }
}

definitions.scenegraph_definition.title_divider = {
    vertical_alignment = "center",
    parent = "info_window",
    horizontal_alignment = "center",
    size = {
        264,
        32
    },
    position = {
        0,
        -60,
        1
    }
}
definitions.scenegraph_definition.area_title = {
    vertical_alignment = "center",
    parent = "title_divider",
    horizontal_alignment = "center",
    size = {
        info_window_size[1]-25,
        50
    },
    position = {
        0,
        30,
        1
    }
}
definitions.scenegraph_definition.description_text = {
    vertical_alignment = "center",
    parent = "title_divider",
    horizontal_alignment = "center",
    size = {
        info_window_size[1]-50,
        150
    },
    position = {
        0,
        -50,
        1
    }
}
definitions.scenegraph_definition.not_owned_text = {
    vertical_alignment = "center",
    parent = "info_window",
    horizontal_alignment = "center",
    size = {
        info_window_size[1]-25,
        50
    },
    position = {
        0,
        150,
        12
    }
}
definitions.scenegraph_definition.requirements_not_met_text = {
    vertical_alignment = "center",
    parent = "info_window",
    horizontal_alignment = "center",
    size = {
        info_window_size[1]-25,
        50
    },
    position = {
        0,
        200,
        12
    }
}




definitions.widgets.area_map = UIWidgets.create_simple_texture("reikland_map", "area_map")
-- definitions.widgets.background = nil
definitions.widgets.description_background = UIWidgets.create_rect_with_outer_frame("info_window", definitions.scenegraph_definition.info_window.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color)
definitions.widgets.area_title = UIWidgets.create_simple_text("area_title", "area_title", nil, nil, level_text_style)
definitions.widgets.title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider")
definitions.widgets.description_text = UIWidgets.create_simple_text("description_text", "description_text", nil, nil, description_text_style)
definitions.widgets.not_owned_text = UIWidgets.create_simple_text("dlc1_2_dlc_level_locked_tooltip", "not_owned_text", nil, nil, not_owned_text_style)
definitions.widgets.requirements_not_met_text = UIWidgets.create_simple_text("lb_unknown", "requirements_not_met_text", nil, nil, requirements_not_met_text_style)


for i = 1, 10 do
	definitions.area_widgets[i] = OldMapUtils.create_area_widget(i, definitions.scenegraph_definition, nil, 0.4, "area_map")
end

return definitions