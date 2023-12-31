local mod = get_mod("old-map-select")

local definitions = mod:dofile("scripts/mods/old-map-select/console_ui/area_select_definitions")
local widget_definitions = definitions.widgets
local area_widget_definitions = definitions.area_widgets
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions

local area_select_settings = mod:dofile("scripts/mods/old-map-select/console_ui/area_select_settings")

local map_changes = function()
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
end


--copy of vanilla funciton so it uses my altered definitions
mod:hook(StartGameWindowAreaSelectionConsole, "create_ui_elements", function(func, self, params, offset)

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
	local area_widgets = {}
	local area_widgets_by_name = {}

	for name, widget_definition in pairs(area_widget_definitions) do
		local widget = UIWidget.init(widget_definition)
		area_widgets[#area_widgets + 1] = widget
		area_widgets_by_name[name] = widget
	end

	self._area_widgets = area_widgets
	self._area_widgets_by_name = area_widgets_by_name

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(ui_scenegraph, animation_definitions)

	if offset then
		local window_position = ui_scenegraph.window.local_position
		window_position[1] = window_position[1] + offset[1]
		window_position[2] = window_position[2] + offset[2]
		window_position[3] = window_position[3] + offset[3]
	end

end)


--copy of vanilla function except one constant change to prevent fade in when swapping areas
mod:hook(StartGameWindowAreaSelectionConsole, "_assign_video_player", function(func, self, material_name, video_player)
    self:_destroy_video_widget()

	local scenegraph_id = "video"
	local video_widget_definition = UIWidgets.create_fixed_aspect_video(scenegraph_id, material_name)
	local video_widget = UIWidget.init(video_widget_definition)
	video_widget.content.video_content.video_player = video_player
	local ui_top_renderer = self.ui_top_renderer
	local world = ui_top_renderer.world

	World.add_video_player(world, video_player)

	self._video_widget = video_widget
	self._video_created = true
	self._draw_video_next_frame = true
	local background_widget = self._widgets_by_name.background
	local background_widget_style = background_widget.style
	local color = background_widget_style.rect.color
    --this is the problem function; i altered the foruth arg 255 -> 0
	self._ui_animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, color, 1, 0, 0, 1, math.easeOutCubic)

    return 
end)

--copy of the vanilla funciton except, added in some logic to handle on the spot replacement of the area map
mod:hook(StartGameWindowAreaSelectionConsole, "_setup_area_widgets", function(func, self)

    local sorted_area_settings = {}

	for _, settings in pairs(AreaSettings) do
		if not settings.exclude_from_area_selection then
			sorted_area_settings[#sorted_area_settings + 1] = settings
		end
	end

	local function sort_func(a, b)
		return a.sort_order < b.sort_order
	end

	table.sort(sorted_area_settings, sort_func)

	local num_areas = #sorted_area_settings
	local widget_size = scenegraph_definition.area_root.size
	local widget_width = widget_size[1]
	local spacing = 50
	local total_width = widget_width * num_areas + spacing * (num_areas - 1)
	local width_offset = -(total_width / 2) + widget_width / 2
	local statistics_db = self.statistics_db
	local stats_id = self._stats_id
	local assigned_widgets = {}

	for i = 1, num_areas do
		local settings = sorted_area_settings[i]
		local widget = self._area_widgets[i]
		assigned_widgets[i] = widget
		local level_image = settings.level_image
		local content = widget.content
		content.icon = level_image
		local unlocked = true
		local dlc_name = settings.dlc_name

		if dlc_name then
			unlocked = Managers.unlock:is_dlc_unlocked(dlc_name)
		end

		local name = settings.name
		content.locked = not unlocked
		content.area_name = name
		local highest_completed_difficulty_index = math.huge
		local acts = settings.acts

		for j = 1, #acts do
			local act_name = acts[j]
			local difficulty_index = LevelUnlockUtils.highest_completed_difficulty_index_by_act(statistics_db, stats_id, act_name)

			if difficulty_index < highest_completed_difficulty_index then
				highest_completed_difficulty_index = difficulty_index
			end
		end

		local frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(highest_completed_difficulty_index)
		content.frame = frame_texture
		local offset = widget.offset
		offset[1] = width_offset
		width_offset = width_offset + widget_width + spacing

        local new_settings = area_select_settings[name]
		if new_settings then
			widget.offset = new_settings.offset
			content.icon = new_settings.icon
		else
			local offset = widget.offset
			offset[1] = width_offset
			width_offset = width_offset + widget_width + spacing
		end
	end

	self._active_area_widgets = assigned_widgets

end)


--the console UI video widget is fixed aspect, this completely overwrites that function as it's only used in one place as far as i can tell
mod:hook(UIWidgets, "create_fixed_aspect_video", function(func, scenegraph_id, material_name, video_player_reference)

    return UIWidgets.create_video(scenegraph_id, material_name, video_player_reference)
end)
