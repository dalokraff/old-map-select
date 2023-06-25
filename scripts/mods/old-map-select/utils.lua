local mod = get_mod("old-map-select")

local OldMapUtils = {}

OldMapUtils.create_level_widget = function (scenegraph_id, optional_offset, texture_size_scale)
	local size = {
		180*texture_size_scale,
		180*texture_size_scale
	}
	local widget = {
		element = {}
	}
	local passes = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (content)
				return not content.parent.locked
			end
		},
		{
			style_id = "icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function (content)
				return content.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow",
			content_check_function = function (content)
				return content.button_hotspot.is_hover or content.button_hotspot.is_selected
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (content)
				return not content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_locked",
			texture_id = "icon",
			content_check_function = function (content)
				return content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (content)
				return content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function (content)
				return content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "glass",
			texture_id = "glass"
		},
		{
			pass_type = "rotated_texture",
			style_id = "path",
			texture_id = "path",
			content_check_function = function (content)
				return content.draw_path
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path_glow",
			texture_id = "path_glow",
			content_check_function = function (content)
				return content.draw_path and content.draw_path_fill and not content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "boss_icon",
			texture_id = "boss_icon",
			content_check_function = function (content)
				return content.boss_level
			end
		}
	}
	local content = {
		frame = "map_frame_00",
		locked = true,
		path = "mission_select_screen_trail",
		draw_path = false,
		path_glow = "mission_select_screen_trail_fill",
		draw_path_fill = false,
		lock = "map_frame_lock",
		boss_level = true,
		glass = "act_presentation_fg_glass",
		boss_icon = "boss_icon",
		lock_fade = "map_frame_fade",
		icon = "level_icon_01",
		icon_glow = "map_frame_glow",
		button_hotspot = {}
	}
	local style = {
		path = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			pivot = {
				0,
				6.5
			},
			texture_size = {
				216*texture_size_scale,
				13*texture_size_scale
			},
			offset = {
				size[1] / 2,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		path_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			pivot = {
				0,
				21.5
			},
			texture_size = {
				216*texture_size_scale,
				43*texture_size_scale
			},
			offset = {
				size[1] / 2,
				0,
				2
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		glass = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				216*texture_size_scale,
				216*texture_size_scale
			},
			offset = {
				0,
				0,
				7
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180*texture_size_scale,
				180*texture_size_scale
			},
			offset = {
				0,
				0,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180*texture_size_scale,
				180*texture_size_scale
			},
			offset = {
				0,
				0,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180*texture_size_scale,
				180*texture_size_scale
			},
			offset = {
				0,
				0,
				5
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				168*texture_size_scale,
				168*texture_size_scale
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				3
			}
		},
		icon_locked = {
			vertical_alignment = "center",
			saturated = true,
			horizontal_alignment = "center",
			texture_size = {
				168*texture_size_scale,
				168*texture_size_scale
			},
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				0,
				0,
				3
			}
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				318*texture_size_scale,
				318*texture_size_scale
			},
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		boss_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				68*texture_size_scale,
				68*texture_size_scale
			},
			offset = {
				0,
				90*texture_size_scale,
				8
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
	widget.element.passes = passes
	widget.content = content
	widget.style = style
	widget.offset = optional_offset or {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

OldMapUtils.create_area_widget = function(index, scenegraph_definition, specific_scenegraph_id, area_widget_scale, scenegraph_parent)
    local scenegraph_id = specific_scenegraph_id
	local size = {
		180*area_widget_scale,
		180*area_widget_scale
	}

	if not scenegraph_id then
		scenegraph_id = "area_root_" .. index
		scenegraph_definition[scenegraph_id] = {
			vertical_alignment = "center",
			parent = scenegraph_parent or "area_root",
			horizontal_alignment = "center",
			size = size,
			position = {
				0,
				0,
				1
			}
		}
	end

	local widget = {
		element = {}
	}
	local passes = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (content)
				return content.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local content = {
		locked = true,
		frame = "map_frame_04",
		icon = "level_icon_01",
		lock = "hero_icon_locked",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {}
	}
	local style = {
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180*area_widget_scale,
				180*area_widget_scale
			},
			offset = {
				0,
				0,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				76*area_widget_scale,
				87*area_widget_scale
			},
			offset = {
				64,
				-58,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				168*area_widget_scale*0.85,
				168*area_widget_scale*0.85
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				0
			}
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				270*area_widget_scale,
				270*area_widget_scale
			},
			offset = {
				0,
				0,
				3
			},
			color = {
				0,
				255,
				255,
				255
			}
		}
	}
	widget.element.passes = passes
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget

end

return OldMapUtils