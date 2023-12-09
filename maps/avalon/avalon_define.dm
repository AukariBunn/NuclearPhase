/datum/map/avalon
	name = "Serenity"
	full_name = "'Serenity' Emergency Shelter"
	path = "avalon"
	flags = MAP_HAS_BRANCH|MAP_HAS_RANK

	system_name = "Sirius"
	station_name = "Serenity"
	station_short = "Serenity"
	boss_name = "Autonomous System"
	boss_short = "AS'"
	company_name = "United Nations"
	company_short = "UN's"
	system_name = "Sirius"
	game_year = 184

	base_floor_type = /turf/exterior/wall/ice

	exterior_atmos_temp = 14
	exterior_atmos_composition = list(
		/decl/material/gas/hydrogen = 200,
		/decl/material/gas/helium = 700,
		/decl/material/gas/carbon_dioxide = 400,
		/decl/material/gas/carbon_monoxide = 100,
		/decl/material/gas/nitrogen = 150
	)
	lightlevel = 1
	weather_system = /decl/state/weather/snow/heavy
	water_material = /decl/material/gas/helium
	ice_material = /decl/material/solid/ice/hydrogen
	planetary_area = /area/surface

	lobby_screens = list(
		'maps/avalon/planet.png'
	)
	credit_sound = list('sound/music/aftermath.ogg')
	reboot_sound = list()

	lobby_tracks = list(
		/decl/music_track/onewaytolife,
		/decl/music_track/runningaftermyfate,
		/decl/music_track/inthedark
	)

	allowed_spawns = list(
		/decl/spawnpoint/arrivals
	)

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

/datum/map/avalon/get_map_info()
	return "You were a citizen of a nearby city - New Tokyo, in the star system Sirius. Something horrible happened more than a year ago; a sudden climate-induced cataclysm that brought hell upon this newly formed colony. The planet's surface quickly became uninhabitable, forcing the planetary government to make a last-ditch attempt to save the remaining population. In addition to already existing military doomsday shelters, several facilities were hastily retrofitted. One of these shelters, 'Serenity', is where you are currently located. Whether by luck, effort or sheer circumstance, you are among the last people alive on this barren planet. Survive.\n \n \
	Вы были жителем соседнего города - Нью-Токио, расположенного в звездной системе Сириус. Более года назад произошло нечто ужасное: внезапный климатический катаклизм обрушил ад на недавно образованную колонию. Поверхность планеты быстро стала непригодной для жизни, что вынудило планетарное правительство предпринять последнюю попытку спасти оставшееся население. В дополнение к уже существующим военным убежищам судного дня было спешно переоборудовано несколько объектов. В одном из таких убежищ, 'Serenity', вы сейчас находитесь. Благодаря удаче, усилиям или просто обстоятельствам вы оказались в числе последних живых людей на этой бесплодной планете."
