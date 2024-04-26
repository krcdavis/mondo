extends "res://battlescripts/battle_controller.gd"

var wmon1
var wmon2

#for now, hardcode your slots vs opponents...
#treat as an extension of w1v1 and just add slot 2
const yours = [0,2]
var ycursor = 0#tracks mon currently having action picked.
const ysize = 2
const wild = [1]

# Called when the node enters the scene tree for the first time.
func _ready():
	#consider moving this to some reusable function somewhere
	$battlehud/optcontrol.btlhead = self
	$battlehud/movecontrol.btlhead = self
	$battlehud/partycontrol.btlhead = self
	btlhead = self#lol
	
	textbox = $battlehud/textbox
	$battlehud/textbox.visible = false#why...
	$battlehud.visible = false
	
	#slots, points. labels 0-2
	slots.append( battlecomp.new() )
	slots.append( battlecomp.new() )
	slots.append( battlecomp.new() )
	#labels, points
	points = [$point0,$point1,$point2]
	labels = [$label0,$label1,$label2]
	for l in labels: l.visible = false
	
	engine = d.b_engine.new()
	engine.setup(self)
	
	

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
		NEXTOREXEC:
			pass
			#a user-controlled mon has recieved its instructions (move, switch, item).
			#if more mons are awaiting user input, move to the next of them.
			#ie increment ycursor and compare to ysize. if ==, exec, else...
			#set something to affect move/party control...
			ycursor +=1
			if ycursor == ysize:
				exec_turn()
			else:
				pass
				restate(OPTIONS)#?
		#additionally, run is replaced by back, and selecting back decs ycursor
		
		
		



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
