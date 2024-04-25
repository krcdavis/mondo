extends mscripttags

#declare the variables here (:

var btlhead
var head#hmm
var engine

var returncam#camera to return to when exiting battle ?

var slots = []#appended to in btl head
var points = []
var labels = []

var textbox

#hold the effectiveness multiplier of the last used move, for displaying the right message
var effectiveness = 1

var squeue7 = []
var squeue2 = []
var squeue0 = []
var squeuem2 = []
var squeuem3 = []

var speedqueues = [squeue7, squeue2, squeue0, squeuem2, squeuem3]

var specialqueue = []#for switch, item and run

var activemenu

var turnhead_faint = false#?
signal thingdone#??


#keep this synced with the list in dtags pls
#const SQ7 = 0
#const SQ2 = 1
#const SQ0 = 2
#const SQm2 = 3
#const SQm3 = 4

#modes
const OPTIONS = "options"
const MOVES = "moves"
const BAGM = "baggu"
const PARTYM = "partym"
const PARTYMF = "partymforced"

const NEXTOREXEC = "next-or-exec"

#unused?
const INTURN = "inturn"
const EXECTURN = "execturn"

var mode = "aaaaaaa"





