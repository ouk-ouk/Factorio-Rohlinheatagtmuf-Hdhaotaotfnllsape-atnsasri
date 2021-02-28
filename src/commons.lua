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
	identity = {id = "identity", lut = "identity"},
	vanilla_day = {id = "vanilla_day", lut = "__core__/graphics/color_luts/lut-day.png"},
	vanilla_night = {id = "vanilla_night", lut = "__core__/graphics/color_luts/lut-night.png"},
	vanilla_mapNight = {id = "vanilla_mapNight", lut = "__core__/graphics/color_luts/night.png"},
}
