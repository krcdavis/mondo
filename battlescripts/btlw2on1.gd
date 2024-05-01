extends "res://battlescripts/battle_header.gd"


#for now, hardcode your slots vs opponents...
#treat as an extension of w1v1 and just add slot 2
const yours = [0,2]
var ycursor = 0#tracks mon currently having action picked.
const ysize = 2
const wild = [1]

# Called when the node enters the scene tree for the first time.
func _ready():
	#consider moving this to some reusable function somewhere. setup(self)
	setup(self)
	
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

func newbattle():
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
	var q = check_party(p.temp) #for now...

	
	#else:
	hidelabels()
	load_wild(1)#uses wtemp
	await self.thingdone
	#hrrm
	load_yourside(0, p)
	await self.thingdone
	#the string should change to call out both names
	if q:
		load_yourside(2,q)
		await self.thingdone
	
	turnhead()

func turnhead():
	if false:#lolololol
		pass
	
	else:
		current_cursor = yours[0]#or rather, first still-alive mon
		showlabels()
		$battlehud/textbox.textplay("What do?", true)
		restate(OPTIONS)
