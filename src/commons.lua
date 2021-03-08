modName = "Rohlinheatagtmuf_Hdhaotaotfnllsape-atnsasri"

settingNamePrefix = modName .. "-"
settingNames = {
	groups = {
		game = "game",
		map = "map",
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
function makeSettingName(groupName, targetName, optionName)
	result = settingNamePrefix .. groupName
	for _, thingy in ipairs({targetName, optionName}) do
		if thingy ~= "" then
			result = result .. "_" .. thingy
		end
	end
	return result
end

colorSettingValues = {
	identity =                {id = "identity",                lut = "identity"},
	vanilla_day =             {id = "vanilla_day",             lut = "__core__/graphics/color_luts/lut-day.png"},
	vanilla_night =           {id = "vanilla_night",           lut = "__core__/graphics/color_luts/lut-night.png"},
	vanilla_mapNight =        {id = "vanilla_mapNight",        lut = "__core__/graphics/color_luts/night.png"},
	vanilla_nightVision =     {id = "vanilla_nightVision",     lut =  "__core__/graphics/color_luts/nightvision.png"},
	mod_grayNight =           {id = "mod_grayNight",           lut = "__" .. modName .. "__/graphics/color_luts/gray-night-lut.png"},
	mod_blueNight =           {id = "mod_blueNight",           lut = "__" .. modName .. "__/graphics/color_luts/blue-night-lut.png"},
	mod_darkNight =           {id = "mod_darkNight",           lut = "__" .. modName .. "__/graphics/color_luts/dark-night-lut.png"},
	mod_grayDarkNight =       {id = "mod_grayDarkNight",       lut = "__" .. modName .. "__/graphics/color_luts/gray-dark-night-lut.png"},
	mod_blueDarkNight =       {id = "mod_blueDarkNight",       lut = "__" .. modName .. "__/graphics/color_luts/blue-dark-night-lut.png"},
	mod_black =               {id = "mod_black",               lut = "__" .. modName .. "__/graphics/color_luts/black-lut.png"},
	mod_greenishNightVision = {id = "mod_greenishNightVision", lut = "__" .. modName .. "__/graphics/color_luts/greenish-nightvision-lut.png"},
	mod_grayNightVision =     {id = "mod_grayNightVision",     lut = "__" .. modName .. "__/graphics/color_luts/gray-nightvision-lut.png"},
	mod_greenNightVision =    {id = "mod_greenNightVision",    lut = "__" .. modName .. "__/graphics/color_luts/green-nightvision-lut.png"},
}
function colorSetting2lut(colorSetting)
	for _, setting in pairs(colorSettingValues) do
		if setting.id == colorSetting then
			return setting.lut
		end
	end
end
