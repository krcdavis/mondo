extends CanvasLayer

var mode = ""
var head

var menus = {}

var activemenu#use

const MAINM = "mainm"
const PARTYM = "partym"
const MONM = "monm"
const SETM = "settings"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$pauseoptions.menuhead = self
	
	menus[MAINM] = $pauseoptions
	menus[PARTYM] = $partymenu
	menus[MONM] = $monmenu
	menus[SETM] = $settingsmenu
	
	#restate(MAINM)

# 
func _process(delta):
		match mode:
			MAINM, PARTYM, SETM:
				#activemenu is miraculous
				if Input.is_action_just_pressed("ui_up"):
					activemenu.update_cursor("UP")#well it doesn't complain at least
				else: if Input.is_action_just_pressed("ui_down"):
					activemenu.update_cursor("DW")
				else: if Input.is_action_just_pressed("ui_left"):
					activemenu.update_cursor("LF")
				else: if Input.is_action_just_pressed("ui_right"):
					activemenu.update_cursor("RT")
				else: if Input.is_action_just_pressed("ui_accept"):
					activemenu.execute_cursor()

#same pattern as battle menus. time to consider how to simplify it and reuse code
func restate(newstate, moncursor = -1):
	match newstate:
		MAINM, PARTYM, SETM:
			activemenu = menus[newstate]
			for key in menus:
				menus[key].visible = key == newstate
			mode = newstate
			activemenu.update_menu()
		#a single mon's cummary page is also handled here. sure why not
		#sending up/down when on mon menu will switch between mons if stg else
		#(moves, debug thing) isn't actively selected...
		MONM:
			activemenu = menus[newstate]
			for key in menus:
				menus[key].visible = key == newstate
			mode = newstate
			activemenu.update_menu(moncursor)
			#this could just be a if == MONM update(moncursor) else update()
			#if i wanna be real crazy
