-- General
modName = "Rohlinheatagtmuf_Hdhaotaotfnllsape-atnsasri"

-- Setting names
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

-- LUT settings values
colorSettingValues = {
	identity =                {id = "identity",                lut = "identity",                                                               targetName = settingNames.targets.day},
	vanilla_day =             {id = "vanilla_day",             lut = "__core__/graphics/color_luts/lut-day.png",                               targetName = settingNames.targets.day},
	vanilla_night =           {id = "vanilla_night",           lut = "__core__/graphics/color_luts/lut-night.png",                             targetName = settingNames.targets.night},
	vanilla_mapNight =        {id = "vanilla_mapNight",        lut = "__core__/graphics/color_luts/night.png",                                 targetName = settingNames.targets.night},
	vanilla_nightVision =     {id = "vanilla_nightVision",     lut =  "__core__/graphics/color_luts/nightvision.png",                          targetName = settingNames.targets.nightVision},
	mod_grayNight =           {id = "mod_grayNight",           lut = "__" .. modName .. "__/graphics/color_luts/gray-night-lut.png",           targetName = settingNames.targets.night},
	mod_blueNight =           {id = "mod_blueNight",           lut = "__" .. modName .. "__/graphics/color_luts/blue-night-lut.png",           targetName = settingNames.targets.night},
	mod_darkNight =           {id = "mod_darkNight",           lut = "__" .. modName .. "__/graphics/color_luts/dark-night-lut.png",           targetName = settingNames.targets.night},
	mod_grayDarkNight =       {id = "mod_grayDarkNight",       lut = "__" .. modName .. "__/graphics/color_luts/gray-dark-night-lut.png",      targetName = settingNames.targets.night},
	mod_blueDarkNight =       {id = "mod_blueDarkNight",       lut = "__" .. modName .. "__/graphics/color_luts/blue-dark-night-lut.png",      targetName = settingNames.targets.night},
	mod_imprDarkNight =       {id = "mod_imprDarkNight",       lut = "__" .. modName .. "__/graphics/color_luts/impr-dark-night-lut.png",      targetName = settingNames.targets.night},
	mod_imprGrayDarkNight =   {id = "mod_imprGrayDarkNight",   lut = "__" .. modName .. "__/graphics/color_luts/impr-gray-dark-night-lut.png", targetName = settingNames.targets.night},
	mod_black =               {id = "mod_black",               lut = "__" .. modName .. "__/graphics/color_luts/black-lut.png",                targetName = settingNames.targets.night},
	mod_greenishNightVision = {id = "mod_greenishNightVision", lut = "__" .. modName .. "__/graphics/color_luts/greenish-nightvision-lut.png", targetName = settingNames.targets.nightVision},
	mod_grayNightVision =     {id = "mod_grayNightVision",     lut = "__" .. modName .. "__/graphics/color_luts/gray-nightvision-lut.png",     targetName = settingNames.targets.nightVision},
	mod_greenNightVision =    {id = "mod_greenNightVision",    lut = "__" .. modName .. "__/graphics/color_luts/green-nightvision-lut.png",    targetName = settingNames.targets.nightVision},
}

function colorSetting2lut(colorSetting)
	for _, setting in pairs(colorSettingValues) do
		if setting.id == colorSetting then
			return setting.lut
		end
	end
end
