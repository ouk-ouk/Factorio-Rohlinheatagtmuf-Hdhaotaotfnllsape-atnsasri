require("commons")

local localeNamePrefix = "mod-setting-name."
local localeDescriptionPrefix = "mod-setting-description."
local localeSettingNamePrefix = "mod-setting-name." .. settingNamePrefix
local localeSettingDescriptionPrefix = "mod-setting-description." .. settingNamePrefix
local localeSettingValueNamePrefix = "string-mod-setting."

local function makeOrder(groupName, targetName, optionName)
	local function makeOrderPart(name, letters)
		return letters[name] .. "[" .. name .. "]"
	end
	local groupLetters = {[settingNames.groups.game] = "a", [settingNames.groups.map] = "b"}
	local targetLetters = {[settingNames.targets.day] = "a", [settingNames.targets.sunset] = "b", [settingNames.targets.night] = "c", [settingNames.targets.sunrise] = "d"}
	local optionLetters = {[settingNames.options.colors] = "a", [settingNames.options.duration] = "b"}
	return makeOrderPart(groupName, groupLetters) .. "-" .. makeOrderPart(optionName, optionLetters) .. "-" .. makeOrderPart(targetName, targetLetters)
end

local function makeAllowedColorValues(targetName)
	local result = {}
	for _, setting in pairs(colorSettingValues) do
		for _, name in ipairs(setting.targetNames) do
			if targetName == name then
				table.insert(result, setting.id)
				break
			end
		end
	end
	return result
end

local colorSettings = {
	{groupName = settingNames.groups.game, default = colorSettingValues.identity,          vanilla = colorSettingValues.identity,         targetName = settingNames.targets.day},
	{groupName = settingNames.groups.game, default = colorSettingValues.mod_blueDarkNight, vanilla = colorSettingValues.vanilla_night,    targetName = settingNames.targets.night},
	{groupName = settingNames.groups.map,  default = colorSettingValues.identity,          vanilla = colorSettingValues.identity,         targetName = settingNames.targets.day},
	{groupName = settingNames.groups.map,  default = colorSettingValues.mod_grayNight,     vanilla = colorSettingValues.vanilla_mapNight, targetName = settingNames.targets.night},
}
for _, setting in ipairs(colorSettings) do
	optionName = settingNames.options.colors
	data:extend({
		{
			type = "string-setting",
			default_value = setting.default.id,
			allowed_values = makeAllowedColorValues(setting.targetName),
			name = makeSettingName(setting.groupName, setting.targetName, optionName),
			order = makeOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {localeNamePrefix .. makeSettingName(setting.groupName, "", optionName), {localeSettingNamePrefix .. setting.targetName}},
			localised_description = {localeDescriptionPrefix .. makeSettingName(setting.groupName, "", optionName), {localeSettingDescriptionPrefix .. setting.targetName}, {localeSettingValueNamePrefix .. makeSettingName(setting.groupName, setting.targetName, optionName) .. "-" .. setting.default.id}, {localeSettingValueNamePrefix .. makeSettingName(setting.groupName, setting.targetName, optionName) .. "-" .. setting.vanilla.id}},
		}
	})
end

local durationSettings = {
	{groupName = settingNames.groups.game, default = 15.0, vanilla = 25.0, targetName = settingNames.targets.sunset},
	{groupName = settingNames.groups.game, default = 30.0, vanilla = 10.0, targetName = settingNames.targets.night},
	{groupName = settingNames.groups.game, default = 15.0, vanilla = 25.0, targetName = settingNames.targets.sunrise},
	{groupName = settingNames.groups.map,  default = 15.0, vanilla = 20.0, targetName = settingNames.targets.sunset},
	{groupName = settingNames.groups.map,  default = 30.0, vanilla = 10.0, targetName = settingNames.targets.night},
	{groupName = settingNames.groups.map,  default = 15.0, vanilla = 20.0, targetName = settingNames.targets.sunrise},
}
for _, setting in ipairs(durationSettings) do
	optionName = settingNames.options.duration
	data:extend({
		{
			type = "double-setting",
			default_value = setting.default,
			minimum_value = 0.0,
			maximum_value = 100.0,
			name = makeSettingName(setting.groupName, setting.targetName, optionName),
			order = makeOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {localeNamePrefix .. makeSettingName(setting.groupName, "", optionName), {localeSettingNamePrefix .. setting.targetName}},
			localised_description = {localeDescriptionPrefix .. makeSettingName(setting.groupName, "", optionName), {localeSettingDescriptionPrefix .. setting.targetName}, setting.default, setting.vanilla},
		}
	})
end
