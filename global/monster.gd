
extends "res://global/scripttags.gd"
class_name Monster

signal leveldone

var nname: String #nickname actually
var species_id: String

var temp: int#this is used, just temporarily, see?
var level: int
var expr: int

#unique stats- ala IVs
var qhp: int
var qattack: int
var qdefense: int
var qspeed: int

#gained stats ala EVs
var ghp: int#etc
var gattack: int
var gspeed: int
var gdefense: int

#calculated stats and current health using species data; next, include unique and gained
var hp: int#max
var health: int#current
var attack: int
var speed: int
var defense: int
#chp, etc is used for in-battle calced stats for battlecomp

#var moveset = ["","","",""]#this will be remov
#lmao
var move0 = ""
var move1 = ""
var move2 = ""
var move3 = ""
#time for use points!!
var usemaxs = [0,0,0,0]#ppups, max per move is in deytah
var usepoints = [0,0,0,0]

#various other things for confusion, sleep turns, volatile/overlappable, what have you
#... will go in battlecomp
var status: String


#unused... for now
func calc_non_hp(base, unique, gains):#, lev): #level is the same for all 5 stats lol
			#takes needed values and a pointer to calculated target?...
			#bstat + qstat + gstat + level
			return ( ( (base * 2) + unique + (gains/4) ) * level /100) +1 #and nature/tendency, etc
			

func setstats(helth = -1):
		print("base set stats")
		#should be done on load or stg. or should be const
		#if gb.n > 1: gb.n = .99
		#if gb.n < 0: gb.n = .01
		
		attack = setstat(d.sph.getstg(species_id, tgatk))#don't worry this works (:
		defense = setstat(d.sph.getstg(species_id, tgdef))
		speed = setstat(d.sph.getstg(species_id, tgspeed))
		#hp be what
		hp = setstat(d.sph.getstg(species_id, tghp)) + level
		health = hp
		#change helth to percentage-based?
		if helth >= 0 and helth < hp:
			health = helth


func setstat(stat):#non-hp
	return stat * ( sqrt(level) * 10 * gb.n  + level * (1 - gb.n) ) /2

func setup_species_level(species, lvl, helth = -1, _yors = false):
		
		species_id = species
		nname = d.sph.getstg(species_id, tgname)
		
		level = lvl
		expr = 100*(level-1)#temp
		setstats(helth)
		temp = 0#not -1 because reasons
		
		#base moveset from species data, temporary
		#todo: add check for valid moves, lol
		#move0 = d.sph.getstg(species_id, tbmoves)[0]
		#move1 = d.sph.getstg(species_id, tbmoves)[1]
		#move2 = d.sph.getstg(species_id, tbmoves)[2]
		#move3 = d.sph.getstg(species_id, tbmoves)[3]

		#NEXT: loop thru levelupmoves, get all <= lvl, set last 4
		var lmoves = d.sph.getstg(species_id, tglmoves)
		var moveslist = []
		for l in lmoves:
			if l[0] >= level and d.moves.move_isvalid(l[1]):
				moveslist.append(l[1])
		if moveslist.size() == 0:#literally nothing
			move0 = "punch"#idk some global default move
		else: if moveslist.size() >= 4:
				move0 = moveslist[-4]
				move1 = moveslist[-3]
				move2 = moveslist[-2]
				move3 = moveslist[-1]
		else:
			if moveslist.size() >= 1:
				move0 = moveslist[0]
			if moveslist.size() >= 2:
				move1 = moveslist[1]
			if moveslist.size() == 3:
				move2 = moveslist[2]

		


		

func add_exp(amt):
	var newexpr = expr + amt
	#get level from exp. if level > level, ...
	var newlevel = get_level_from_exp(newexpr)
	if newlevel > level:
		update_level(newlevel)
	expr = newexpr
	
	#just put this here for now
	gb.currenttext.textplay(str("%s grew to level %s!" % [nname, str(level)]))
	await gb.currenttext.textover
	emit_signal("leveldone")
	
	#get and check threshold for next level, until no new levels
	#using correct unique formula of course, but for now just this
	#var threshl = 100 * level#battle engine.get exp level (level, growthtype)
	#while newexpr >= threshl:
		#addlevel()#...
		#threshl = 100 * level
	#expr = newexpr

func get_level_from_exp(exp):
	#temp hardcoded as this
	#exp is 100 per level, so
	return int((exp/100)) +1


#this was only used for...
func addlevel():
	update_level(level+1)

func update_level(newlvl):
	var oldlevel = level
	level = newlvl
	#hmmm.....
	setstats(health)#pass in current health
	#should actually be current health + amt gained in levelup but that doesn't matter much rn
	#check for new moves(hahah)

#iterate from oldlevel+1 to new/current level, checking for levelup moves
#next: define levelup moves format, add functionality to learn moves, delete moves
#both in and out of battle...
func level_move_catchup(oldlevel):
	pass

#getmove, setmove, getpp, setpp, decpp; sethealth, dmg by percent, dmg by amt, heal
func getmove(n):
	match n:
		0:
			return move0
		1:
			return move1
		2:
			return move2
		3:
			return move3
		_:
			return null
	

func damage_by_amt(amt):
	#floor amt
	#if amt >= health, set to 0 (and do stg?) else subtract
	if amt >= health:
		health = 0
	else:
		health -= amt

func heal_to_max():
	health = hp
	#and clear fainted status
