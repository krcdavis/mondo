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
		
		