#define MAX_INTERIOR_HEIGHT 15

/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/tallness = 0
	var/list/mappaths = null
	var/loaded = 0 // Times loaded this round
	var/list/shuttles_to_initialise = list()
	var/list/subtemplates_to_spawn
	var/base_turf_for_zs = null
	var/accessibility_weight = 0
	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES
	var/modify_tag_vars = TRUE // Will modify tag vars so that duplicate templates are handled properly. May have compatibility issues with legacy maps (esp. with ferry shuttles).
	var/list/template_categories // List of strings to store the templates under for mass retrieval.
	var/template_parent_type = /datum/map_template // If this is equal to current type, the datum is abstract and should not be created.
	var/list/pilot_seat_offset = null // offset from left bottow edge to pilot seat

/datum/map_template/New(var/created_ad_hoc)
	if(created_ad_hoc != SSmapping.type)
		PRINT_STACK_TRACE("Ad hoc map template created ([type])!")

/datum/map_template/proc/preload()
	if(length(mappaths))
		preload_size()
	return TRUE

/datum/map_template/proc/get_spawn_weight()
	return 0

/datum/map_template/proc/get_template_cost()
	return 0

/datum/map_template/proc/get_ruin_tags()
	return 0

/datum/map_template/proc/preload_size()
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/z_offset = 1 // needed to calculate z-bounds correctly
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = maploader.load_map(file(mappath), 1, 1, z_offset, cropMap=FALSE, measureOnly=TRUE, no_changeturf=TRUE, clear_contents= template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS)
		if(M)
			bounds = extend_bounds_if_needed(bounds, M.bounds)
			z_offset++
		else
			return FALSE
	width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
	height = bounds[MAP_MAXY] - bounds[MAP_MINX] + 1
	tallness = bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1
	return TRUE

/datum/map_template/proc/init_atoms(var/list/atoms)
	if (SSatoms.atom_init_stage == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/list/turf/turfs = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/machinery/machines = list()
	var/list/obj/structure/cable/cables = list()

	for(var/atom/A in atoms)
		if(isturf(A))
			turfs += A
		if(istype(A, /obj/structure/cable))
			cables += A
		if(istype(A, /obj/machinery/atmospherics))
			atmos_machines += A
		if(istype(A, /obj/machinery))
			machines += A
		if(istype(A, /obj/abstract/landmark/map_load_mark))
			LAZYADD(subtemplates_to_spawn, A)

	var/notsuspended
	if(!SSmachines.suspended)
		SSmachines.suspend()
		notsuspended = TRUE

	SSatoms.InitializeAtoms() // The atoms should have been getting queued there. This flushes the queue.

	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)
	if(notsuspended)
		SSmachines.wake()

	for (var/i in machines)
		var/obj/machinery/machine = i
		machine.power_change()

	for (var/i in turfs)
		var/turf/T = i
		T.post_change()
		if(template_flags & TEMPLATE_FLAG_NO_RUINS)
			T.turf_flags |= TURF_FLAG_NORUINS
		if(template_flags & TEMPLATE_FLAG_NO_RADS)
			qdel(SSradiation.sources_assoc[i])
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

/datum/map_template/proc/pre_init_shuttles()
	. = SSshuttle.block_queue
	SSshuttle.block_queue = TRUE

/datum/map_template/proc/init_shuttles(var/pre_init_state, var/map_hash, var/list/initialized_areas_by_type)
	for (var/shuttle_type in shuttles_to_initialise)
		LAZYSET(SSshuttle.shuttles_to_initialize, shuttle_type, map_hash) // queue up for init.
	if(map_hash)
		SSshuttle.map_hash_to_areas[map_hash] = initialized_areas_by_type
	SSshuttle.block_queue = pre_init_state
	SSshuttle.clear_init_queue() // We will flush the queue unless there were other blockers, in which case they will do it.

/datum/map_template/proc/load_interior_level()
	ASSERT(height < MAX_INTERIOR_HEIGHT)

	var/turf/T
	if(!SSmapping.interior_zlevel)
		T = src.load_new_z(x= 9, y= 9, reinit_lighting=TRUE)
	else
		T = src.load(SSmapping.interior_zlevel)
	var/xmod = 1
	if(T.x+xmod+width > world.maxx-9)
		T = new(locate(9, T.y+1+MAX_INTERIOR_HEIGHT, T.z))
		xmod = 0
	ASSERT(T.y+1+height < world.maxy-9)
	SSmapping.interior_zlevel = new(locate(T.x+xmod, T.y-height, T.z))
	return T

/datum/map_template/proc/load_new_z(no_changeturf = TRUE, var/x=null, var/y=null, var/reinit_lighting=FALSE)

	if(isnull(x))
		x = round((world.maxx - width)/2)
	if(isnull(y))
		y = round((world.maxy - height)/2)
	var/initial_z = world.maxz + 1

	if (x < 1) x = 1
	if (y < 1) y = 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()
	for(var/z_index = bounds[MAP_MINZ] to bounds[MAP_MAXZ])
		var/datum/level_data/level = SSmapping.levels_by_z[z_index]
		level.before_template_load(src)

	var/map_hash = modify_tag_vars && "[sequential_id("map_id")]"
	ASSERT(isnull(global._preloader.current_map_hash)) // Recursive maploading is possible, but not from this block: recursive loads should be triggered in Initialize, from init_atoms below.
	global._preloader.current_map_hash = map_hash

	var/initialized_areas_by_type = list()
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = maploader.load_map(file(mappath), x, y, no_changeturf = no_changeturf, initialized_areas_by_type = initialized_areas_by_type)
		if(M)
			bounds = extend_bounds_if_needed(bounds, M.bounds)
			atoms_to_initialise += M.atoms_to_initialise
		else
			return FALSE

	global._preloader.current_map_hash = null

	for (var/z_index = bounds[MAP_MINZ]; z_index <= bounds[MAP_MAXZ]; z_index++)
		if (accessibility_weight)
			global.using_map.accessible_z_levels[num2text(z_index)] = accessibility_weight
		if (base_turf_for_zs)
			global.using_map.base_turf_by_z[num2text(z_index)] = base_turf_for_zs
		global.using_map.player_levels |= z_index // TODO: make maps handle this with /obj/abstract/level_data

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state, map_hash, initialized_areas_by_type)
	after_load()
	for(var/z_index = bounds[MAP_MINZ] to bounds[MAP_MAXZ])
		var/datum/level_data/level = SSmapping.levels_by_z[z_index]
		level.after_template_load(src)
		if(SSlighting.initialized)
			SSlighting.InitializeZlev(z_index)
	log_game("Z-level [name] loaded at [x],[y],[world.maxz]")
	loaded++

	return locate(x+width, x+height, initial_z)

/datum/map_template/proc/load(turf/T, centered = FALSE, clear_contents = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x + width > world.maxx)
		return
	if(T.y + height > world.maxy)
		return

	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()

	var/map_hash = modify_tag_vars && "[sequential_id("map_id")]"
	ASSERT(isnull(global._preloader.current_map_hash))
	global._preloader.current_map_hash = map_hash

	var/initialized_areas_by_type = list()
	for(var/mappath in mappaths)
		var/datum/map_load_metadata/M = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap = TRUE, clear_contents = clear_contents || template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS, initialized_areas_by_type = initialized_areas_by_type)
		if(M)
			atoms_to_initialise += M.atoms_to_initialise
		else
			return FALSE

	global._preloader.current_map_hash = null

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state, map_hash, initialized_areas_by_type)
	after_load(T.z)
	if(SSlighting.initialized)
		SSlighting.InitializeTurfs(atoms_to_initialise)	// Hopefully no turfs get placed on new coords by SSatoms.

	log_game("[name] loaded at at [T.x], [T.y], [T.z]")
	loaded++

	return locate(T.x + width, T.y + height, T.z)

/datum/map_template/proc/after_load(z)
	for(var/obj/abstract/landmark/map_load_mark/mark as anything in subtemplates_to_spawn)
		subtemplates_to_spawn -= mark
		mark.load_subtemplate()
		if(!QDELETED(mark))
			qdel(mark)
	subtemplates_to_spawn = null

/datum/map_template/proc/extend_bounds_if_needed(var/list/existing_bounds, var/list/new_bounds)
	var/list/bounds_to_combine = existing_bounds.Copy()
	for (var/min_bound in list(MAP_MINX, MAP_MINY, MAP_MINZ))
		bounds_to_combine[min_bound] = min(existing_bounds[min_bound], new_bounds[min_bound])
	for (var/max_bound in list(MAP_MAXX, MAP_MAXY, MAP_MAXZ))
		bounds_to_combine[max_bound] = max(existing_bounds[max_bound], new_bounds[max_bound])
	return bounds_to_combine

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))

/datum/map_template/proc/discover_offset(displacer)
	var/offset = list(0, 0)
	for(var/path in mappaths)
		var/datum/map_load_metadata/M = maploader.load_map(file(path), 1, 1, 1, cropMap = FALSE, measureOnly = FALSE, no_changeturf = TRUE, clear_contents = template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS)
		for(var/atom/A as anything in M.atoms_to_initialise)
			if(istype(A, displacer))
				offset[1] = A.loc.x
				offset[2] = A.loc.y
				break

	return offset

//for your ever biggening badminnery kevinz000
//? - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()
