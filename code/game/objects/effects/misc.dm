//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

/obj/effect/stop
	var/victim = null
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."

/obj/effect/invisible_barrier
	density = 1
	anchored = 1
	opacity = 0
	mouse_opacity = 0
	simulated = FALSE
	icon = 'icons/obj/overmap.dmi'
	icon_state = "globe"
	color = "#9c2020"

/obj/effect/invisible_barrier/opaque
	opacity = 1

/obj/effect/invisible_barrier/Initialize()
	. = ..()
	icon_state = ""

//Paints the wall it spawns on, then dies
/obj/effect/paint
	name = "coat of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wall_paint_effect"
	layer = TURF_DETAIL_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/paint/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.paint_color = color
		W.stripe_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.paint_color = color
		WF.stripe_color = color
		WF.update_icon()
	qdel(src)

/obj/effect/paint/pink
	color = COLOR_PINK

/obj/effect/paint/sun
	color = COLOR_SUN

/obj/effect/paint/red
	color = COLOR_RED

/obj/effect/paint/silver
	color = COLOR_SILVER

/obj/effect/paint/black
	color = COLOR_DARK_GRAY

/obj/effect/paint/green
	color = COLOR_GREEN_GRAY

/obj/effect/paint/blue
	color = COLOR_NAVY_BLUE

/obj/effect/paint/brown
	color = COLOR_DARK_BROWN

//Stripes the wall it spawns on, then dies
/obj/effect/paint_stripe
	name = "stripe of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "paintdot"
	layer = BASE_ABOVE_OBJ_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint_stripe/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/paint_stripe/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.stripe_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.stripe_color = color
		WF.update_icon()
	qdel(src)

/obj/effect/paint_stripe/green
	color = COLOR_GREEN_GRAY

/obj/effect/paint_stripe/red
	color = COLOR_RED_GRAY

/obj/effect/paint_stripe/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/paint_stripe/yellow
	color = COLOR_BROWN

/obj/effect/paint_stripe/blue
	color = COLOR_BLUE_GRAY

/obj/effect/paint_stripe/brown
	color = COLOR_DARK_BROWN

/obj/effect/paint_stripe/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/paint_stripe/white
	color = COLOR_SILVER

/obj/effect/paint_stripe/black
	color = COLOR_DARK_GRAY
