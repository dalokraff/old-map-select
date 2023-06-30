local mod = get_mod("old-map-select")

return {
	name = "Maps for Mission Selection",
	description = mod:localize("mod_description"),
	is_togglable = false,

	options = {
		widgets = {},
	},

	custom_gui_textures = {
		atlases = {
		},
	
		-- Injections
		ui_renderer_injections = {
			{
				"ingame_ui",
				"materials/maps",
			},
			{
				"hero_view",
				"materials/maps",
			},
			{
				"loading_view",
				"materials/maps",
			},
			{
				"rcon_manager",
				"materials/maps",
			},
			{
				"chat_manager",
				"materials/maps",
			},
			{
				"popup_manager",
				"materials/maps",
			},
			{
				"splash_view",
				"materials/maps",
			},
			{
				"twitch_icon_view",
				"materials/maps",
			},
			{
				"disconnect_indicator_view",
				"materials/maps",
			},
		},
	}
}
