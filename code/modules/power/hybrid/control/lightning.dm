/obj/machinery/reactor_button/lighting
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"

/obj/machinery/reactor_button/lighting/do_action()
	. = ..()
	for(var/obj/machinery/light/L in reactor_floodlights)
		if(L.uid == id)
			L.on = !L.on
			L.update_icon()

/obj/machinery/reactor_button/lighting/superstructure
	name = "FL-MAIN"
	id = "superstructure"