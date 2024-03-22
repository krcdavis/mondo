extends Node2D
#NEXT: switch to pure labels over a background image

var things = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	#things = [$nametg,$leveltg,$typetg,$stgtg, $move1, $move2, $move3, $move4]
	#for thing in things:
		#thing.highlight(false)
	
	update(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#to make this super-modular, should be a pattern of, if label exists, if variable
#exists in monster(ie extended project monster), then set
#if label exists but not variable set some default

func update(partyslot):#that should be the only time it's called
	$nametg.setlabel(party.party[partyslot].nname)
	$leveltg.setlabel(str(party.party[partyslot].level))
	#type name string
	#d.sph.getstg(party.party[partyslot].species_id,"type")
	#$typetg.setlabel( d.sph.getstg(party.party[partyslot].species_id,"type") )
	$statustg.setlabel("ok")
	
	var mm = party.party[partyslot].getmove(0)
	if d.moves.move_isvalid(mm):
		$move1.setlabel(d.moves.move_getname(mm))
	
	mm = party.party[partyslot].getmove(1)
	if d.moves.move_isvalid(mm):
		$move2.setlabel(d.moves.move_getname(mm))
	
	mm = party.party[partyslot].getmove(2)
	if d.moves.move_isvalid(mm):
		$move3.setlabel(d.moves.move_getname(mm))
	
	mm = party.party[partyslot].getmove(3)
	if d.moves.move_isvalid(mm):
		$move4.setlabel(d.moves.move_getname(mm))
	
	
	$atktg.setlabel(str(party.party[partyslot].attack))
	$deftg.setlabel(str(party.party[partyslot].defense))
	$speedtg.setlabel(str(party.party[partyslot].speed))
	$exptg.setlabel(str(party.party[partyslot].expr))
	
	$hptg.setlabel(str(party.party[partyslot].hp)+'/'+str(party.party[partyslot].health))
	$hpbar.sethp(party.party[partyslot].hp,party.party[partyslot].health)
