(SynthDef(\add, {|out, freq = 200, amp = 0.4, partialstretch = 0.8, gate = 1, sustain = 4|
	var sig, partials, env, freqmod, stretch;

	partialstretch = Env([0, 0.3, -0.2], sustain*[0.5, 0.5]).ar();

	partials = (2, 3 ..14);
	partials = partials + ( partials * partialstretch);
	partials = [1, partials].flat;

	env = Env.adsr(1, 0.2, 0.9, 1.5, 1).ar(2, gate);

	sig = DynKlang.ar(`[
		partials, //freqs
		1/partials, //amps
		0//phases
	], freq) ! 2;
	Out.ar(out, sig.tanh * env * amp)
}).add;
)
a = Synth(\add);
(
Pdef(\x, Pbind(
	\instrument,\add,
	\scale, Scale.at(\harmonicMinor),
	\degree, Pseq([0, 2, 1, 1, 2, 0], inf),
	\legato, 1.9,
	\dur, 4
)).play;
)
// noch erweitern
// HALL
// pattern