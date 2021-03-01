modName = "Rohlinheatagtmuf Hdhaotaotfnllsape'atnsasri"

settingNamePrefix = modName .. "-"
settingNames = {
	groups = {
		game = "game",
		map = "map",
	},
	targets = {
		day = "day",
		sunset = "sunset",
		night = "night",
		sunrise = "sunrise",
	},
	options = {
		colors = "colors",
		duration = "duration",
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
	none =              {id = "none",              lut = nil,                                                                 targetNames = {settingNames.targets.sunset, settingNames.targets.sunrise}},
	identity =          {id = "identity",          lut = "identity",                                                          targetNames = {settingNames.targets.day}},
	vanilla_day =       {id = "vanilla_day",       lut = "__core__/graphics/color_luts/lut-day.png",                          targetNames = {settingNames.targets.day}},
	vanilla_night =     {id = "vanilla_night",     lut = "__core__/graphics/color_luts/lut-night.png",                        targetNames = {settingNames.targets.night}},
	vanilla_mapNight =  {id = "vanilla_mapNight",  lut = "__core__/graphics/color_luts/night.png",                            targetNames = {settingNames.targets.night}},
	vanilla_dawn =      {id = "vanilla_dawn",      lut = "__core__/graphics/color_luts/lut-dawn.png",                         targetNames = {settingNames.targets.sunset, settingNames.targets.sunrise}},
	mod_grayNight =     {id = "mod_grayNight",     lut = "__" .. modName .. "__/graphics/color_luts/gray-night-lut.png",      targetNames = {settingNames.targets.night}},
	mod_blueNight =     {id = "mod_blueNight",     lut = "__" .. modName .. "__/graphics/color_luts/blue-night-lut.png",      targetNames = {settingNames.targets.night}},
	mod_darkNight =     {id = "mod_darkNight",     lut = "__" .. modName .. "__/graphics/color_luts/dark-night-lut.png",      targetNames = {settingNames.targets.night}},
	mod_grayDarkNight = {id = "mod_grayDarkNight", lut = "__" .. modName .. "__/graphics/color_luts/gray-dark-night-lut.png", targetNames = {settingNames.targets.night}},
	mod_blueDarkNight = {id = "mod_blueDarkNight", lut = "__" .. modName .. "__/graphics/color_luts/blue-dark-night-lut.png", targetNames = {settingNames.targets.night}},
	mod_black =         {id = "mod_black",         lut = "__" .. modName .. "__/graphics/color_luts/black-lut.png",           targetNames = {settingNames.targets.night}},
	mod_orangeDawn =    {id = "vanilla_dawn",      lut = "__core__/graphics/color_luts/lut-dawn.png",                         targetNames = {settingNames.targets.sunset, settingNames.targets.sunrise}},
}
