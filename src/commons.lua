-- Util functions

function table.insert_all(target, source)
	for _, value in pairs(source) do
		table.insert(target, value)
	end
end

-- General
modName = "Rohlinheatagtmuf_Hdhaotaotfnllsape-atnsasri"

-- Known planets
knownPlanets = {
		{
			name = "nauvis",
			day = {"identity"},
			night = {"__core__/graphics/color_luts/lut-night.png"},
		},
	}
if mods["space-age"] then
	table.insert_all(knownPlanets, {
		{
			name = "vulcanus",
			day = {"__space-age__/graphics/lut/vulcanus-1-day.png"},
			night = {"__space-age__/graphics/lut/vulcanus-2-night.png"},
		},
		{
			name = "gleba",
			day = {"__space-age__/graphics/lut/gleba-1-noon.png"},
			night = {"__space-age__/graphics/lut/gleba-5-after-sunset.png", "__space-age__/graphics/lut/gleba-6-before-dawn.png"},
		},
		{
			name = "fulgora",
			day = {"__space-age__/graphics/lut/fulgora-1-noon.png"},
			night = {"__space-age__/graphics/lut/fulgora-3-after-sunset.png", "__space-age__/graphics/lut/fulgora-4-before-dawn.png"},
		},
		{
			name = "aquilo",
		},
	})
end

function findKnownPlanet(planetName)
	for _, knownPlanet in pairs(knownPlanets) do
		if knownPlanet.name == planetName then
			return knownPlanet
		end
	end
	return nil
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

-- Planet settings

colorChangeSettingValues = {
	planet_both =   {changeDay = true,  changeNight = true , vanillaLuts = false},
	planet_day =    {changeDay = true,  changeNight = false, vanillaLuts = false},
	planet_night =  {changeDay = false, changeNight = true , vanillaLuts = false},
	planet_none =   {changeDay = false, changeNight = false, vanillaLuts = false},
	vanilla_both =  {changeDay = true,  changeNight = true , vanillaLuts = true },
	vanilla_day =   {changeDay = true,  changeNight = false, vanillaLuts = true },
	vanilla_night = {changeDay = false, changeNight = true , vanillaLuts = true },
	vanilla_none =  {changeDay = false, changeNight = false, vanillaLuts = true },
}
colorChangeSettingNames = {}
for name, _  in pairs(colorChangeSettingValues) do
	table.insert(colorChangeSettingNames, name)
end
colorChangeSettingNamesForUnknown = {}
for name, value  in pairs(colorChangeSettingValues) do
	if value.vanillaLuts or (not value.changeDay and not value.changeNight) then
		table.insert(colorChangeSettingNamesForUnknown, name)
	end
end
function makeColorSettingId(planet)
	if planet then
		return settingNamePrefix .. planet .. "_color"
	else
		return settingNamePrefix .. "unknown_planet_color"
	end
end

timeChangeSettingNames = {
	"proportional",
	"literal",
	"unchanged",
}
timeChangeSettingNamesForUnknown = {"literal", "unchanged"}
function makeTimeSettingId(planet)
	if planet then
		return settingNamePrefix .. planet .. "_time"
	else
		return settingNamePrefix .. "unknown_planet_time"
	end
end

-- LUT settings

colorSettingValues = {
	identity =                {lut = "identity",                                                               targetName = settingNamesParts.targets.day        },
	vanilla_day =             {lut = "__core__/graphics/color_luts/lut-day.png",                               targetName = settingNamesParts.targets.day        },
	vanilla_night =           {lut = "__core__/graphics/color_luts/lut-night.png",                             targetName = settingNamesParts.targets.night      },
	vanilla_mapNight =        {lut = "__core__/graphics/color_luts/night.png",                                 targetName = settingNamesParts.targets.night      },
	vanilla_nightVision =     {lut = "__core__/graphics/color_luts/nightvision.png",                           targetName = settingNamesParts.targets.nightVision},
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

-- General settings

function makeOtherSettingId(groupName, targetName, optionName)
	result = settingNamePrefix .. groupName
	for _, thingy in ipairs({targetName, optionName}) do
		if thingy ~= "" then
			result = result .. "_" .. thingy
		end
	end
	return result
end
