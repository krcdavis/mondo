extends dscripttags

signal movedone

var btlhead
var slots
var textbox

#add some stuff
var fieldstate = "z"

func setup(battlescene):
	btlhead = battlescene
	slots = btlhead.slots
	#etc etc
	textbox = btlhead.textbox

func set_AI(slot):
	#currently hardcoded for wild one-on-one and will be updated as things are added.
	#simply pick a random (valid) move
	#an array of [[index, moveid]]
	var vmoves = []

	#check each move for validity. technically this should be guaranteed on mon creation but oh well
	for n in range(0,4):#replace 4 with whatever max move number you have
		var mmove = slots[slot].mon.getmove(n)
		if d.moves.move_isvalid(mmove):
			vmoves.append( [n, mmove] )
	var ranint = gb.rng.randi_range(0, vmoves.size())

	slots[slot].set_movenext( slots[slot].mon.getmove(ranint), ranint, 0)



func doamove(moncomp):
	#ensure user exists and is still alive. else
	var _mv = d.moves.move_getmove(moncomp.movenext_id)
	#if move has target(s), ensure at least one of them still exists or is alive...
	
	#anyway, match move effect type. for now there's nothing at all so just move on
	simplemove(moncomp)

func simplemove(moncomp):
	#print("it's alive!")
	var _mv = d.moves.move_getmove(moncomp.movenext_id)
	
	var target = slots[moncomp.movenext_target]
	var dm = d.moves.move_getdmg(moncomp.movenext_id)
	
	var at = d.moves.move_gettype(moncomp.movenext_id)
	var tt = d.sph.getstg(target.mon.species_id, dt.tgtype)
	#if you add a secondary type...
	#var tt2 = d.species.getstg(target.mon.species, dt.tgtype2)
	var rel = 1#not yet implemented, lol
	rel = d.types.get_rel(at,tt)
	#set some "register" in btlhead to rel, to determine the message after attack
	btlhead.effectiveness = rel
	
	#someday...
	var cdmg = dm * rel * moncomp.catk / target.cdef
	
	textbox.textplay(str("%s used %s!" % [moncomp.mon.nname,d.moves.move_getname(moncomp.movenext_id)]))
	await textbox.textover
	#damage target by cdmg, check for faint
	target.damage_by_amt(cdmg)
	#update hp
	btlhead.update_label(moncomp.movenext_target)
	
	if rel > 1:
		textbox.textplay("It's super-effective!")
		await textbox.textover
	else: if rel == 0:#this should be different actually
		textbox.textplay("It did nothing at all!")
		await textbox.textover
	else: if rel < 1:
		textbox.textplay("It's not so effective...")
		await textbox.textover
	
	
	
	if (target.mon.health == 0):
		btlhead.faintmon(moncomp.movenext_target)
		await btlhead.thingdone
	
	#do various side effects, eg inflict status on target, lower/raise users stats, etc.
	
	emit_signal("movedone")









#func _ready():
	#pass # Replace with function body.

#func _process(delta):
	#pass
