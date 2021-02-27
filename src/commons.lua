modName = "Rohlinheatagtmuf Hdhaotaotfnllsape'atnsasri"

settingNamePrefix = modName .. "-"
settingNames = {
	groups = {
		game = "game",
		map = "map",
	},
	targets = {
		sunset = "sunset",
		night = "night",
		sunrise = "sunrise",
	},
	options = {
		duration = "duration",
	},
}
function makeSettingName(groupName, targetName, optionName)
	if targetName == nil then
		return modName .. "-" .. groupName .. "_" .. optionName
	else
		return modName .. "-" .. groupName .. "_" .. targetName .. "-" .. optionName
	end
end
