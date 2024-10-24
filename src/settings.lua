require("commons")

-- Constants & utils
local localeNamePrefix = "mod-setting-name."
local localeDescriptionPrefix = "mod-setting-description."
local localeSettingNamePrefix = "mod-setting-name." .. settingNamePrefix
local localeSettingDescriptionPrefix = "mod-setting-description." .. settingNamePrefix
local localeSettingValueNamePrefix = "string-mod-setting."

local function makeOrder(groupName, targetName, optionName)
	local function makeOrderPart(name, letters)
		return letters[name] .. "[" .. name .. "]"
	end
	local groupLetters = {[settingNames.groups.game] = "a", [settingNames.groups.map] = "b", [settingNames.groups.nightVision] = "c"}
	local targetLetters = {[settingNames.targets.day] = "a", [settingNames.targets.sunset] = "b", [settingNames.targets.night] = "c", [settingNames.targets.sunrise] = "d", [settingNames.targets.nightVision] = "e"}
	local optionLetters = {[settingNames.options.colors] = "a", [settingNames.options.percent] = "b"}
	return makeOrderPart(groupName, groupLetters) .. "-" .. makeOrderPart(optionName, optionLetters) .. "-" .. makeOrderPart(targetName, targetLetters)
end

-- LUT settings
local allowedColorValues = {}
for _, targetName in pairs(settingNames.targets) do
	for _, setting in pairs(colorSettingValues) do
		if setting.targetName == targetName then
			table.insert(allowedColorValues, setting.id)
		end
	end
end

local colorSettings = {
	{groupName = settingNames.groups.game,        default = colorSettingValues.identity,             vanilla = colorSettingValues.identity,            targetName = settingNames.targets.day},
	{groupName = settingNames.groups.game,        default = colorSettingValues.mod_imprDarkNight,    vanilla = colorSettingValues.vanilla_night,       targetName = settingNames.targets.night},
	{groupName = settingNames.groups.map,         default = colorSettingValues.identity,             vanilla = colorSettingValues.identity,            targetName = settingNames.targets.day},
	{groupName = settingNames.groups.map,         default = colorSettingValues.mod_grayNight,        vanilla = colorSettingValues.vanilla_mapNight,    targetName = settingNames.targets.night},
	{groupName = settingNames.groups.nightVision, default = colorSettingValues.mod_greenNightVision, vanilla = colorSettingValues.vanilla_nightVision, targetName = settingNames.targets.nightVision},
}

for _, setting in ipairs(colorSettings) do
	optionName = settingNames.options.colors
	data:extend({
		{
			type = "string-setting",
			default_value = setting.default.id,
			allowed_values = allowedColorValues,
			name = makeSettingName(setting.groupName, setting.targetName, optionName),
			order = makeOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {
				localeNamePrefix .. makeSettingName(setting.groupName, "", optionName),
				{localeSettingNamePrefix .. setting.targetName}
			},
			localised_description = {
				localeDescriptionPrefix .. makeSettingName(setting.groupName, "", optionName),
				{localeSettingDescriptionPrefix .. setting.targetName},
				{localeSettingValueNamePrefix .. makeSettingName(setting.groupName, setting.targetName, optionName) .. "-" .. setting.default.id},
				{localeSettingValueNamePrefix .. makeSettingName(setting.groupName, setting.targetName, optionName) .. "-" .. setting.vanilla.id},
				setting.targetName == settingNames.targets.day and {localeDescriptionPrefix .. makeSettingName("darkDayWarning")} or ""
			},
		}
	})
end

-- Percent settings
local percentSettings = {
	{groupName = settingNames.groups.game,        default = 15.0, vanilla = 25.0, targetName = settingNames.targets.sunset},
	{groupName = settingNames.groups.game,        default = 30.0, vanilla = 10.0, targetName = settingNames.targets.night},
	{groupName = settingNames.groups.game,        default = 15.0, vanilla = 25.0, targetName = settingNames.targets.sunrise},
	{groupName = settingNames.groups.map,         default = 15.0, vanilla = 20.0, targetName = settingNames.targets.sunset},
	{groupName = settingNames.groups.map,         default = 30.0, vanilla = 10.0, targetName = settingNames.targets.night},
	{groupName = settingNames.groups.map,         default = 15.0, vanilla = 20.0, targetName = settingNames.targets.sunrise},
	{groupName = settingNames.groups.nightVision, default = 70.0, vanilla = 50.0, targetName = settingNames.targets.nightVision},
}

for _, setting in ipairs(percentSettings) do
	optionName = settingNames.options.percent
	data:extend({
		{
			type = "double-setting",
			default_value = setting.default,
			minimum_value = 0.0,
			maximum_value = 100.0,
			name = makeSettingName(setting.groupName, setting.targetName, optionName),
			order = makeOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {
				localeNamePrefix .. makeSettingName(setting.groupName, "", optionName),
				{localeSettingNamePrefix .. setting.targetName}
			},
			localised_description = {
				localeDescriptionPrefix .. makeSettingName(setting.groupName, "", optionName),
				{localeSettingDescriptionPrefix .. setting.targetName},
				tostring(setting.default), tostring(setting.vanilla)
			},
		}
	})
end
