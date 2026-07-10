require("commons")

-- Night vision
local nightVisionEquipment = data.raw["night-vision-equipment"]["night-vision-equipment"]

local nightVisionColorSetting = settings.startup[makeOtherSettingName(settingNamesParts.groups.nightVision, settingNamesParts.targets.nightVision, settingNamesParts.options.colors)].value
local nightVisionLut = colorSetting2lut(nightVisionColorSetting)

local nightVisionTreshold = settings.startup[makeOtherSettingName(settingNamesParts.groups.nightVision, settingNamesParts.targets.nightVision, settingNamesParts.options.percent)].value / 100

nightVisionEquipment.darkness_to_turn_on = 1 - nightVisionTreshold
nightVisionEquipment.color_lookup = {{0.5, nightVisionLut}}
