/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'icons/obj/items/storage/firstaid.dmi'
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'
	load_spreading_coefficient = 0.9
	weight = 1.5

/obj/item/storage/firstaid/empty
	icon_state = "firstaid"
	name = "First-Aid (empty)"

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/wound_filler = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/betapace,
		/obj/item/storage/pill_bottle/painkillers,
		/obj/item/storage/pill_bottle/charcoal,
		/obj/item/stack/medical/splint,
		/obj/item/chest_tube,
		/obj/item/clothing/gloves/latex,
		/obj/item/intubation_bag,
		/obj/item/tank/emergency/oxygen/medical
		)

/obj/item/storage/firstaid/handmade
	name = "sketchy first-aid kit"
	icon_state = "firstaid"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 1,
		/obj/item/stack/medical/wound_filler = 1,
		/obj/item/storage/pill_bottle/handmade,
		/obj/item/stack/medical/splint/ghetto
		)

/obj/item/storage/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "It's an emergency medical kit for when people brought ballistic weapons to a laser fight."
	icon_state = "radfirstaid"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/wound_filler = 2,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/storage/pill_bottle/painkillers
		)

/obj/item/storage/firstaid/trauma/Initialize()
	. = ..()
	icon_state = pick("radfirstaid", "radfirstaid2", "radfirstaid3")

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/wound_filler = 1,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/painkillers
		)

/obj/item/storage/firstaid/fire/Initialize()
	. = ..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	startswith = list(
		/obj/item/chems/pill/charcoal = 4
		)

/obj/item/storage/firstaid/toxin/Initialize()
	. = ..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 1,
		/obj/item/storage/pill_bottle/painkillers,
		/obj/item/chest_tube,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/tank/emergency/oxygen
		)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/wound_filler/hydrogel = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/storage/pill_bottle/betapace,
		/obj/item/storage/pill_bottle/painkillers,
		/obj/item/stack/medical/splint
		)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/pill_bottle/antitoxins,
		/obj/item/storage/pill_bottle/painkillers,
		/obj/item/storage/pill_bottle/antibiotics,
		/obj/item/stack/medical/splint,
		)

/obj/item/storage/firstaid/ifak
	name = "IFAK box"
	desc = "Individual First Aid Kit."
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_evil.dmi'
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	startswith = list(
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/splint,
		/obj/item/chest_tube,
		/obj/item/knife/combat,
		/obj/item/clothing/gloves/latex,
		/obj/item/flashlight/flare/glowstick,
		/obj/item/storage/pill_bottle/foil_pack/tramadol,
		/obj/item/storage/pill_bottle/foil_pack/amicile
		)

/obj/item/storage/firstaid/stab
	name = "stabilisation first aid"
	desc = "Stocked with medical pouches."
	icon_state = "stabfirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin,
		/obj/item/storage/med_pouch/radiation,
		)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon = 'icons/obj/items/storage/surgerykit.dmi'
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"

	storage_slots = 14
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = null
	use_sound = 'sound/effects/storage/briefcase.ogg'

	can_hold = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/sutures
	)

	startswith = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/sutures
	)

/obj/item/storage/firstaid/surgery/ghetto // Mostly just for debugging.
	name = "shady surgery kit"
	can_hold = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/hatchet,
		/obj/item/kitchen/utensil/fork,
		/obj/item/shard,
		/obj/item/flame/lighter,
		/obj/item/stack/cable_coil
	)

	startswith = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/hatchet,
		/obj/item/kitchen/utensil/fork,
		/obj/item/shard,
		/obj/item/flame/lighter,
		/obj/item/stack/cable_coil
	)
