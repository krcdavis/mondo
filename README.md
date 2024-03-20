### Mondo project- mon game for Godot

Mondo Project is a free and open-source turn based RPG game engine for the Godot engine, with a particular resemblance- to a certain popular monster-collecting franchise. The aim is to provide basic code for common -things/events/functions like battling, interacting, catching, etc, while still providing flexibiliy and ways for the user to customize their game's gameplay. To this end, the project has been organized in a specific way, where ideally the user can just have all their code and data in a project folder, and the engine will look for and load all the needed files.
This could also be used for more general turn-based RPG type games.

So how does this work?
Not very well ha ha ha. Jokes aside, it's early days, so a lot of this is rather... messy.

a few highlights:

**data-handler.gd**: a global singleton that gets certain files from the specified project folder and loads them. These files include data files for things like species, scripts for getting data from said data files, the battle engine, etc.
If the project folder isn't found, the default-project folder will be loaded instead. (This has the nice aside affect of letting me work on my own game projects that won't be open-sourced right in the same project, exclude those and the project still "works" right out of the box.)
Later further error-checking will be added, as well as properly calling add_child() for each file loaded this way so their ready functions are actually run.

**The scripttags system**: At the moment, data is stored in dictionaries. This will probably at some point be rewritten to use resources like most other games but for now this works well enough. To aid in that, the project has a system of using "script tags", predefined strings that can be used as keys for those dictionaries as well as certain other commonly-used identifiers (eg types).
The project comes with a base scripttags file containing tags that're likely to be used in every project (like keys for "name" and "type"). The user can extend this file and add their own tags, for things like their game's unique types system or additonal keys for new game mechanics. The default project is very, well, default, so there's not much to add, but I've created a tag just to use as an example.

**battle engine**: The majority of the battle code is generalized to work with any project- things like switching out, selecting moves, really basic stuff. The battle engine object gives engine users the ability to slip their own code into -there. For example, the default project uses it to add a custom damage calculation. Not a very interesting or complex calculation, sure, but it's technically unique to the default project, not the engine itself.
As an example, if you added secondary types to your mons, you'd want to account for that during damage calculation- checking both types of the attacker for STAB if you have that then checking both of the target's types for type multipliers.

**The head scene**: This scene basically manages everything else. The player node, pause menu, current map, etc are all children of this node, and it handles things like swapping maps, switching between overworld and battle scene, etc.

**monster.gd and battlecomp.gd**: A basic monster (as in an individual mon, not a species), and a in-battle-companion-object that holds extra data for that mon while in battle (needs a better name).

And so much more (spaghetti)




#### Known problems/To-do:
-everything
-Apparently FileAccess doesn't work in released projects, at least for some cases. It's mostly used for in-progress games where you might be missing files or have moved them so it should be possible to scrub it from the code of a finished game. Maybe slap some of that OS.is_debug_build in there.

#### Things coming next:
-type relations actually i got that done already yay
-pause menu
-More overworld interaction stuff, including spawning a menu when talking to someone and getting the player's choice from that menu.
--Somehow figure out how to implement activating things like animations while printing text to the text box. So like characters can react to something another character is saying. This is done by "control codes" in other games like Animal Crossing. I vaguely remember at some point finding a tutorial for how to call abritrary functions from a text box via custom BBCode effects, but I can't find it again.
-Adding mons to your party, including gift mons and catching.
-Different battle types, mainly trainer and double battles.
-Functionality to extend monster and battlecomp objects.
-EXP, evolution
-saving
