(
SynthDef(\it, { |freq, gate = 1|
	var temp, sum;
	sum = 0;
	15.do{
		temp = VarSaw.ar(freq * {Rand(0.99,1.02)},
			{Rand(0, 0.5)},
			{ExpRand(0.01, 0.1)}
		);
		sum = sum + temp;
	};
	sum = sum *Env.adsr(3, 2, 0.8, 0.5).ar(2, gate);
	sum = sum.sinh * 3;
	sum = FreeVerb.ar(sum, 0.33);
	sum = sum.tanh;
	sum = sum * 0.05;
	Out.ar(0, Splay.ar(sum, 0));
}).add;
)

x = Synth(\it);
x.free;
(
Pdef(\x,
 Pbind(
	\instrument, \it,
	\degree, Pseq([[1, 3], [1, 2], [3, 5], [2, 7]], inf),
		\octave, Pseq([[4, 6], [4, 6], [4, 6], [3, 5]], inf),
		\legato, Pseq([[0.8,1.5]], inf),
		\dur, 5
)
).play;)

//synthdef noch mit arg versehen und dann zu mega distorted drone verwandeln

(
Pdef(\megadrone,
 Pbind(
	\instrument, \it,
	\degree, Pseq([[1, 3], [1, 2], [3, 5], [2, 7]], inf),
		\octave, Pseq([[4, 6], [4, 6], [4, 6], [3, 5]], inf),
		\legato, Pseq([[0.8,1.5]], inf),
		\dur, 5
)
).play;)
