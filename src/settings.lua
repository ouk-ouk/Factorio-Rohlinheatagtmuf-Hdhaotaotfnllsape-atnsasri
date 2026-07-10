require("commons")

-- Constants & utils
local localeNamePrefix = "mod-setting-name."
local localeDescriptionPrefix = "mod-setting-description."
local localeSettingNamePrefix = localeNamePrefix .. settingNamePrefix
local localeSettingDescriptionPrefix = localeDescriptionPrefix .. settingNamePrefix
local localeSettingValueNamePrefix = "string-mod-setting."

local function makeOtherOrder(groupName, targetName, optionName)
	local function makeOtherOrderPart(name, letters)
		return letters[name] .. "[" .. name .. "]"
	end
	local groupLetters = {[settingNamesParts.groups.game] = "b", [settingNamesParts.groups.nightVision] = "c"}
	local targetLetters = {[settingNamesParts.targets.day] = "a", [settingNamesParts.targets.sunset] = "b", [settingNamesParts.targets.night] = "c", [settingNamesParts.targets.sunrise] = "d", [settingNamesParts.targets.nightVision] = "e"}
	local optionLetters = {[settingNamesParts.options.colors] = "a", [settingNamesParts.options.percent] = "b"}
	return makeOtherOrderPart(groupName, groupLetters) .. "-" .. makeOtherOrderPart(optionName, optionLetters) .. "-" .. makeOtherOrderPart(targetName, targetLetters)
end

-- Planets settings

local planetOrderMain = "a"
local currentPlanetOrder = "a"
for _, knownPlanet in pairs(knownPlanets) do
	data:extend({
		{
			type = "bool-setting",
			default_value = true,
			name = makePlanetSettingName(knownPlanet),
			order = planetOrderMain .. currentPlanetOrder .. '-[' .. knownPlanet .. ']',
			setting_type = "startup",
			localised_name = {
				localeSettingNamePrefix .. "planet",
				knownPlanet:sub(1, 1):upper() .. knownPlanet:sub(2),
			},
			localised_description = {
				localeSettingDescriptionPrefix .. "planet",
				knownPlanet:sub(1, 1):upper() .. knownPlanet:sub(2),
			},
		}
	})
	currentPlanetOrder = string.char(currentPlanetOrder:byte() + 1)
end
data:extend({
	{
		type = "bool-setting",
		default_value = false,
		name = makePlanetSettingName(nil),
		order = planetOrderMain .. currentPlanetOrder .. '-[' .. "unknowns" .. ']',
		setting_type = "startup",
		localised_name = {
			localeSettingNamePrefix .. "unknown_planets",
		},
		localised_description = {
			localeSettingDescriptionPrefix .. "unknown_planets",
		},
	}
})

-- LUT settings
local allowedColorValues = {}
for _, targetName in pairs(settingNamesParts.targets) do
	for id, setting in pairs(colorSettingValues) do
		if setting.targetName == targetName then
			table.insert(allowedColorValues, id)
		end
	end
end

local colorSettings = {
	{groupName = settingNamesParts.groups.game,        default = "identity",             vanilla = "identity",            targetName = settingNamesParts.targets.day},
	{groupName = settingNamesParts.groups.game,        default = "mod_imprDarkNight",    vanilla = "vanilla_night",       targetName = settingNamesParts.targets.night},
	{groupName = settingNamesParts.groups.nightVision, default = "mod_greenNightVision", vanilla = "vanilla_nightVision", targetName = settingNamesParts.targets.nightVision},
}

for _, setting in ipairs(colorSettings) do
	optionName = settingNamesParts.options.colors
	data:extend({
		{
			type = "string-setting",
			default_value = setting.default,
			allowed_values = allowedColorValues,
			name = makeOtherSettingName(setting.groupName, setting.targetName, optionName),
			order = makeOtherOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {
				localeNamePrefix .. makeOtherSettingName(setting.groupName, "", optionName),
				{localeSettingNamePrefix .. setting.targetName}
			},
			localised_description = {
				localeDescriptionPrefix .. makeOtherSettingName(setting.groupName, "", optionName),
				{localeSettingDescriptionPrefix .. setting.targetName},
				{localeSettingValueNamePrefix .. makeOtherSettingName(setting.groupName, setting.targetName, optionName) .. "-" .. setting.default},
				{localeSettingValueNamePrefix .. makeOtherSettingName(setting.groupName, setting.targetName, optionName) .. "-" .. setting.vanilla},
				setting.targetName == settingNamesParts.targets.day and {localeDescriptionPrefix .. makeOtherSettingName("darkDayWarning")} or ""
			},
		}
	})
end

-- Percent settings
local percentSettings = {
	{groupName = settingNamesParts.groups.game,        default = 15.0, vanilla = 25.0, targetName = settingNamesParts.targets.sunset},
	{groupName = settingNamesParts.groups.game,        default = 30.0, vanilla = 10.0, targetName = settingNamesParts.targets.night},
	{groupName = settingNamesParts.groups.game,        default = 15.0, vanilla = 25.0, targetName = settingNamesParts.targets.sunrise},
	{groupName = settingNamesParts.groups.nightVision, default = 70.0, vanilla = 50.0, targetName = settingNamesParts.targets.nightVision},
}

for _, setting in ipairs(percentSettings) do
	optionName = settingNamesParts.options.percent
	data:extend({
		{
			type = "double-setting",
			default_value = setting.default,
			minimum_value = 0.0,
			maximum_value = 100.0,
			name = makeOtherSettingName(setting.groupName, setting.targetName, optionName),
			order = makeOtherOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {
				localeNamePrefix .. makeOtherSettingName(setting.groupName, "", optionName),
				{localeSettingNamePrefix .. setting.targetName}
			},
			localised_description = {
				localeDescriptionPrefix .. makeOtherSettingName(setting.groupName, "", optionName),
				{localeSettingDescriptionPrefix .. setting.targetName},
				tostring(setting.default), tostring(setting.vanilla)
			},
		}
	})
end
