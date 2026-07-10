require("commons")
require("prototypes.planets-common")

-- Color lookups for specific planets
local planetIsEnabled = settings.startup[makePlanetSettingName(nil)].value
for _, planet in pairs(data.raw.planet) do
	if not isPlanetKnown(planet.name) then
		local srp = planet.surface_render_parameters
		if not srp then
			srp = {}
		end
		local dncColorLookup = srp.day_night_cycle_color_lookup
		if dncColorLookup and planetIsEnabled then
			srp.day_night_cycle_color_lookup = makeColorLookup(settingNamesParts.groups.game)
		end
		if not dncColorLookup and not planetIsEnabled then
			srp.day_night_cycle_color_lookup = oldDefaultColorLookup
		end
	end
end
