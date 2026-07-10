-- General
modName = "Rohlinheatagtmuf_Hdhaotaotfnllsape-atnsasri"

-- Known planets
knownPlanets = {"nauvis"}
if mods["space-age"] then
	table.insert(knownPlanets, "vulcanus")
	table.insert(knownPlanets, "gleba")
	table.insert(knownPlanets, "fulgora")
	table.insert(knownPlanets, "aquilo")
end

function isPlanetKnown(planetName)
	for _, knownPlanet in pairs(knownPlanets) do
		if knownPlanet == planetName then
			return true
		end
	end
	return false
end

-- Setting names
settingNamePrefix = modName .. "-"
settingNamesParts = {
	groups = {
		game = "game",
		nightVision = "nightVision",
	},
	targets = {
		day = "day",
		sunset = "sunset",
		night = "night",
		sunrise = "sunrise",
		nightVision = "nightVision",
	},
	options = {
		colors = "colors",
		percent = "percent",
	},
}

function makePlanetSettingName(planet)
	if planet then
		return settingNamePrefix .. "planet_" .. planet
	else
		return settingNamePrefix .. "unknown_planets"
	end
end

function makeOtherSettingName(groupName, targetName, optionName)
	result = settingNamePrefix .. groupName
	for _, thingy in ipairs({targetName, optionName}) do
		if thingy ~= "" then
			result = result .. "_" .. thingy
		end
	end
	return result
end

-- LUT settings values
colorSettingValues = {
	identity =                {lut = "identity",                                                               targetName = settingNamesParts.targets.day        },
	vanilla_day =             {lut = "__core__/graphics/color_luts/lut-day.png",                               targetName = settingNamesParts.targets.day        },
	vanilla_night =           {lut = "__core__/graphics/color_luts/lut-night.png",                             targetName = settingNamesParts.targets.night      },
	vanilla_mapNight =        {lut = "__core__/graphics/color_luts/night.png",                                 targetName = settingNamesParts.targets.night      },
	vanilla_nightVision =     {lut =  "__core__/graphics/color_luts/nightvision.png",                          targetName = settingNamesParts.targets.nightVision},
	mod_grayNight =           {lut = "__" .. modName .. "__/graphics/color_luts/gray-night-lut.png",           targetName = settingNamesParts.targets.night      },
	mod_blueNight =           {lut = "__" .. modName .. "__/graphics/color_luts/blue-night-lut.png",           targetName = settingNamesParts.targets.night      },
	mod_darkNight =           {lut = "__" .. modName .. "__/graphics/color_luts/dark-night-lut.png",           targetName = settingNamesParts.targets.night      },
	mod_grayDarkNight =       {lut = "__" .. modName .. "__/graphics/color_luts/gray-dark-night-lut.png",      targetName = settingNamesParts.targets.night      },
	mod_blueDarkNight =       {lut = "__" .. modName .. "__/graphics/color_luts/blue-dark-night-lut.png",      targetName = settingNamesParts.targets.night      },
	mod_imprDarkNight =       {lut = "__" .. modName .. "__/graphics/color_luts/impr-dark-night-lut.png",      targetName = settingNamesParts.targets.night      },
	mod_imprGrayDarkNight =   {lut = "__" .. modName .. "__/graphics/color_luts/impr-gray-dark-night-lut.png", targetName = settingNamesParts.targets.night      },
	mod_black =               {lut = "__" .. modName .. "__/graphics/color_luts/black-lut.png",                targetName = settingNamesParts.targets.night      },
	mod_greenishNightVision = {lut = "__" .. modName .. "__/graphics/color_luts/greenish-nightvision-lut.png", targetName = settingNamesParts.targets.nightVision},
	mod_grayNightVision =     {lut = "__" .. modName .. "__/graphics/color_luts/gray-nightvision-lut.png",     targetName = settingNamesParts.targets.nightVision},
	mod_greenNightVision =    {lut = "__" .. modName .. "__/graphics/color_luts/green-nightvision-lut.png",    targetName = settingNamesParts.targets.nightVision},
}
