local mod = get_mod("old-map-select")
local OldMapUtils = mod:dofile("scripts/mods/old-map-select/utils")

local definitions = mod:dofile("scripts/mods/old-map-select/console_ui/mission_select_definitions")
local widget_definitions = definitions.widgets
local act_widget_definitions = definitions.act_widgets
local node_widget_definitions = definitions.node_widgets
local end_act_widget_definition = definitions.end_act_widget
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions

local replacement_map = {
    bogenhafen = "bogenhafen_map",
    helmgart = "helmgart_map",
    holly = "ubersreik_map",
	penny = "drachenfels_map",
	karak_azgaraz = "dwarf_map",
}

local replacement_settings = {}
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/console_ui/area_settings/bogenhafen"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/console_ui/area_settings/holly"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/console_ui/area_settings/helmgart"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/console_ui/area_settings/penny"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/console_ui/area_settings/karak_azgaraz"))
local old_map_icon_size = 0.3

local area_title_text_style = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}

--this function is needed to resize level icon's button hotspot
local scenegraph_level_icon_resize = function(resize)
    for i = 1, 20 do
        local scenegraph_id = "level_root_" .. i
        scenegraph_definition[scenegraph_id] = {
            vertical_alignment = "center",
            parent = "level_root_node",
            horizontal_alignment = "center",
            size = {
                180*resize,
                180*resize
            },
            position = {
                0,
                0,
                1
            }
        }
    end
end

local map_changes = function(area_name)
    local new_map = replacement_map[area_name]
    if new_map then
        widget_definitions.window_background = UIWidgets.create_simple_texture(new_map, "window_background")
        local area_title = AreaSettings[area_name].display_name
        scenegraph_level_icon_resize(old_map_icon_size)



        widget_definitions.area_map_edge_top = UIWidgets.create_tiled_texture("area_map_edge_top", "store_frame_small_side_01", {
            128,
            42
        })
        widget_definitions.area_map_edge_bottom = UIWidgets.create_tiled_texture("area_map_edge_bottom", "store_frame_small_side_03", {
            128,
            42
        })
        widget_definitions.area_map_edge_left = UIWidgets.create_tiled_texture("area_map_edge_left", "store_frame_small_side_04", {
            42,
            128
        })
        widget_definitions.area_map_edge_right = UIWidgets.create_tiled_texture("area_map_edge_right", "store_frame_small_side_02", {
            42,
            128
        })
        
        widget_definitions.area_map_corner_bottom_left = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", 0, {
            75.5,
            75.5
        }, "area_map_corner_bottom_left")
        widget_definitions.area_map_corner_bottom_right = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", -math.pi / 2, {
            75.5,
            75.5
        }, "area_map_corner_bottom_right")
        widget_definitions.area_map_corner_top_left = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", math.pi / 2, {
            75.5,
            75.5
        }, "area_map_corner_top_left")
        widget_definitions.area_map_corner_top_right = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", math.pi, {
            75.5,
            75.5
        }, "area_map_corner_top_right")
    else 
        widget_definitions.window_background = nil
        scenegraph_level_icon_resize(1)

        widget_definitions.area_map_edge_top = nil
        widget_definitions.area_map_edge_bottom = nil
        widget_definitions.area_map_edge_left = nil
        widget_definitions.area_map_edge_right = nil
        
        widget_definitions.area_map_corner_bottom_left = nil
        widget_definitions.area_map_corner_bottom_right = nil
        widget_definitions.area_map_corner_top_left = nil
        widget_definitions.area_map_corner_top_right = nil
    end
end

--copy of vanilla funciton so it uses my altered definitions
mod:hook(StartGameWindowMissionSelectionConsole, "_create_ui_elements", function(func, self, params, offset)
	local area_name = self._parent:get_selected_area_name()
    map_changes(area_name)
    
    local ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._ui_scenegraph = ui_scenegraph
	local widgets = {}
	local widgets_by_name = {}

	for name, widget_definition in pairs(widget_definitions) do
		local widget = UIWidget.init(widget_definition)
		widgets[#widgets + 1] = widget
		widgets_by_name[name] = widget
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name
	local node_widgets = {}
	local node_widgets_by_name = {}

	for name, widget_definition in pairs(node_widget_definitions) do
		local widget = UIWidget.init(widget_definition)
		node_widgets[#node_widgets + 1] = widget
		node_widgets_by_name[name] = widget
	end

	self._node_widgets = node_widgets
	self._node_widgets_by_name = node_widgets_by_name
	local act_widgets = {}
	local act_widgets_by_name = {}

	for name, widget_definition in pairs(act_widget_definitions) do
		local widget = UIWidget.init(widget_definition)
		act_widgets[#act_widgets + 1] = widget
		act_widgets_by_name[name] = widget
	end

	self._act_widgets = act_widgets
	self._act_widgets_by_name = act_widgets_by_name
	self._end_act_widget = UIWidget.init(end_act_widget_definition)
	self._loot_object_widgets = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(ui_scenegraph, animation_definitions)

	if offset then
		local window_position = ui_scenegraph.window.local_position
		window_position[1] = window_position[1] + offset[1]
		window_position[2] = window_position[2] + offset[2]
		window_position[3] = window_position[3] + offset[3]
	end
    return
end)

--copy of the vanilla funciton except, added in some logic to handle on the spot replacement of missions that have maps
mod:hook(StartGameWindowMissionSelectionConsole, "_present_act_levels", function(func, self, area_name)
	local node_widgets = self._node_widgets
	local statistics_db = self._statistics_db
	local stats_id = self._stats_id
	local assigned_widgets = {}
	local act_widgets = {}
	local level_width_spacing = 190
	local level_height_spacing = 190
	local max_act_number = 4
	local levels_by_act = self._levels_by_act

	for act_key, levels in pairs(levels_by_act) do
		local act_verified = self:_verify_act(act_key)

		if act_verified and (not act or act == act_key) then
			local act_settings = ActSettings[act_key]
			local act_sorting = act_settings.sorting
			local act_index = (act_sorting - 1) % max_act_number + 1
			local is_end_act = max_act_number < act_sorting
			local act_position_y = 0
			local act_widget = nil

			if not is_end_act then
				act_position_y = -level_height_spacing + (max_act_number - act_index) * level_height_spacing
				act_widget = self._act_widgets[act_index]
			else
				act_widget = self._end_act_widget
			end

			act_widgets[#act_widgets + 1] = act_widget
			act_widget.offset[2] = act_position_y
			local act_display_name = act_settings.display_name
			act_widget.content.background = act_settings.banner_texture
			act_widget.content.text = act_display_name and Localize(act_display_name) or ""
			local area_name_width = UIUtils.get_text_width(self._ui_renderer, act_widget.style.text, act_widget.content.text)
			local num_levels_in_act = #levels
			local level_position_x = area_name_width - 50
			local level_position_y = 0

			for i = 1, num_levels_in_act do
				local level_data = levels[i]

				if is_end_act then
					level_position_x = level_width_spacing * 4
				end

				local index = #assigned_widgets + 1
				local widget = node_widgets[index]
				local content = widget.content
				local level_key = level_data.level_id
				local boss_level = level_data.boss_level
				local level_display_name = level_data.display_name
				content.text = Localize(level_display_name)
				local level_unlocked = LevelUnlockUtils.level_unlocked(statistics_db, stats_id, level_key)
				local completed_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, level_key)
				local selection_frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_difficulty_index)
				content.frame = selection_frame_texture
				content.locked = not level_unlocked
				content.act_key = act_key
				content.level_key = level_key
                local level_image = level_data.level_image

				if level_image then
					content.icon = level_image
				else
					content.icon = "icons_placeholder"
				end

				content.level_data = level_data
				content.boss_level = boss_level
				local offset = widget.offset
				offset[1] = level_position_x
				offset[2] = act_position_y + level_position_y
				assigned_widgets[index] = widget
				level_position_x = level_position_x + level_width_spacing

                local widget_scale = 1
                local new_settings = replacement_settings[level_key]
                if new_settings then
                    widget_scale = old_map_icon_size
                    content.icon = new_settings.level_image
                    offset[1] = new_settings.pos_x
				    offset[2] = new_settings.pos_y

                    act_widgets[#act_widgets] = nil
                end

                widget.style.glass.texture_size[1] = widget_scale*widget.style.glass.texture_size[1]
                widget.style.glass.texture_size[2] = widget_scale*widget.style.glass.texture_size[2]
                widget.style.frame.texture_size[1] = widget_scale*widget.style.frame.texture_size[1]
                widget.style.frame.texture_size[2] = widget_scale*widget.style.frame.texture_size[2]
                widget.style.lock.texture_size[1] = widget_scale*widget.style.lock.texture_size[1]
                widget.style.lock.texture_size[2] = widget_scale*widget.style.lock.texture_size[2]
                widget.style.lock_fade.texture_size[1] = widget_scale*widget.style.lock_fade.texture_size[1]
                widget.style.lock_fade.texture_size[2] = widget_scale*widget.style.lock_fade.texture_size[2]
                widget.style.icon.texture_size[1] = widget_scale*widget.style.icon.texture_size[1]
                widget.style.icon.texture_size[2] = widget_scale*widget.style.icon.texture_size[2]
                widget.style.icon_locked.texture_size[1] = widget_scale*widget.style.icon_locked.texture_size[1]
                widget.style.icon_locked.texture_size[2] = widget_scale*widget.style.icon_locked.texture_size[2]
                widget.style.icon_glow.texture_size[1] = widget_scale*widget.style.icon_glow.texture_size[1]
                widget.style.icon_glow.texture_size[2] = widget_scale*widget.style.icon_glow.texture_size[2]
                widget.style.icon_unlock_guidance_glow.texture_size[1] = widget_scale*widget.style.icon_unlock_guidance_glow.texture_size[1]
                widget.style.icon_unlock_guidance_glow.texture_size[2] = widget_scale*widget.style.icon_unlock_guidance_glow.texture_size[2]
                widget.style.boss_icon.texture_size[1] = widget_scale*widget.style.boss_icon.texture_size[1]
                widget.style.boss_icon.texture_size[2] = widget_scale*widget.style.boss_icon.texture_size[2]
			end
		end
	end

	self._active_node_widgets = assigned_widgets
	self._active_act_widgets = act_widgets
    return 
end)

mod:hook(StartGameWindowMissionSelectionConsole, "_setup_levels_by_area", function(func, self, area_name)
	local result = func(self, area_name)
    if replacement_map[area_name] then
        self._dlc_background_widget = nil
    end
    return result
end)