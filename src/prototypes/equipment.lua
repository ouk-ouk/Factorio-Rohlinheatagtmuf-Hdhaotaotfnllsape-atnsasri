require("commons")

-- Night vision
local nightVisionEquipment = data.raw["night-vision-equipment"]["night-vision-equipment"]

local nightVisionColorSetting = settings.startup[makeSettingName(settingNames.groups.nightVision, settingNames.targets.nightVision, settingNames.options.colors)].value
local nightVisionLut = colorSetting2lut(nightVisionColorSetting)

local nightVisionTreshold = settings.startup[makeSettingName(settingNames.groups.nightVision, settingNames.targets.nightVision, settingNames.options.percent)].value / 100

nightVisionEquipment.darkness_to_turn_on = 1 - nightVisionTreshold
nightVisionEquipment.color_lookup = {{0.5, nightVisionLut}}
