require("commons")

local nightVisionEquipment = data.raw["night-vision-equipment"]["night-vision-equipment"]

local nightVisionColorSetting = settings.startup[makeSettingName(settingNames.groups.nightVision, settingNames.targets.nightVision, settingNames.options.colors)].value
local nightVisionLut = colorSetting2lut(nightVisionColorSetting)

nightVisionEquipment.color_lookup = {{0.5, nightVisionLut}}
