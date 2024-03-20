extends CanvasLayer

var mode

var activemenu
var menuresult


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	#anewmenu()
	
	#newlongmenu(5,flavorlist)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#match mode, menu etc
	match mode:
		"themenu":
				if Input.is_action_just_pressed("ui_up"):
					activemenu.update_cursor("UP")#well it doesn't complain at least
				else: if Input.is_action_just_pressed("ui_down"):
					activemenu.update_cursor("DW")
				else: if Input.is_action_just_pressed("ui_left"):
					activemenu.update_cursor("LF")
				else: if Input.is_action_just_pressed("ui_right"):
					activemenu.update_cursor("RT")
				else: if Input.is_action_just_pressed("ui_accept"):
					#menuresult = 
					activemenu.default_execute_cursor()
					#then move on... emit signal?

const flavorlist = ['apple','cherry','lemon','lime','grape']


#designed such that new menus are made on the fly and discarded when the next menu is made.
func newlongmenu(num, list):
	#hmm
	if activemenu: activemenu.queue_free()
	activemenu = longmenu.new()
	add_child(activemenu)
	activemenu.create_menu(num,list)
	
	#placement...
	# x = screenwidth - xd
	# y = screenheight - textboxheight - yd*num
	#not the best but it'll do
	activemenu.position = $menupt.position - activemenu.items[-1].position - activemenu.items[0].br.position
	
	#doesn't work if scripttags is just "Node", but making it node2d breaks other things (':
	
	mode = "themenu"
	menuresult = await activemenu.menuresult
	mode = "notmenu"
	activemenu.visible = false
	print(menuresult)

