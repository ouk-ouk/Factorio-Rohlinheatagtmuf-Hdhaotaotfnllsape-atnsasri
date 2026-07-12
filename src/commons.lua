-- Util functions

function table.insert_all(target, source)
	for _, value in pairs(source) do
		table.insert(target, value)
	end
end

-- General
modName = "Rohlinheatagtmuf_Hdhaotaotfnllsape-atnsasri"

knownMods = {
	spaceAge = "space-age",
}

-- Setting names
settingNamePrefix = modName .. "-"
settingNamesParts = {
	groups = {
		game = "game",
		nightVision = "nightVision",
		spacePlatforms = "spacePlatforms",
	},
	targets = {
		day = "day",
		sunset = "sunset",
		night = "night",
		sunrise = "sunrise",
		nightVision = "nightVision",
		spacePlatforms = "spacePlatforms"
	},
	lutTypes = {
		day = "day",
		inBetween = "inBetween",
		night = "night",
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
	identity =                {lut = "identity",                                                               lutTypeName = settingNamesParts.lutTypes.day        },
	vanilla_frozen =          {lut = "__core__/graphics/color_luts/frozen.png",                                lutTypeName = settingNamesParts.lutTypes.inBetween  },
	vanilla_dawn =            {lut = "__core__/graphics/color_luts/lut-dawn.png",                              lutTypeName = settingNamesParts.lutTypes.inBetween  },
	vanilla_day =             {lut = "__core__/graphics/color_luts/lut-day.png",                               lutTypeName = settingNamesParts.lutTypes.day        },
	vanilla_night =           {lut = "__core__/graphics/color_luts/lut-night.png",                             lutTypeName = settingNamesParts.lutTypes.night      },
	vanilla_sunset =          {lut = "__core__/graphics/color_luts/lut-sunset.png",                            lutTypeName = settingNamesParts.lutTypes.inBetween  },
	vanilla_mapNight =        {lut = "__core__/graphics/color_luts/night.png",                                 lutTypeName = settingNamesParts.lutTypes.night      },
	vanilla_nightVision =     {lut = "__core__/graphics/color_luts/nightvision.png",                           lutTypeName = settingNamesParts.lutTypes.nightVision},
	vanilla_orangeDawn =      {lut = "__core__/graphics/color_luts/orange-dawn.png",                           lutTypeName = settingNamesParts.lutTypes.day        },
	mod_grayNight =           {lut = "__" .. modName .. "__/graphics/color_luts/gray-night-lut.png",           lutTypeName = settingNamesParts.lutTypes.night      },
	mod_blueNight =           {lut = "__" .. modName .. "__/graphics/color_luts/blue-night-lut.png",           lutTypeName = settingNamesParts.lutTypes.night      },
	mod_darkNight =           {lut = "__" .. modName .. "__/graphics/color_luts/dark-night-lut.png",           lutTypeName = settingNamesParts.lutTypes.night      },
	mod_grayDarkNight =       {lut = "__" .. modName .. "__/graphics/color_luts/gray-dark-night-lut.png",      lutTypeName = settingNamesParts.lutTypes.night      },
	mod_blueDarkNight =       {lut = "__" .. modName .. "__/graphics/color_luts/blue-dark-night-lut.png",      lutTypeName = settingNamesParts.lutTypes.night      },
	mod_imprDarkNight =       {lut = "__" .. modName .. "__/graphics/color_luts/impr-dark-night-lut.png",      lutTypeName = settingNamesParts.lutTypes.night      },
	mod_imprGrayDarkNight =   {lut = "__" .. modName .. "__/graphics/color_luts/impr-gray-dark-night-lut.png", lutTypeName = settingNamesParts.lutTypes.night      },
	mod_black =               {lut = "__" .. modName .. "__/graphics/color_luts/black-lut.png",                lutTypeName = settingNamesParts.lutTypes.night      },
	mod_greenishNightVision = {lut = "__" .. modName .. "__/graphics/color_luts/greenish-nightvision-lut.png", lutTypeName = settingNamesParts.lutTypes.nightVision},
	mod_grayNightVision =     {lut = "__" .. modName .. "__/graphics/color_luts/gray-nightvision-lut.png",     lutTypeName = settingNamesParts.lutTypes.nightVision},
	mod_greenNightVision =    {lut = "__" .. modName .. "__/graphics/color_luts/green-nightvision-lut.png",    lutTypeName = settingNamesParts.lutTypes.nightVision},
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

-- Known planets
knownPlanets = {
	{
		name = "nauvis",
		day = {"identity"},
		night = {"__core__/graphics/color_luts/lut-night.png"},
		defaultColors = "planet_both",
		defaultTimes = "proportional",
	},
}
local knownPlanetsFromMods = {
	[knownMods.spaceAge] = {
		{
			name = "vulcanus",
			day = {"__" .. knownMods.spaceAge .. "__/graphics/lut/vulcanus-1-day.png"},
			night = {"__" .. knownMods.spaceAge .. "__/graphics/lut/vulcanus-2-night.png"},
			defaultColors = "planet_night",
			defaultTimes = "proportional",
		},
		{
			name = "gleba",
			day = {"__" .. knownMods.spaceAge .. "__/graphics/lut/gleba-1-noon.png", "__" .. knownMods.spaceAge .. "__/graphics/lut/gleba-2-afternoon.png", "__" .. knownMods.spaceAge .. "__/graphics/lut/gleba-8-morning.png"},
			night = {"__" .. knownMods.spaceAge .. "__/graphics/lut/gleba-5-after-sunset.png", "__" .. knownMods.spaceAge .. "__/graphics/lut/gleba-6-before-dawn.png"},
			defaultColors = "planet_night",
			defaultTimes = "proportional",
		},
		{
			name = "fulgora",
			day = {"__" .. knownMods.spaceAge .. "__/graphics/lut/fulgora-1-noon.png", "__" .. knownMods.spaceAge .. "__/graphics/lut/fulgora-5-morning.png"},
			night = {"__" .. knownMods.spaceAge .. "__/graphics/lut/fulgora-3-after-sunset.png", "__" .. knownMods.spaceAge .. "__/graphics/lut/fulgora-4-before-dawn.png"},
			defaultColors = "planet_night",
			defaultTimes = "literal",
		},
		{
			name = "aquilo",
			defaultColors = "planet_both",
			defaultTimes = "proportional",
		},
	},
}
for modName, knownPlanetsFromMod in pairs(knownPlanetsFromMods) do
	if mods[modName] then
		table.insert_all(knownPlanets, knownPlanetsFromMod)
	end
end

function findKnownPlanet(planetName)
	for _, knownPlanet in pairs(knownPlanets) do
		if knownPlanet.name == planetName then
			return knownPlanet
		end
	end
	return nil
end
