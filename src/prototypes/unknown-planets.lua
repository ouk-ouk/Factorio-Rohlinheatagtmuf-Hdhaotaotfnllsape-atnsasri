require("commons")
require("prototypes.planets-common")

-- Color lookups for specific planets
local timeChangeSetting = settings.startup[makeTimeSettingId(nil)].value
local colorChangeSetting = colorChangeSettingValues[settings.startup[makeColorSettingId(nil)].value]
for _, planet in pairs(data.raw.planet) do
	if not findKnownPlanet(planet.name) then
		local srp = planet.surface_render_parameters
		modifyLUTsForPlanet(planet, knownPlanets[1], timeChangeSetting, colorChangeSetting)
	end
end
