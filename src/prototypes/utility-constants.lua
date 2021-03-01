require("commons")

local function colorSetting2lut(colorSetting)
	for _, setting in pairs(colorSettingValues) do
		if setting.id == colorSetting then
			return setting.lut
		end
	end
end

local function stringifyColorLookup(colorLookup)
	local result = "{\n"
	for _, value in ipairs(colorLookup) do
		result = result .. "\t{" .. value[1] .. ", \"" .. value[2] .. "\"}\n"
	end
	result = result .. "}"
	return result
end

local function wrapColorLookupTimestamps(colorLookup)
	local result = {}
	for _, value in ipairs(colorLookup) do
		local timestamp = value[1]
		while timestamp >= 1000000 do
			timestamp = timestamp - 1000000
		end
		while timestamp < 0 do
			timestamp = timestamp + 1000000
		end
		table.insert(result, {timestamp, value[2]})
	end
	return result
end

local function sortColorLookup(colorLookup)
	local keys = {}
	for _, value in ipairs(colorLookup) do
		table.insert(keys, value[1])
	end
	table.sort(keys)
	local result = {}
	for _, key in ipairs(keys) do
		for i, value in ipairs(colorLookup) do
			if key == value[1] then
				table.insert(result, value)
				table.remove(colorLookup, i)
				break
			end
		end
	end
	return result
end

local function deduplicateColorLookup(colorLookup)
	local result = {}
	for _, value in ipairs(colorLookup) do
		if #result == 0 or result[#result][1] ~= value[1] then
			table.insert(result, value)
		end
	end
	return result
end

local function rescaleColorLookup(colorLookup)
	local result = {}
	for _, value in ipairs(colorLookup) do
		table.insert(result, {value[1] / 1000000, value[2]})
	end
	return result
end

local function normalizeColorLookup(colorLookup)
	colorLookup = wrapColorLookupTimestamps(colorLookup)
	colorLookup = sortColorLookup(colorLookup)
	colorLookup = deduplicateColorLookup(colorLookup)
	colorLookup = rescaleColorLookup(colorLookup)
	return colorLookup
end

local function createColorLookup(sunsetDuration, nightDuration, sunriseDuration, dayLut, sunsetLut, nightLut, sunriseLut)
	if sunsetDuration == 0 and sunriseDuration == 0 and (nightDuration == 0 or nightDuration == 1000000) then
		if nightDuration == 0 then
			return {{0, dayLut}}
		else
			return {{0, nightLut}}
		end
	else
		if sunsetDuration < 1 then
			sunsetDuration = 2
		end
		if sunriseDuration < 1 then
			sunriseDuration = 2
		end
		if sunsetDuration + nightDuration + sunriseDuration > 1000000 then
			nightDuration = 1000000 - sunsetDuration - sunriseDuration
		end
		local dayDuration = 1000000 - sunsetDuration - nightDuration - sunriseDuration
		
		local nightStart = 500000 - math.floor(nightDuration / 2)
		local nightEnd = 500000 + math.floor((nightDuration+1) / 2)
		local dayStart = nightEnd + sunriseDuration
		local dayEnd = nightStart - sunsetDuration

		local colorLookup = {}
		table.insert(colorLookup, {dayEnd, dayLut})
		if sunsetLut ~= nil then
			table.insert(colorLookup, {dayEnd + sunsetDuration/2, sunsetLut})
		end
		table.insert(colorLookup, {nightStart, nightLut})
		table.insert(colorLookup, {nightEnd, nightLut})
		if sunriseLut ~= nil then
			table.insert(colorLookup, {nightEnd + sunriseDuration/2, sunriseLut})
		end
		table.insert(colorLookup, {dayStart, dayLut})
		
		return normalizeColorLookup(colorLookup)
	end
end

local defaultConstants = data.raw["utility-constants"]["default"]

local function customizeColorLookup(colorLookupName, groupName)
	--todo colors is sunset sunrise
	local dayColorSetting =     settings.startup[makeSettingName(groupName, settingNames.targets.day,     settingNames.options.colors)].value
	local sunsetColorSetting =  settings.startup[makeSettingName(groupName, settingNames.targets.sunset,  settingNames.options.colors)].value
	local nightColorSetting =   settings.startup[makeSettingName(groupName, settingNames.targets.night,   settingNames.options.colors)].value
	local sunriseColorSetting = settings.startup[makeSettingName(groupName, settingNames.targets.sunrise, settingNames.options.colors)].value
	local dayLut =     colorSetting2lut(dayColorSetting)
	local sunsetLut =  colorSetting2lut(sunsetColorSetting)
	local nightLut =   colorSetting2lut(nightColorSetting)
	local sunriseLut = colorSetting2lut(sunriseColorSetting)

	local sunsetDuration =  math.floor(settings.startup[makeSettingName(groupName, settingNames.targets.sunset,  settingNames.options.duration)].value * 10000)
	local nightDuration =   math.floor(settings.startup[makeSettingName(groupName, settingNames.targets.night,   settingNames.options.duration)].value * 10000)
	local sunriseDuration = math.floor(settings.startup[makeSettingName(groupName, settingNames.targets.sunrise, settingNames.options.duration)].value * 10000)
	
	local colorLookup
	if sunsetDuration + nightDuration + sunriseDuration > 1000000 then
		-- Disco mode
		colorLookup = {}
		for i = 0, 49 do
			table.insert(colorLookup, {0.02 * i, dayLut})
			table.insert(colorLookup, {0.02 * i + 0.01, nightLut})
		end
	else
		colorLookup = createColorLookup(sunsetDuration, nightDuration, sunriseDuration, dayLut, sunsetLut, nightLut, sunriseLut)
	end
	
	log(colorLookupName .. "\n" .. stringifyColorLookup(colorLookup))
	defaultConstants[colorLookupName] = colorLookup
end

customizeColorLookup("daytime_color_lookup",               settingNames.groups.game)
customizeColorLookup("zoom_to_world_daytime_color_lookup", settingNames.groups.map)
