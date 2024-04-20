extends Node2D

@onready var item = preload("res://flatscenes/optbase.tscn")
var items = []
var itemcount = 0
var actives = []
var activescount = 0
var cursor = 0


#var xd = 220
#var yd = 64

var btlhead#only used for battlehud menus...

signal menuresult

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.

#this works!! hooray!!!
func set_optbase(stri = "res://flatscenes/optbase.tscn"):
	#unload item and replace with preload(stri)
	#item.queue_free()#does this need to be done?
	item = load(stri)
	#and of course using hardcoded strings is baaaaad but we'll worry about that later

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#how much should be handled here vs in top level menu ready?
#placement should probably be handled on the shape level, but text and name could be passed in
func instance_item(text, namey = ""):
	var itemst
	
	itemst = item.instantiate()
	add_child(itemst)
	items.append(itemst)
	itemst.setlabel(text)
	if namey != "":
		itemst.name = namey
	#?
	else:
		itemst.name = text
	
	return itemst#or the calling function could just use items[n]

#plus option to send in an empty list...
#also you don't really need to send in the number
func base_create_menu(num,list):
	
	for n in range(0,num):
		instance_item(list[n])
		#items[n].setlabel(list[n])
		items[n].add_data("index", n)
		items[n].add_data("data", list[n])
	
	
	active_all()
	sizer()
	#update_cursor()

func base_create_empty_menu(num,):
	
	for n in range(0,num):
		instance_item("--")
		#items[n].setlabel(list[n])
		items[n].add_data("index", n)
		#items[n].add_data("data", list[n])
	
	
	active_all()
	sizer()
	#update_cursor()


func sizer():
	itemcount = items.size()
	activescount = actives.size()

func active_all():
	actives.clear()
	for it in items:
		actives.append(it)

func default_execute_cursor():
	var result = actives[cursor].get_data("data")
	menuresult.emit(result)
	#return "something"
