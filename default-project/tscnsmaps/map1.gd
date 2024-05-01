extends scripttags

var head

#grass- 0 green, 1 purple, 2 yellow
const wild0 = [ ["cube",3],["cone",2] ]
const wild1 = [ ["icos",3],["cone",2] ]
const wild2 = [ ["donut",3],["icos",3],["sphere",2] ]
const wild3 = [ ["arock", 2] ]

const wilds = {
	0: wild0,
	1: wild1,
	2: wild2,
	3: wild3
}
#next: decide some way to designate grey grass as 2-on-1

#like so
const lv = "lv"
const sp = "sp"#fix this pls
#default type is wild one-on-one
const w0 = [{sp:"cube",lv:3},{sp:"cone",lv:2}]
const w1 = [{sp:"icos",lv:3},{sp:"cone",lv:2}]
const w2 = [{sp:"donut",lv:3},{sp:"icos",lv:3},{sp:"sphere",lv:2}]
const w3 = [{sp:"arock",lv:2,typ:"btlw2v1"}]
#res://default-project/scenes-btl/btlw2on1.tscn
const wildstest = {
	0:w0,
	1:w1,
	2:w2,
	3:w3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#init menu...

func loadingritual():
	pass
	#load and add btlw2on1 to head

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_thedoor_body_entered(body):
	if body.name == "you":
		head.changemap(["default-project/tscnsmaps/map2","Node3D"])

const signq = {typ: txt, txt: "What flavor do[testx]f[/testx] you want??",wait: "menu"}
#{typ:menu,mtype:long, list:flavorlist} ...
const flavorlist = ['apple','cherry','lemon','lime','grape']

func _on_signarea_area_entered(area):
	if area.name == "interact":#add to scripttags
		gb.head.onescript(signq)
		

func signscript():
	gb.head.onescript(signq)
	#no need to await since menu pops immediately... or wait for text finished...
	#spawn menu(5,flavorlist)#you know, sending in size is completely useless. just use list size
	#head.hud.newlongmenu(5,flavorlist)
	#somevar = head.hud.menuresult
	#or, somevar = await head.hud.activemenu.menuresult
	#play next line and set the variable for the other sign.
	#!! the text also needs to wait for menudone to clear!!
	#or it awaits for head.hud to recieve the activemenu signal.


func _on_signarea_3_area_entered(area):
	pass # Replace with function body.
	#if flavor has been selected, ;else, display flavor message
