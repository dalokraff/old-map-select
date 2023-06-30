local mod = get_mod("old-map-select")
local OldMapUtils = mod:dofile("scripts/mods/old-map-select/utils")
OldMapUtils_create_level_widget = OldMapUtils.create_level_widget

local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_definitions")
local widget_definitions = definitions.widgets
local large_window_size = definitions.large_window_size
local create_level_widget_definition = definitions.create_level_widget
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
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/old_ui/area_settings/bogenhafen"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/old_ui/area_settings/holly"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/old_ui/area_settings/helmgart"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/old_ui/area_settings/penny"))
table.merge(replacement_settings, mod:dofile("scripts/mods/old-map-select/old_ui/area_settings/karak_azgaraz"))
local old_map_icon_size = 0.3


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
        scenegraph_level_icon_resize(old_map_icon_size)
    else 
        widget_definitions.window_background = UIWidgets.create_simple_texture("mission_select_screen_bg", "window_background")
        scenegraph_level_icon_resize(1)
    end
end



mod:hook(StartGameWindowMissionSelection, "create_ui_elements", function(func, self, params, offset)

    local area_name = self.parent:get_selected_area_name()
    
    map_changes(area_name)

    local ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.ui_scenegraph = ui_scenegraph
	local widgets = {}
	local widgets_by_name = {}

	for name, widget_definition in pairs(widget_definitions) do
		local widget = UIWidget.init(widget_definition)
		widgets[#widgets + 1] = widget
		widgets_by_name[name] = widget
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(ui_scenegraph, animation_definitions)

	if offset then
		local window_position = ui_scenegraph.window.local_position
		window_position[1] = window_position[1] + offset[1]
		window_position[2] = window_position[2] + offset[2]
		window_position[3] = window_position[3] + offset[3]
	end

end)

mod:hook(StartGameWindowMissionSelection, "_present_acts", function(func, self, acts)
    local area_name = self.parent:get_selected_area_name()
    if not replacement_map[area_name] then
        return func(self, acts)
    end

    local is_dlc = self._is_dlc

	if is_dlc then
		local ui_scenegraph = self.ui_scenegraph
		local level_root_node = ui_scenegraph.level_root_node
		local large_window_width = large_window_size[1]
		level_root_node.local_position[1] = large_window_width / 2
	end

	local statistics_db = self.statistics_db
	local stats_id = self._stats_id
	local assigned_widgets = {}
	local level_width = 180
	local level_width_spacing = is_dlc and 80 or 34
	local level_height_spacing = 250
	local max_act_number = 3
	local levels_by_act = self._levels_by_act

    for act_key, levels in pairs(levels_by_act) do
        if not acts or table.contains(acts, act_key) then
            local act_settings = ActSettings[act_key]
			local act_sorting = act_settings.sorting
			local act_index = (act_sorting - 1) % max_act_number + 1
			local num_levels_in_act = #levels
			local level_position_x = 0
			local level_position_y = 0
			local act_position_y = 0
			local is_end_act = max_act_number < act_sorting

			for i = 1, #levels do
				local level_data = levels[i]

				local index = #assigned_widgets + 1
				local scenegraph_id = "level_root_" .. index
				local mission_selection_offset = level_data.mission_selection_offset
                local level_key = level_data.level_id
                local widget_scale = 1
                local new_settings = replacement_settings[level_key]
                local level_image = level_data.level_image

                if new_settings then
                    widget_scale = old_map_icon_size
                    level_image = new_settings.level_image
                end

				local widget_definition = OldMapUtils_create_level_widget(scenegraph_id, mission_selection_offset, widget_scale)
				local widget = UIWidget.init(widget_definition)
				local content = widget.content
				local style = widget.style
				local level_display_name = level_data.display_name
				content.text = Localize(level_display_name)
				local level_unlocked = LevelUnlockUtils.level_unlocked(statistics_db, stats_id, level_key)
				local completed_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, level_key)
				local selection_frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_difficulty_index)
				content.frame = selection_frame_texture
				content.locked = not level_unlocked
				content.act_key = act_key
				content.level_key = level_key
				
				if level_image then
					content.icon = level_image or "icons_placeholder"
				else
					content.icon = "icons_placeholder"
				end

				local boss_level = level_data.boss_level
				content.level_data = level_data
				content.boss_level = boss_level

				if not mission_selection_offset then
					local offset = widget.offset
					offset[1] = level_position_x
					offset[2] = act_position_y + level_position_y
				end

				if i < num_levels_in_act then
					local next_level_key = levels[i + 1].level_id
					local next_level_unlocked = LevelUnlockUtils.level_unlocked(statistics_db, stats_id, next_level_key)
					content.draw_path = act_settings.draw_path or not is_dlc
					content.draw_path_fill = next_level_unlocked
					style.path.texture_size[1] = level_width + level_width_spacing
					style.path_glow.texture_size[1] = level_width + level_width_spacing
				end

                if new_settings then
                    local offset = widget.offset
                    offset[1] = new_settings.pos_x
                    offset[2] = new_settings.pos_y
                    content.draw_path = nil
                    content.draw_path_fill = nil
                end

				assigned_widgets[index] = widget
				level_position_x = level_position_x + level_width + level_width_spacing
			end
        end
    end

    self._active_node_widgets = assigned_widgets

    return
end)

mod:hook(StartGameWindowMissionSelection, "_setup_levels_by_area", function(func, self, area_name)
	local result = func(self, area_name)
    if replacement_map[area_name] then
        self._dlc_background_widget = nil
    end
    return result
end)