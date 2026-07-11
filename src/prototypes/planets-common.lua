require("commons")

-- Color lookup utils
function stringifyColorLookup(colorLookup)
	local result = "{\n"
	for _, value in ipairs(colorLookup) do
		result = result .. "\t{" .. value[1] .. ", \"" .. value[2] .. "\"}\n"
	end
	result = result .. "}"
	return result
end

local function getDefaultColorLookup()
	return data.raw["utility-constants"]["default"]["daytime_color_lookup"]
end

local function findBoundaryTimes(colorLookup, knownPlanet)
	local boundaries = {0.0, 0.5, 0.5, 1.0}
	for _, lutInfo in pairs(colorLookup) do
		for _, knownDayLut in pairs(knownPlanet.day) do
			if lutInfo[2] == knownDayLut then
				if lutInfo[1] <= 0.5 and lutInfo[1] > boundaries[1] then
					boundaries[1] = lutInfo[1]
				end
				if lutInfo[1] >= 0.5 and lutInfo[1] < boundaries[4] then
					boundaries[4] = lutInfo[1]
				end
			end
		end
		for _, knownNightLut in pairs(knownPlanet.night) do
			if lutInfo[2] == knownNightLut then
				if lutInfo[1] <= 0.5 and lutInfo[1] < boundaries[2] then
					boundaries[2] = lutInfo[1]
				end
				if lutInfo[1] >= 0.5 and lutInfo[1] > boundaries[3] then
					boundaries[3] = lutInfo[1]
				end
			end
		end
	end
	return boundaries
end

local function modifyTimes(colorLookup, knownPlanet, timeChangeSetting)
	-- Check if time is supposed to be modified
	if timeChangeSetting == "unchanged" then
		return colorLookup
	end

	-- Load time settings
	local sunsetDuration =  settings.startup[makeOtherSettingId(settingNamesParts.groups.game, settingNamesParts.targets.sunset,  settingNamesParts.options.percent)].value / 100.0
	local nightDuration =   settings.startup[makeOtherSettingId(settingNamesParts.groups.game, settingNamesParts.targets.night,   settingNamesParts.options.percent)].value / 100.0
	local sunriseDuration = settings.startup[makeOtherSettingId(settingNamesParts.groups.game, settingNamesParts.targets.sunrise, settingNamesParts.options.percent)].value / 100.0
	-- Check if the times can be applied
	if nightDuration / 2 + sunriseDuration > 0.5 or nightDuration / 2 + sunsetDuration > 0.5 then
		-- Acid trip mode
		local colorLookup = {}
		for i = 0, 50 do
			table.insert(colorLookup, {0.02 * i, "__" .. modName .. "__/graphics/color_luts/acid/acid-lut-" .. (i % 5) .. ".png"})
		end
		return colorLookup
	end

	-- Find current boundary times
	local oldBoundaries = findBoundaryTimes(colorLookup, knownPlanet)

	-- Calculate new boundary times
	local nightDuration1 = nightDuration / 2
	local nightDuration2 = nightDuration / 2
	local newBoundaries
	if timeChangeSetting == "proportional" then
		local oldSunsetDuration = oldBoundaries[2] - oldBoundaries[1]
		local oldNightDuration1 = 0.5 - oldBoundaries[2]
		local oldNightDuration2 = oldBoundaries[3] - 0.5
		local oldSunriseDuration = oldBoundaries[4] - oldBoundaries[3]
		local defaultBoundaries = findBoundaryTimes(getDefaultColorLookup(), knownPlanets[1])
		local defaultSunsetDuration = defaultBoundaries[2] - defaultBoundaries[1]
		local defaultNightDuration1 = 0.5 - defaultBoundaries[2]
		local defaultNightDuration2 = defaultBoundaries[3] - 0.5
		local defaultSunriseDuration = defaultBoundaries[4] - defaultBoundaries[3]
		sunsetDuration = oldSunsetDuration * (sunsetDuration / defaultSunsetDuration)
		nightDuration1 = oldNightDuration1 * (nightDuration1 / defaultNightDuration1)
		nightDuration2 = oldNightDuration2 * (nightDuration2 / defaultNightDuration2)
		sunriseDuration = oldSunriseDuration * (sunriseDuration / defaultSunriseDuration)
		if sunsetDuration + nightDuration1 > 0.5 then
			sunsetDuration = sunsetDuration * (0.5 / (sunsetDuration + nightDuration1))
			nightDuration1 = nightDuration1 * (0.5 / (sunsetDuration + nightDuration1))
		end
		if nightDuration2 + sunriseDuration > 0.5 then
			nightDuration2 = nightDuration2 * (0.5 / (nightDuration2 + sunriseDuration))
			sunriseDuration = sunriseDuration * (0.5 / (nightDuration2 + sunriseDuration))
		end
	end
	local newBoundaries = {
		0.5 - nightDuration1 - sunsetDuration,
		0.5 - nightDuration1,
		0.5 + nightDuration2,
		0.5 + nightDuration2 + sunriseDuration,
	}

	-- Check if new boundaries differ
	if oldBoundaries[1] == newBoundaries[1] and oldBoundaries[2] == newBoundaries[2] and oldBoundaries[3] == newBoundaries[3] and oldBoundaries[4] == newBoundaries[4] then
		return colorLookup
	end

	-- Squash & stretch
	newColorLookup = {}
	for _, oldLutInfo in pairs(colorLookup) do
		for i, oldBoundary in ipairs(oldBoundaries) do
			if oldBoundary == oldLutInfo[1] then
				table.insert(newColorLookup, {newBoundaries[i], oldLutInfo[2]})
				break
			elseif i == 1 and oldBoundary > oldLutInfo[1] then
				table.insert(newColorLookup, {oldLutInfo[1] * (newBoundaries[i] / oldBoundary), oldLutInfo[2]})
				break
			elseif oldBoundary > oldLutInfo[1] then
				table.insert(newColorLookup, {(oldLutInfo[1] - oldBoundaries[i-1]) * ((newBoundaries[i] - newBoundaries[i-1]) / (oldBoundary - oldBoundaries[i-1])) + newBoundaries[i-1], oldLutInfo[2]})
				break
			elseif i == 4 then
				table.insert(newColorLookup, {(oldLutInfo[1] - oldBoundaries[i]) * ((1.0 - newBoundaries[i]) / (1.0 - oldBoundary)) + newBoundaries[i], oldLutInfo[2]})
				break
			end
		end
	end

	-- Success
	return newColorLookup
end

local function modifyColors(colorLookup, knownPlanet, colorChangeSetting)
	-- Check if color is supposed to be modified
	if not colorChangeSetting.changeDay and not colorChangeSetting.changeNight then
		return colorLookup
	end

	-- Load color settings
	local dayLut = colorSettingValues[settings.startup[makeOtherSettingId(settingNamesParts.groups.game, settingNamesParts.targets.day, settingNamesParts.options.colors)].value].lut
	local nightLut = colorSettingValues[settings.startup[makeOtherSettingId(settingNamesParts.groups.game, settingNamesParts.targets.night, settingNamesParts.options.colors)].value].lut

	-- Make LUT table
	local newColorLookup = {}
	for _, lutInfo in pairs(colorLookup) do
		local newLut = lutInfo[2]
		if colorChangeSetting.changeDay then
			for _, knownDayLut in pairs(knownPlanet.day) do
				if lutInfo[2] == knownDayLut then
					newLut = dayLut
				end
			end
		end
		if colorChangeSetting.changeNight then
			for _, knownNightLut in pairs(knownPlanet.night) do
				if lutInfo[2] == knownNightLut then
					newLut = nightLut
				end
			end
		end
		table.insert(newColorLookup, {lutInfo[1], newLut})
	end

	-- Success
	return newColorLookup
end

function modifyLUTsForPlanet(planet, knownPlanet, timeChangeSetting, colorChangeSetting)
	local oldColorLookup
	if planet.surface_render_parameters and planet.surface_render_parameters.day_night_cycle_color_lookup then
		oldColorLookup = planet.surface_render_parameters.day_night_cycle_color_lookup
	else
		oldColorLookup = getDefaultColorLookup()
	end

	local newColorLookup
	if colorChangeSetting.vanillaLuts then
		newColorLookup = getDefaultColorLookup()
		knownPlanet = knownPlanets[1]
	else
		newColorLookup = oldColorLookup
	end

	newColorLookup = modifyTimes(newColorLookup, knownPlanet, timeChangeSetting)

	newColorLookup = modifyColors(newColorLookup, knownPlanet, colorChangeSetting)

	if newColorLookup == oldColorLookup then
		local defaultSpacePlatformsLut = knownPlanets[1].day[1]
		local newSpacePlatformsLut = colorSettingValues[settings.startup[makeOtherSettingId(settingNamesParts.groups.spacePlatforms, settingNamesParts.targets.spacePlatforms, settingNamesParts.options.colors)].value].lut
		if newSpacePlatformsLut ~= defaultSpacePlatformsLut then
			newColorLookup = {}
			for _, lutInfo in pairs(getDefaultColorLookup()) do
				table.insert(newColorLookup, {lutInfo[1], lutInfo[2]})
			end
		end
	end

	if newColorLookup ~= oldColorLookup then
		if not planet.surface_render_parameters then
			planet.surface_render_parameters = {}
		end
		planet.surface_render_parameters.day_night_cycle_color_lookup = newColorLookup
	end
end
