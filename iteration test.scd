(
SynthDef(\it, { |freq|
	var temp, sum;
	sum = 0;
	15.do{
		temp = VarSaw.ar(freq * {Rand(0.99,1.02)} ! 2,
			{Rand(0, 0.5)},
			{ExpRand(0.01, 0.1)}
		);
		sum = sum + temp;
	};
	sum = sum *Env.adsr(0.1).ar(doneAction: Done.freeSelf);
	sum = sum * 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth(\it);
x.free;
(
Pdef(\x,
 Pbind(
	\instrument, \it,
	\freq, Pseq([100,
			200, 400, 100], inf),
		\legato, 0.1,
		\dur, 0.5
)
).play;)

Pde