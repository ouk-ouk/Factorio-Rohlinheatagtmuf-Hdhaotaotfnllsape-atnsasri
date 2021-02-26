require("commons")

data:extend({
	-- DURATION
	-- game
	{
		type = "double-setting",
		default_value = 15.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
		name = sunsetDurationSettingName,
		setting_type = "startup",
		order = "a[duration]-a[game]-a[sunset]"
	},
	{
		type = "double-setting",
		default_value = 30.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
		name = nightDurationSettingName,
		setting_type = "startup",
		order = "a[duration]-a[game]-b[night]"
	},
	{
		type = "double-setting",
		default_value = 15.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
		name = sunriseDurationSettingName,
		setting_type = "startup",
		order = "a[duration]-a[game]-c[sunrise]"
	},
	-- map
	{
		type = "double-setting",
		default_value = 15.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
		name = mapSunsetDurationSettingName,
		setting_type = "startup",
		order = "a[duration]-b[map]-a[sunset]"
	},
	{
		type = "double-setting",
		default_value = 30.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
		name = mapNightDurationSettingName,
		setting_type = "startup",
		order = "a[duration]-b[map]-b[night]"
	},
	{
		type = "double-setting",
		default_value = 15.0,
		minimum_value = 0.0,
		maximum_value = 100.0,
		name = mapSunriseDurationSettingName,
		setting_type = "startup",
		order = "a[duration]-b[map]-c[sunrise]"
	}
})
