extends "res://battlescripts/battle_controller.gd"

var wmon1
var wmon2

#for now, hardcode your slots vs opponents...
#treat as an extension of w1v1 and just add slot 2
const yours = [0,2]
var ycursor = 0#tracks mon currently having action picked.
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

