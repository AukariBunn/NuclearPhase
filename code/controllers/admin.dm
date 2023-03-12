// Clickable stat() button.
/atom/movable/statclick
	name = "Initializing..."
	var/target

INITIALIZE_IMMEDIATE(/atom/movable/statclick)

/atom/movable/statclick/Initialize(mapload, text, target) //Don't port this to Initialize it's too critical
	. = ..()
	name = text
	src.target = target

/atom/movable/statclick/debug
	var/class

/atom/movable/statclick/debug/Click()
	if(!check_rights(R_VAREDIT | R_DEBUG) || !target)
		return

	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
		if("Failsafe")
			new /datum/controller/failsafe()

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
