require("commons")

if mods["space-age"] then
	local defaultSpacePlatformsLut = knownPlanets[1].day[1]
	local newSpacePlatformsLut = colorSettingValues[settings.startup[makeOtherSettingId(settingNamesParts.groups.spacePlatforms, settingNamesParts.targets.spacePlatforms, settingNamesParts.options.colors)].value].lut
	if newSpacePlatformsLut ~= defaultSpacePlatformsLut then
		newLutTable = {}
		for _, lutInfo in pairs(data.raw["utility-constants"]["default"]["daytime_color_lookup"]) do
			if lutInfo[2] == defaultSpacePlatformsLut then
				table.insert(newLutTable, {lutInfo[1], newSpacePlatformsLut})
			else
				table.insert(newLutTable, {lutInfo[1], lutInfo[2]})
			end
		end
		data.raw["utility-constants"]["default"]["daytime_color_lookup"] = newLutTable
	end
end
