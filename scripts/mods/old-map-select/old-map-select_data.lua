local mod = get_mod("old-map-select")

return {
	name = "old-map-select",
	description = mod:localize("mod_description"),
	is_togglable = true,

	custom_gui_textures = {
		atlases = {
			-- {
			-- 	"materials/maps",
			-- 	"bogenhafen_map",
			-- 	nil,
			-- 	nil,
			-- 	nil,
			-- 	"bogenhafen_map",
			-- },
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