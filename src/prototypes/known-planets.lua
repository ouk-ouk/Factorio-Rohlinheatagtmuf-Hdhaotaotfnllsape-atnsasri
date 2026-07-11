require("commons")
require("prototypes.planets-common")

-- Color lookups for specific planets
for _, planet in pairs(data.raw.planet) do
	knownPlanet = findKnownPlanet(planet.name)
	if knownPlanet then
		if not knownPlanet.day or not knownPlanet.night then
			knownPlanet = knownPlanets[1]
		end
		local srp = planet.surface_render_parameters
		local timeChangeSetting = settings.startup[makeTimeSettingId(planet.name)].value
		local colorChangeSetting = colorChangeSettingValues[settings.startup[makeColorSettingId(planet.name)].value]
		modifyLUTsForPlanet(planet, knownPlanet, timeChangeSetting, colorChangeSetting)
	end
end
