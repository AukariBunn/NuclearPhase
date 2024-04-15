/mob/living/carbon/human
	var/bpm = 60
	var/metabolic_coefficient = 1 //TODO: CALCULATE THIS
	var/syspressure = 120
	var/dyspressure = 80
	var/meanpressure = 100
	var/mcv = NORMAL_MCV //Minute Circulation Volume
	var/tpvr = 279 //Total Peripherial Vascular Resistance
	var/max_oxygen_capacity = 1450
	var/normal_oxygen_capacity = 1040
	var/oxygen_amount = 120
	var/add_mcv = 0

/mob/living/carbon/human/proc/get_blood_volume_hemo()
	. = vessel.total_volume / species.blood_volume

/mob/living/carbon/human/proc/get_cardiac_output()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	. = heart?.cardiac_output

/mob/living/carbon/human/proc/get_blood_saturation()
	if(stat == DEAD)
		return 0
	if(status_flags & GODMODE)
		return 1
	. = oxygen_amount / normal_oxygen_capacity

#define MCV_COEF(mcv, metabolic_coefficient) mcv / NORMAL_MCV * metabolic_coefficient

/mob/living/carbon/human/proc/get_blood_perfusion()
	if(stat == DEAD)
		return 0

	. = CLAMP01(MCV_COEF(mcv, metabolic_coefficient) * oxygen_amount/1200 * meanpressure / NORMAL_MEAN_PRESSURE)

#undef MCV_COEF
#define VENOUS_RETURN_COEF(dyspressure) min(1.7, dyspressure / 80)
#define AFTERLOAD_COEF(syspressure) max(0.6, syspressure / 120)

/mob/living/carbon/human/proc/get_stroke_volume()
	//blood volume, preload, afterload, cardiac contractility
	var/stroke_volume_coeff = get_blood_volume_hemo() * VENOUS_RETURN_COEF(dyspressure) * AFTERLOAD_COEF(syspressure) * get_cardiac_output()
	return NORMAL_STROKE_VOLUME * stroke_volume_coeff

#undef VENOUS_RETURN_COEF
#undef AFTERLOAD_COEF

/mob/living/carbon/human/proc/update_oxygen_capacities()
	normal_oxygen_capacity = round(vessel.total_volume * 0.2) + get_skill_value(SKILL_FITNESS) * 130 //1 liter of blood can contain 200ml of oxygen + spleen storage
	max_oxygen_capacity = normal_oxygen_capacity * 1.1
	oxygen_amount = Clamp(oxygen_amount, 0, max_oxygen_capacity)

#define PULSE_PRESSURE(stroke_volume) stroke_volume * 0.5714
#define MCV_PRESSURE(add_mcv) add_mcv * 0.013

/mob/living/carbon/human/proc/process_hemodynamics()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(heart)
		if(BP_IS_PROSTHETIC(heart))
			bpm = 60
		else
			bpm = heart.pulse + heart.external_pump
	else
		bpm = 0

	var/ccp = 0 //cardiac cycle period
	if(bpm > 0)
		ccp = 60/bpm

	var/perfusion = get_blood_perfusion()
	tpvr = metabolic_coefficient * 312.50746 //base
	tpvr += syspressure * (0.0008 * syspressure - 0.8833) //this simulates vascular elasticity. More pressure - less TPVR, and side versa
	tpvr += LAZYACCESS0(chem_effects, CE_PRESSURE) //medication effects
	tpvr -= getToxLoss() * 0.203 //toxicity dilates vessels
	tpvr *= perfusion //vasoconstriction depends on muscles, muscles need oxygen
	tpvr = Clamp(tpvr, TPVR_MIN, TPVR_MAX) //static friction and elasticity flatline

	var/bpmd = ccp * 0.109 + 0.159
	var/coeff = get_blood_volume_hemo() * (bpmd * 3.73134328) * get_cardiac_output()
	var/bpm53 = bpm * coeff * 53.0
	var/stroke_volume = get_stroke_volume()
	dyspressure = max(0, Interpolate(dyspressure, (tpvr * (2180 + bpm53))/(metabolic_coefficient * (17820 - bpm53))*get_blood_volume_hemo(), HEMODYNAMICS_INTERPOLATE_FACTOR))
	syspressure = Clamp(Interpolate(syspressure, dyspressure + PULSE_PRESSURE(stroke_volume) + MCV_PRESSURE(add_mcv), HEMODYNAMICS_INTERPOLATE_FACTOR), 0, 413)
	dyspressure = min(dyspressure, max(10, syspressure)-7)
	meanpressure = dyspressure + (syspressure - dyspressure) * 0.33

	mcv = Clamp(((bpm * stroke_volume) + (add_mcv * get_blood_volume_hemo())), 0, 32000)
	add_mcv = 0

#undef PULSE_PRESSURE
#undef MCV_PRESSURE

/mob/living/carbon/human/proc/consume_oxygen(amount)
	var/available_oxygen = oxygen_amount * get_blood_perfusion()
	if(available_oxygen > amount * OXYGEN_DELTA_DIVISOR)
		oxygen_amount -= amount
		return 1
	return 0

/mob/living/carbon/human/proc/add_oxygen(amount)
	oxygen_amount = Clamp(oxygen_amount + amount, 0, max_oxygen_capacity)
	if(oxygen_amount < normal_oxygen_capacity - 10)
		return 0
	return 1

/mob/living/carbon/human/proc/get_blood_pressure_fluffy()
	if(syspressure < 30)
		return "0/0"
	return "[round(syspressure) + rand(-10, 10)]/[round(dyspressure) + rand(-10, 10)]"
