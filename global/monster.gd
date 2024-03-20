
extends "res://global/scripttags.gd"
class_name Monster

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
var qluck: int
var qskill: int

#gained stats ala EVs
var ghp: int#etc
var gattack: int
var gspeed: int
var gdefense: int
var gluck: int
var gskill: int

#calculated stats and current health using species data; next, include unique and gained
var hp: int#max
var health: int#current
var attack: int
var speed: int
var defense: int
var luck: int
var skill: int
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
		#should be done on load or stg. or should be const
		#if gb.n > 1: gb.n = .99
		#if gb.n < 0: gb.n = .01
		
		attack = setstat(d.sph.getstg(species_id, tgatk))#don't worry this works (:
		defense = setstat(d.sph.getstg(species_id, tgdef))
		#luck = setstat(d.species.getstg(species_id, tgluck))
		#skill = setstat(d.species.getstg(species_id, tgskill))
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
		expr = int(pow(lvl, 3)) #next: set_exp_level(species, lvl) that uses species_id for different growth types
		setstats(helth)
		temp = 0#not -1 because reasons
		
		#base moveset from species data, temporary
		move0 = d.sph.getstg(species_id, tbmoves)[0]
		move1 = d.sph.getstg(species_id, tbmoves)[1]
		move2 = d.sph.getstg(species_id, tbmoves)[2]
		move3 = d.sph.getstg(species_id, tbmoves)[3]
		
		

func addlevel():
	update_level(level+1)

func update_level(newlvl):
	level = newlvl
	setstats(health)#pass in current health
	#should actually be current health + amt gained in levelup but that doesn't matter much rn
	#check for new moves(hahah)


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
