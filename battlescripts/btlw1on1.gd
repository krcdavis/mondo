extends "res://battlescripts/battle_controller.gd"
#basis > utils > controller > here

var wmon
var wtemp = ["cone",10]#placeholder default wild mon

# Called when the node enters the scene tree for the first time.
func _ready():
	$battlehud/optcontrol.btlhead = self
	$battlehud/movecontrol.btlhead = self
	$battlehud/partycontrol.btlhead = self
	btlhead = self#lol
	
	textbox = $battlehud/textbox
	$battlehud/textbox.visible = false#why...
	$battlehud.visible = false
	
	#do this in a loop?
	slots.append( battlecomp.new() )
	slots.append( battlecomp.new() )
	#labels, points
	points = [$point0,$point1]
	labels = [$label0,$label1]
	for l in labels: l.visible = false
	
	engine = d.b_engine.new()
	engine.setup(self)
	
	#print(get_parent().name) if this == root and not head, do a newbattle
	
	#
	#newbattle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func restate(newstate):
	match newstate:
		OPTIONS:
			$battlehud/optcontrol.visible = true
			$battlehud/movecontrol.visible = false
			$battlehud/partycontrol.visible = false
			activemenu = $battlehud/optcontrol
			$battlehud/optcontrol.update_cursor()
			$battlehud/textbox.textplay("What do?",true)
			mode = OPTIONS
		MOVES:
			$battlehud/optcontrol.visible = false
			$battlehud/movecontrol.visible = true
			activemenu = $battlehud/movecontrol
			$battlehud/movecontrol.mupdate(0)
			$battlehud/movecontrol.update_cursor()
			mode = MOVES
		PARTYM:
			$battlehud/optcontrol.visible = false
			$battlehud/movecontrol.visible = false
			$battlehud/partycontrol.visible = true
			activemenu = $battlehud/partycontrol
			$battlehud/partycontrol.pupdate(false)
			mode = PARTYM
			#print("par")
		PARTYMF:
			#used for when you mon faints, or other forced switch like using U-turn
			$battlehud/optcontrol.visible = false
			$battlehud/movecontrol.visible = false
			$battlehud/partycontrol.visible = true
			activemenu = $battlehud/partycontrol
			$battlehud/partycontrol.pupdate(true)
			mode = PARTYM#that's actually fine
		
		
		
		
		INTURN:
			mode = INTURN
			$battlehud/optcontrol.visible = false
			$battlehud/movecontrol.visible = false
			$battlehud/partycontrol.visible = false
			#and then do the thing
		
		

func newbattle():
	#uses some value set somewhere prior to calling, by head,
	#since head has access to the wild encounter tables
	#this set value is cleared/nulled on battle end...
	#if value is null on starting, a default placeholder is loaded instead.
	
	self.visible=true
	$battlehud.visible = true
	returncam = get_viewport().get_camera_3d()
	$Camera3D.make_current()
	head.mode = "battle"
	mode = "startup"
	restate("start")#hides menus and labels
	
	var n = 0
	for mon in party.party:
		mon.temp = n
		n += 1
	
	var p = check_party()
	if not p:#you've somehow entered battle without any good mons. die
		pass
	#else:
	hidelabels()
	load_wild(1)#uses wtemp
	await self.thingdone
	#hrrm
	load_yourside(0, p)
	await self.thingdone
	
	turnhead()

func turnhead():
	#check if your on-field mons are dead. if so, check party
	#if party dead, wipeout
	#party is also checked in newbattle so this is done twice... oh well
	#else, if wild opponents all dead, win
	
	if not check_mon( slots[0].mon ):
		if check_party():#force switch
			restate(PARTYMF)
			#actually this is quite different... complete switch without completing a turn
			#just use info set in slot[0]'s movenext...
			await $battlehud/partycontrol.faint_switch_done
			swap_mon(0, party.party[ slots[0].movenext_target ] )
			await self.thingdone
			showlabels()
			restate(OPTIONS)
		else:
			wipeout()
			await self.thingdone
	
	else: if not check_mon( slots[1].mon ):#wild fainted
		win()
		#win!
	
	#else, begin turn.
	else:
		showlabels()
		restate(OPTIONS)
	

func deactivate():#called on startup to hide field
	self.visible = false
	$battlehud.visible = false
	$battlehud/optcontrol.visible = false
	#$battlefield_placeholder.visible = false
	hidelabels()
	mode = "stopped"


func load_wild(slot):
	wmon = Monster.new()
	wmon.setup_species_level(wtemp[0],wtemp[1])
	
	slots[slot].mon = wmon
	slots[slot].load_into_battle()
	
	loadmon_model(slot)
	
	#next: sequence, labels, debug stuff
	#also next: make this a function
	labels[slot].settext(slots[slot].mon.nname)
	labels[slot].sethp(slots[slot].mon.hp,slots[slot].mon.health)
	labels[slot].setlv(slots[slot].mon.level)
	
	$battlehud/textbox.textplay("aaaaa!!")
	await $battlehud/textbox.textover
	
	
	#await create_tween().tween_interval(.0002).finished#lol
	emit_signal("thingdone")

func load_yourside(slot, mon):
	slots[slot].mon = mon
	slots[slot].load_into_battle()
	
	loadmon_model(slot)
	
	
	labels[slot].settext(slots[slot].mon.nname)
	labels[slot].sethp(slots[slot].mon.hp,slots[slot].mon.health)
	labels[slot].setlv(slots[slot].mon.level)
	
	$battlehud/textbox.textplay("go!!")
	await $battlehud/textbox.textover
	
	#await create_tween().tween_interval(.0002).finished#lol
	emit_signal("thingdone")


func exec_turn():
	restate(INTURN)#this hides the menus
	
	slots[1].set_movenext("red1",0,0)#temp "ai"
	#engine.set_ai(1)
	
	for s in speedqueues: s.clear()
	specialqueue.clear()
	
	for moncomp in slots:
		if moncomp.mon:#not null
			var pp = d.moves.move_getprio(moncomp.movenext_id)
			#sure hope the values are correct
			if pp == SQsp:# ok
				specialqueue.append(moncomp)
			else:
				speedqueues[pp].append(moncomp)
	
	for s in speedqueues:
		if s.size() > 1:#is this necessary? idk
			s.sort_custom(speedTie)
	
	for moncomp in specialqueue:
		match moncomp.movenext_id:
			"run":
				try_running()
				#if successful quit turn execution... return i guess
				await self.thingdone
				return
			"switch":
				swap_mon(0, party.party[moncomp.movenext_target] )
				await self.thingdone
	
	for s in speedqueues:
		for moncomp in s:
			#if mon still alive pls
			#calcdmg takes attacker mon object and target slot, lol
			if moncomp.get_health() > 0:#and some other checks
				
				engine.doamove(moncomp)
				await engine.movedone
				#check_faints()
				
				
	
	#once all done, try another turn
	turnhead()

#checks field for fainted mons, determines next actions.
#currently handled in turnhead
func check_faints():
	pass
