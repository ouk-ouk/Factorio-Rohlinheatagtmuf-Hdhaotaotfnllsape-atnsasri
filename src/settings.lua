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
	local groupLetters = {[settingNamesParts.groups.game] = "b", [settingNamesParts.groups.nightVision] = "c", [settingNamesParts.groups.spacePlatforms] = "d"}
	local targetLetters = {[settingNamesParts.targets.day] = "a", [settingNamesParts.targets.sunset] = "b", [settingNamesParts.targets.night] = "c", [settingNamesParts.targets.sunrise] = "d", [settingNamesParts.targets.nightVision] = "e", [settingNamesParts.targets.spacePlatforms] = "f"}
	local optionLetters = {[settingNamesParts.options.colors] = "a", [settingNamesParts.options.percent] = "b"}
	return makeOtherOrderPart(groupName, groupLetters) .. "-" .. makeOtherOrderPart(optionName, optionLetters) .. "-" .. makeOtherOrderPart(targetName, targetLetters)
end

-- Planets settings

local planetOrderMain = "a"
local currentPlanetOrder = "a"

for _, knownPlanet in pairs(knownPlanets) do
	data:extend({
		{
			type = "string-setting",
			default_value = knownPlanet.defaultColors,
			allowed_values = colorChangeSettingNames,
			name = makeColorSettingId(knownPlanet.name),
			order = planetOrderMain .. currentPlanetOrder .. "a" .. "-[" .. knownPlanet.name .. "-color]",
			setting_type = "startup",
			localised_name = {
				localeSettingNamePrefix .. "planet_color",
				knownPlanet.name:sub(1, 1):upper() .. knownPlanet.name:sub(2),
			},
			localised_description = {
				localeSettingDescriptionPrefix .. "planet_color",
				knownPlanet.name:sub(1, 1):upper() .. knownPlanet.name:sub(2),
			},
		}
	})
	data:extend({
		{
			type = "string-setting",
			default_value = knownPlanet.defaultTimes,
			allowed_values = timeChangeSettingNames,
			name = makeTimeSettingId(knownPlanet.name),
			order = planetOrderMain .. currentPlanetOrder .. "b" .. "-[" .. knownPlanet.name .. "-time]",
			setting_type = "startup",
			localised_name = {
				localeSettingNamePrefix .. "planet_time",
				knownPlanet.name:sub(1, 1):upper() .. knownPlanet.name:sub(2),
			},
			localised_description = {
				localeSettingDescriptionPrefix .. "planet_time",
				knownPlanet.name:sub(1, 1):upper() .. knownPlanet.name:sub(2),
			},
		}
	})
	currentPlanetOrder = string.char(currentPlanetOrder:byte() + 1)
end

data:extend({
	{
		type = "string-setting",
		default_value = "vanilla_night",
		allowed_values = colorChangeSettingNamesForUnknown,
		name = makeColorSettingId(nil),
		order = planetOrderMain .. currentPlanetOrder .. "a" .. "-[unknown-planet-color]",
		hidden = not mods["space-age"],
		setting_type = "startup",
		localised_name = {
			localeSettingNamePrefix .. "unknown_planet_color",
		},
		localised_description = {
			localeSettingDescriptionPrefix .. "unknown_planet_color",
		},
	}
})
data:extend({
	{
		type = "string-setting",
		default_value = "literal",
		allowed_values = timeChangeSettingNamesForUnknown,
		name = makeTimeSettingId(nil),
		order = planetOrderMain .. currentPlanetOrder .. "b" .. "-[unknown-planet-time]",
		hidden = not mods["space-age"],
		setting_type = "startup",
		localised_name = {
			localeSettingNamePrefix .. "unknown_planet_time",
		},
		localised_description = {
			localeSettingDescriptionPrefix .. "unknown_planet_time",
			{localeSettingNamePrefix .. "unknown_planet_color"},
			{localeSettingValueNamePrefix .. settingNamePrefix .. "unknown_planet_color-planet_none"},
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
	{groupName = settingNamesParts.groups.game,           default = "identity",             vanilla = "identity",            targetName = settingNamesParts.targets.day},
	{groupName = settingNamesParts.groups.game,           default = "mod_imprDarkNight",    vanilla = "vanilla_night",       targetName = settingNamesParts.targets.night},
	{groupName = settingNamesParts.groups.nightVision,    default = "mod_greenNightVision", vanilla = "vanilla_nightVision", targetName = settingNamesParts.targets.nightVision},
	{groupName = settingNamesParts.groups.spacePlatforms, default = "vanilla_day",          vanilla = "identity",            targetName = settingNamesParts.targets.spacePlatforms},
}

for _, setting in ipairs(colorSettings) do
	optionName = settingNamesParts.options.colors
	data:extend({
		{
			type = "string-setting",
			default_value = setting.default,
			allowed_values = allowedColorValues,
			name = makeOtherSettingId(setting.groupName, setting.targetName, optionName),
			order = makeOtherOrder(setting.groupName, setting.targetName, optionName),
			hidden = setting.groupName == settingNamesParts.groups.spacePlatforms and not mods["space-age"],
			setting_type = "startup",
			localised_name = {
				localeNamePrefix .. makeOtherSettingId(setting.groupName, "", optionName),
				{localeSettingNamePrefix .. setting.targetName},
			},
			localised_description = {
				localeDescriptionPrefix .. makeOtherSettingId(setting.groupName, "", optionName),
				{localeSettingDescriptionPrefix .. setting.targetName},
				{localeSettingValueNamePrefix .. makeOtherSettingId(setting.groupName, setting.targetName, optionName) .. "-" .. setting.default},
				{localeSettingValueNamePrefix .. makeOtherSettingId(setting.groupName, setting.targetName, optionName) .. "-" .. setting.vanilla},
				setting.targetName == settingNamesParts.targets.day and {localeDescriptionPrefix .. makeOtherSettingId("darkDayWarning")} or "",
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
			name = makeOtherSettingId(setting.groupName, setting.targetName, optionName),
			order = makeOtherOrder(setting.groupName, setting.targetName, optionName),
			setting_type = "startup",
			localised_name = {
				localeNamePrefix .. makeOtherSettingId(setting.groupName, "", optionName),
				{localeSettingNamePrefix .. setting.targetName},
			},
			localised_description = {
				localeDescriptionPrefix .. makeOtherSettingId(setting.groupName, "", optionName),
				{localeSettingDescriptionPrefix .. setting.targetName},
				tostring(setting.default), tostring(setting.vanilla),
				{localeSettingNamePrefix .. settingNamesParts.targets.night},
				{localeSettingNamePrefix .. settingNamesParts.targets.sunset},
				{localeSettingNamePrefix .. settingNamesParts.targets.sunrise},
			},
		}
	})
end
