extends "res://battlescripts/battle_controller.gd"

#all repeated code...
var wmon
var wtemp = ["cone",10]#placeholder default wild mon


var menus = {}

func setup(hed):
	$battlehud/optcontrol.btlhead = hed
	$battlehud/movecontrol.btlhead = hed
	$battlehud/partycontrol.btlhead = hed
	btlhead = hed#lol
	
	menus[OPTIONS] = $battlehud/optcontrol
	menus[MOVES] = $battlehud/movecontrol
	menus[PARTYM] = $battlehud/partycontrol
	
	textbox = $battlehud/textbox
	#$battlehud/textbox.visible = false#why...
	$battlehud.visible = false

	#slots ofc differ; engine might differ by battle type as well

#here for now
#move to ready
#mf too?


#next: same-ify update functions if possible...
#later these will need to be redone to allow for a little animation, not just hide/show
func restate(newstate):
	match newstate:
		OPTIONS, MOVES, PARTYM:
			activemenu = menus[newstate]
			for key in menus:
				menus[key].visible = key == newstate
			mode = newstate
			#if moves/party, update w/ current yours cursor
			match newstate:#lol
				MOVES:
					menus[MOVES].mupdate(current_cursor)#this but correct
				PARTYM:
					menus[PARTYM].pupdate(false)
			activemenu.update_cursor()
		PARTYMF:
			#used for when you mon faints, or other forced switch like using U-turn,
			#opponent using whirlwind
			activemenu = menus[PARTYM]
			for key in menus:
				menus[key].visible = key == PARTYM
			menus[PARTYM].pupdate(true)
			mode = PARTYM
		#options "what will __ do?" message moved elsewhere- update ycursor

		#to be removed
		NEXTOREXEC:
			#a user-controlled mon has recieved its instructions (move, switch, item).
			#if more mons are awaiting user input, move to the next of them.
			#also, a cursor on the mon having its action selected...
			btlhead.ycursor += 1
			if btlhead.ycursor == btlhead.ysize:
				exec_turn()
			else:
				current_cursor = btlhead.yours[btlhead.ycursor]
				print(current_cursor)
				restate(OPTIONS)
		
		
		#yes this is still used, by exec_turn
		INTURN:
			mode = INTURN
			for key in menus:
				menus[key].visible = false

func update_ycursor():
	pass

func nextorexec():
			#a user-controlled mon has recieved its instructions (move, switch, item).
			#if more mons are awaiting user input, move to the next of them.
			#also, a cursor on the mon having its action selected...
			#start by de-cursoring the current cursor mon
			# label.highlight(false)
			btlhead.ycursor += 1
			if btlhead.ycursor == btlhead.ysize:
				exec_turn()
			else:
				current_cursor = btlhead.yours[btlhead.ycursor]
				print(current_cursor)
				restate(OPTIONS)


#exec-turn is actually the same (:
func exec_turn():
	restate(INTURN)#this hides the menus
	
	slots[1].set_movenext("red1",0,0)#temp "ai"
	engine.set_AI(1)
	
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
	#turnhead()


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


















# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
