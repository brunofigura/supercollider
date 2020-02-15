Quarks.gui
//four 'randomised' rhythms, sounds okay.

//Euklidian Rythm
//funktioniert nicht

(
a = Pbind(\instrument, \default,
	\degree, Pseq([0, 0, 1, 3], inf),
	\dur, Pbjorklund2(4, 16), inf
)
)

a.play




