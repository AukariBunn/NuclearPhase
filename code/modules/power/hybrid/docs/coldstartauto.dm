/obj/item/paper/reactor/coldstartauto
	name = "Assisted Cold Start Checklist"
	info = "\
	<center><h3>REACTOR ASSISTED COLD START</h3></center><BR>\
	<center><b>Last revised: (10/01/2206)</b></center><BR>\
	<i>Rewritten to accomodate the newest modifications.</i><BR>\
	<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
	<BR>\
	<BR>\
	<BR>\
	-START PREPARATIONS-<BR>\
	<u>-Report to Planetary Energy Suplemmentation Agency</u><BR>\
	-Conduct a mandatory wellness check on yourself<BR>\
	-File the start attempt in the Reactor Logbook<BR>\
	-Lock all doors and ensure lack of tresspassers<BR>\
	<BR>\
	-PRE FEED START-<BR>\
	-T-PRES-CONTROL to 4ATM<BR>\
	TURB V-BYPASS to OPEN<BR>\
	-T-CP 1V-IN to OPEN<BR>\
	-T-CP 2V-IN to OPEN<BR>\
	-T-FEEDWATER-CP MAKEUP to IDLE<BR>\
	WAIT 10s<BR>\
	-T-FEEDWATER V-MAKEUP to OPEN<BR>\
	WAIT 20s<BR>\
	-T-FEEDWATER V-MAKEUP to CLOSED<BR>\
	-T-CP 1 MODE to IDLE<BR>\
	-T-CP 2 MODE to IDLE<BR>\
	WAIT 10S<BR>\
	-T-CP 1V-OUT to OPEN<BR>\
	-T-CP 2V-OUT to OPEN<BR>\
	VERIFY T-FEEDWATER FLOW > 150kgs<BR>\
	<BR>\
	-FEED START-<BR>\
	-F-PREHEAT to START<BR>\
	AFTER F-M CHAMBER TEMP > 3700K<BR>\
	-F-CP 1V-IN to OPEN<BR>\
	-F-CP 2V-IN to OPEN<BR>\
	-F-CP 1 MODE to IDLE<BR>\
	-F-CP 2 MODE to IDLE<BR>\
	AFTER F-CP RPM > 70<BR>\
	-F-CP 1V-OUT to OPEN<BR>\
	-F-CP 2V-OUT to OPEN<BR>\
	-REACTOR-F-V-IN to OPEN<BR>\
	-REACTOR-F-V-OUT to OPEN<BR>\
	VERIFY REACTOR CHAMBER TEMPERATURE RISING<BR>\
	VERIFY F-FLOW > 40kgs<BR>\
	-HEATEXCHANGER V-IN to OPEN<BR>\
	<BR>\
	-TURBINE START-<BR>\
	-CONTROL MODE to SEMI-AUTO\
	<BR>\
	-PRE IGNITION-<BR>\
	-LAS-OMODE to IGNITION<BR>\
	-LAS-NMODE to BOMBARDMENT<BR>\
	VERIFY LASER CAPACITOR CHARGE<BR>\
	<u>REQUEST CLEARANCE FROM FESS</u><BR>\
	<BR>\
	-IGNITION-<BR>\
	-LAS-ARM to ARMED<BR>\
	-REACTOR-PREBURN START<BR>\
	WAIT 13s<BR>\
	-LAS-PRIMER to PRIME<BR>\
	VERIFY FUSION START<BR>\
	<BR>\
	-AFTER IGNITION-<BR>\
	-LAS-OMODE to CONTINUOUS<BR>\
	-LAS-NMODE to MODERATION<BR>\
	-F-PREHEAT to OFF<BR>\
	<BR>\
	-AFTER START-<BR>\
	-Assume normal operation<BR>\
	-Unlock doors<BR>\
	-Check computer systems integrity<BR>"