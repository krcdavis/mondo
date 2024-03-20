extends dscripttags

#resistances. so index by [defender][attacker]
#values should go from 0 (immunity) to 1 (resist-neutral) to some max multiplier (SE)
const types = {
	tgred: {
		tgred: 0.5,
		tgblue: 1.5,
		tggreen: 2.0,
		tgpur: 0.5
	},
	tgyel: {
		tgblue: 1.5,
		tggreen: 0.5,
		tgyel: 0.5,
		tgpur: 2.0
	},
	tgblue: {
		tgred: 1.5,
		tgblue: 0.5,
		tgyel: 2.0,
		tgpur: 0.5
	},
	tgpur: {
		tgred: 0.5,
		tgblue: 0.5,
		tgyel: 2.5,
		tgpur: 1.5
	},
	tggreen: {
		tgred: 2.0,
		tggreen: 0.5,
		tgyel: 0.5,
		tgpur: 1.5
	}
}
