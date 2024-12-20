/decl/material/solid
	name = null
	melting_point = 1000
	boiling_point = 3135
	molar_mass = 0.232 //iron Fe3O4
	latent_heat = 349600 //iron
	door_icon_base = "stone"
	icon_base = 'icons/turf/walls/stone.dmi'
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	default_solid_form = /obj/item/stack/material/brick
	abstract_type = /decl/material/solid
	min_fluid_opacity = 200
	max_fluid_opacity = 255
	gas_tile_overlay = "dust"

/decl/material/solid/Initialize()
	//if(!liquid_name)
	//	liquid_name = "molten [name]"
	//if(!gas_name)
	//	gas_name = "vaporized [name]"
	if(!ore_compresses_to)
		ore_compresses_to = type
	. = ..()