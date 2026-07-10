require("commons")
require("prototypes.planets-common")

-- Default color lookups
oldDefaultColorLookup = data.raw["utility-constants"]["default"]["daytime_color_lookup"]
data.raw["utility-constants"]["default"]["daytime_color_lookup"] = makeColorLookup(settingNamesParts.groups.game)

-- Color lookups for specific planets
for _, planet in pairs(data.raw.planet) do
	if isPlanetKnown(planet.name) then
		local srp = planet.surface_render_parameters
		if not srp then
			srp = {}
		end
		local dncColorLookup = srp.day_night_cycle_color_lookup
		local planetIsEnabled = settings.startup[makePlanetSettingName(planet.name)].value
		if dncColorLookup and planetIsEnabled then
			srp.day_night_cycle_color_lookup = makeColorLookup(settingNamesParts.groups.game)
		end
		if not dncColorLookup and not planetIsEnabled then
			srp.day_night_cycle_color_lookup = oldDefaultColorLookup
		end
	end
end
