local mod = get_mod("old-map-select")

local definitions = local_require("scripts/mods/old-map-select/old_ui/area_select_definitions")
local widget_definitions = definitions.widgets
local area_widget_definitions = definitions.area_widgets
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions

local area_select_settings = mod:dofile("scripts/mods/old-map-select/old_ui/area_select_settings")

mod:hook(StartGameWindowAreaSelection, "create_ui_elements", function(func, self, params, offset)

    widget_definitions.window_background = UIWidgets.create_simple_texture("reikland_map", "window_background")

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

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(ui_scenegraph, animation_definitions)

	if offset then
		local window_position = ui_scenegraph.window.local_position
		window_position[1] = window_position[1] + offset[1]
		window_position[2] = window_position[2] + offset[2]
		window_position[3] = window_position[3] + offset[3]
	end

end)

-- mod:hook(StartGameWindowAreaSelection, "draw_video", function(func, self, dt)
--     return
-- end)

mod:hook(StartGameWindowAreaSelection, "_setup_area_widgets", function(func, self)
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
	local spacing = 25
	local total_width = widget_width * num_areas + spacing * (num_areas - 1)
	local width_offset = -(total_width / 2) + widget_width / 2
	local assigned_widgets = {}
	local statistics_db = self.statistics_db
	local stats_id = self._stats_id

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
		local num_acts = #acts

		for j = 1, num_acts do
			local act_name = acts[j]
			local difficulty_index = LevelUnlockUtils.highest_completed_difficulty_index_by_act(statistics_db, stats_id, act_name)

			if difficulty_index < highest_completed_difficulty_index then
				highest_completed_difficulty_index = difficulty_index
			end
		end

		local frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(highest_completed_difficulty_index)
		content.frame = frame_texture

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

	return
end)