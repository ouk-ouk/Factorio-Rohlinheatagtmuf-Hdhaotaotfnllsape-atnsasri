require("commons")

local localeNamePrefix = "mod-setting-name."
local localeDescriptionPrefix = "mod-setting-description."
local localeSettingNamePrefix = "mod-setting-name." .. settingNamePrefix
local localeSettingDescriptionPrefix = "mod-setting-description." .. settingNamePrefix

local function makeOrder(groupName, targetName, optionName)
	local function makeOrderPart(name, letters)
		return letters[name] .. "[" .. name .. "]"
	end
	local groupLetters = {[settingNames.groups.game] = "a", [settingNames.groups.map] = "b"}
	local targetLetters = {[settingNames.targets.sunset] = "a", [settingNames.targets.night] = "b", [settingNames.targets.sunrise] = "c"}
	local optionLetters = {[settingNames.options.duration] = "a"}
	return makeOrderPart(groupName, groupLetters) .. "-" .. makeOrderPart(optionName, optionLetters) .. "-" .. makeOrderPart(targetName, targetLetters)
end

local durationSettings = {
	{groupName = settingNames.groups.game, default = 15.0, vanilla = 25.0, targetName = settingNames.targets.sunset},
	{groupName = settingNames.groups.game, default = 30.0, vanilla = 10.0, targetName = settingNames.targets.night},
	{groupName = settingNames.groups.game, default = 15.0, vanilla = 25.0, targetName = settingNames.targets.sunrise},
	{groupName = settingNames.groups.map, default = 15.0, vanilla = 20.0, targetName = settingNames.targets.sunset},
	{groupName = settingNames.groups.map, default = 30.0, vanilla = 10.0, targetName = settingNames.targets.night},
	{groupName = settingNames.groups.map, default = 15.0, vanilla = 20.0, targetName = settingNames.targets.sunrise},
}
for _, setting in ipairs(durationSettings) do
	data:extend({
		{
			type = "double-setting",
			default_value = setting.default,
			minimum_value = 0.0,
			maximum_value = 100.0,
			name = makeSettingName(setting.groupName, setting.targetName, settingNames.options.duration),
			order = makeOrder(setting.groupName, setting.targetName, settingNames.options.duration),
			setting_type = "startup",
			localised_name = {localeNamePrefix .. makeSettingName(setting.groupName, nil, settingNames.options.duration), {localeSettingNamePrefix .. setting.targetName}},
			localised_description = {localeDescriptionPrefix .. makeSettingName(setting.groupName, nil, settingNames.options.duration), {localeSettingDescriptionPrefix .. setting.targetName}, setting.default, setting.vanilla},
		}
	})
end
