extends CanvasLayer

var mode
var head

var menus = {}

var activemenu#use

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$pauseoptions.menuhead = self
	
	menus["partym"] = $partymenu
	menus["monm"] = $monmenu
	

# 
func _process(delta):
	pass
	#match mode, menu etc
	#if head.mode == "pause":
		#if Input.is_action_just_pressed("ui_accept"):
			#head.unpause()
		
		#match mode:#options, party, bag, etc

#same pattern as battle menus. time to consider how to simplify it and reuse code
func restate(newstate, moncursor = -1):
	match newstate:
		"mainopts":
			$pauseoptions.visible=true
			$partymenu.visible = false
			activemenu = $pauseoptions
			#etc
		"party":
			#there should really be some kind of animation, lol
			#also, update party menu first here too
			$pauseoptions.visible=false
			$partymenu.visible = true
			activemenu = $partymenu
		#a single mon's cummary page is also handled here. sure why not
		#sending up/down when on mon menu will switch between mons if stg else
		#(moves, debug thing) isn't actively selected...
		"mon":
			pass
			#monmenu.update(cursor from partymenu... pass it in!)
