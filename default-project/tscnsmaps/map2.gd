extends dscripttags

var head
var actors = {}

#note- when rotating the "rival", rotate the "visual" node; when moving, move the
#whole thing. otherwise, the indicator arrow also rotates
#... add a way to do that to head
#another problem: can't use $Node.position etc in dict because it's not constant.
#could give up on script dic-arrays being const, it doesn't do much good anyway,
#or could just add target points to actor dict and set it up to pull from that.
#ie, send in both actor to pull from and property to pull.
const firstscript = [
	#pan cam over to rival. rival turns to player and "walks" to them w/ cam. then
	{typ: twn, trg: rival, prop:"rotation", end:Vector3(0,deg_to_rad(107-360),0), tme: .4,wait:false},
	{typ: twn, trg: rival, prop:"position", end:Vector3(12.21,0.539,0), tme: .6,wait:true},
	#$rival/Node3D.global_position
	{typ:txt,nme:rival,txt:"Hey, %pn! So you're finally awake, huh?? "},
	#{typ: twn, trg: rival, prop:"rotation", end:Vector3(0,deg_to_rad(107-360),0), tme: .4,wait:true},
	#{typ: twn, trg: rival, prop:"rotation", end:Vector3(0,deg_to_rad(107-360),0), tme: .4,wait:true},
	{typ:txt,nme:rival,txt:"Lol, lmao even "},
	#return cam, return player control
]

# Called when the node enters the scene tree for the first time.
func _ready():
	actors[rival] = $rival
	#if flag, first event...
	#temp
	d.save.firstloadmapflag = true

func loadingritual():
	head.activate_player()
	if d.save.firstloadmapflag:
		d.save.firstloadmapflag = false
		head.scriptplay(firstscript)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_area_3d_body_entered(body):
	if body.name == "you":
		head.changemap(["default-project/tscnsmaps/map1","Node3D"])

var rivalflip = true
const rvsc1 = {typ:txt,nme:rival,txt:"Hey, who're you?? Huh, who am I?? Hah! I'm you, but colorshifted!"}
const rvsc2 = {typ:txt,nme:rival,txt:"What're you still hangin around here for, %pn?? Get out there! Or else you're an even bigger loser than I am!"}
	

func _on_rival_colision_area_entered(area):
	#if interact probe, interact.
	if area.name == "interact":
		print("hi")
		if rivalflip:
			head.onescript(rvsc1)
		else:
			head.onescript(rvsc2)
		#await head.scrdone#?
		rivalflip = !rivalflip
