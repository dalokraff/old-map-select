return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`old-map-select` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("old-map-select", {
			mod_script       = "scripts/mods/old-map-select/old-map-select",
			mod_data         = "scripts/mods/old-map-select/old-map-select_data",
			mod_localization = "scripts/mods/old-map-select/old-map-select_localization",
		})
	end,
	packages = {
		"resource_packages/old-map-select/old-map-select",
	},
}
