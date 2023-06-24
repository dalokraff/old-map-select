local mod = get_mod("old-map-select")
local OldMapUtils = mod:dofile("scripts/mods/old-map-select/utils")
local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_definitions")

local window_default_settings = UISettings.game_start_windows
local window_spacing = window_default_settings.spacing
local window_size = window_default_settings.size
local window_frame = window_default_settings.frame
local window_frame_width = UIFrameSettings[window_frame].texture_sizes.vertical[1]
local window_text_width = window_size[1] - (window_frame_width * 2 + 60)

local info_window_size = {
	window_size[1],
	window_size[2]
}

local large_window_size = {
	window_size[1] * 2 + window_spacing,
	window_size[2]
}

local video_window_size = {
	window_size[1] * 3 + window_spacing * 2,
	window_size[2]
}

local description_text_style = {
	word_wrap = true,
	localize = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	-- draw_text_rect = true,
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

definitions.scenegraph_definition.window = {
    vertical_alignment = "center",
    parent = "menu_root",
    horizontal_alignment = "center",
    size = large_window_size,
    position = {
        window_size[1] / 2 + window_spacing / 2,
        0,
        1
    }
}

definitions.scenegraph_definition.window_background = {
    vertical_alignment = "bottom",
    parent = "window",
    horizontal_alignment = "center",
    size = {
        large_window_size[1],
        770
    },
    position = {
        0,
        0,
        1
    }
}

definitions.scenegraph_definition.area_root = {
    vertical_alignment = "center",
    parent = "window",
    horizontal_alignment = "center",
    size = {
        180*0.45,
        180*0.45
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
    horizontal_alignment = "right",
    size = window_size,
    position = {
        info_window_size[1] + window_spacing,
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

definitions.scenegraph_definition.select_button = {
	vertical_alignment = "bottom",
	parent = "info_window",
	horizontal_alignment = "center",
	size = {
		460,
		72
	},
	position = {
		0,
		18,
		20
	}
}

definitions.scenegraph_definition.area_texture_frame = {
    vertical_alignment = "top",
    parent = "info_window",
    horizontal_alignment = "center",
    size = {
        180,
        180
    },
    position = {
        0,
        -103,
        2
    }
}
definitions.scenegraph_definition.area_texture = {
    vertical_alignment = "center",
    parent = "area_texture_frame",
    horizontal_alignment = "center",
    size = {
        168,
        168
    },
    position = {
        0,
        0,
        -1
    }
}
definitions.scenegraph_definition.area_texture_lock = {
    vertical_alignment = "center",
    parent = "area_texture_frame",
    horizontal_alignment = "center",
    size = {
        146,
        146
    },
    position = {
        0,
        0,
        1
    }
}
definitions.scenegraph_definition.title_divider = {
    vertical_alignment = "bottom",
    parent = "area_texture_frame",
    horizontal_alignment = "center",
    size = {
        264,
        32
    },
    position = {
        0,
        -140,
        1
    }
}
definitions.scenegraph_definition.area_title = {
    vertical_alignment = "bottom",
    parent = "title_divider",
    horizontal_alignment = "center",
    size = {
        window_text_width,
        50
    },
    position = {
        0,
        22,
        1
    }
}

definitions.scenegraph_definition.description_text = {
    vertical_alignment = "center",
    parent = "info_window",
    horizontal_alignment = "center",
    size = {
        window_text_width,
        window_size[2] / 2
    },
    position = {
        0,
        -75,
        1
    }
}

definitions.widgets.background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "info_window", nil, nil, nil, nil)
definitions.widgets.background_mask = UIWidgets.create_simple_texture("mask_rect", "info_window")
definitions.widgets.info_window = UIWidgets.create_frame("info_window", window_size, window_frame, 10)
definitions.widgets.title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider")
definitions.widgets.description_text = UIWidgets.create_simple_text("description_text", "description_text", nil, nil, description_text_style)
definitions.widgets.area_title = UIWidgets.create_simple_text("area_title", "area_title", nil, nil, level_text_style)

for i = 1, 10 do
	definitions.area_widgets[i] = OldMapUtils.create_area_widget(i, definitions.scenegraph_definition, nil, 0.4)
end

return definitions