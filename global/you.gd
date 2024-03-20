extends CharacterBody3D


const SPEED = 10.0
#const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var head#?

var dirnow = 0.0
var dirnew
var dirold = 0.0#?
var turntimer = 0.0
const turntime = .23

#encounter countdown. range will be stored... somewhere
var encountdown = 8
var cdb = .5#count down by...
#actually, dec by higher amounts to increase encounter rate

@onready var area = $"player-area"
@onready var vis = $visual
@onready var intp = $visual/intpoint
@onready var anim = $visual/model/serenahandler.anim
var mode = ""

#remember to set area colis mask 2 to true btw
func _ready():
	pass
	#anim.get_animation("walk1").set_loop(true)#lol
	anim.play("idlestand")

func _physics_process(delta):
	var tempanim = "idlestand"
	if head.mode == "you":#and self mode
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# no jump. reuse to pop pause menu... or to interact
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():#enter
			#intp.spawnsphere()
			#var il = intp.get_overlapping_bodies()
			#for im in il:
				##print(im.name)#this is necessary apparently
				#if im.has_method("interaction"):#add to interaction queue or stg
					#im.interaction()
				#break out of for loop.
			#NEXT VERSION: set colision layers on, set timer for 2-3 frames, turn col layers off
			#...via a funct on interact, which has its own timer?... yeah that
			intp.spawn_probe()
			#looks like we're back to doing spawned probes.
		else: if Input.is_action_just_pressed("ui_select") and is_on_floor():#spess
			head.pause()
		
		else:
			var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			
			#if-moving block
			if direction:
				tempanim = "walk1"
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				#speen
				#$visual.rotation = Vector3(0, Vector2(-direction.x,direction.z).angle()-PI/2 ,0)
				dirnew = Vector2(-direction.x,direction.z).angle()-PI/2
				if dirnow != dirnew:
					dirold = dirnow
					dirnow = dirnew
					turntimer = turntime
				if turntimer > 0:
					var dirturn = lerp_angle(dirold, dirnew, max(0,min(1,(turntime-turntimer)/(turntime-.05))) )
					turntimer -= delta
					$visual.rotation = Vector3(0, dirturn,0)
				else:
					$visual.rotation = Vector3(0, dirnew,0)
				
				#grass
				var ar = area.get_overlapping_bodies()
				var list = []
				for a in ar:
					if a.has_method("is_grass"):
						#to account for being in contact with multiple types of grass patches...
						#if list does not have id, add
						if a.id not in list:
							list.append(a.id)
				#if list not empty:#there we go
				if list:
					#print(list)
					#dec encounter counter. if zero, do encounter and reset counter randomly.
					encountdown -= cdb
					if encountdown <= 0:
						print("wild!", list)
						encountdown = 58
						head.init_battle(list)
				#counter is not dec'd by delta because lag spikes should not cause more encounters...
					
				
			#not moving
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
			
			move_and_slide()
			
			if anim.get_current_animation() != tempanim:
				anim.play(tempanim)
			
