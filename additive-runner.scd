~vrbBus = Bus.audio(s, 2);

(SynthDef(\add, {|out, freq = 200, amp = 0.4, partialstretch = 0.3, gate = 1, sustain = 4|
	var sig, partials, env, freqmod, stretch;

	partialstretch = Env([0, 0.3, -0.2], sustain*[0.5, 0.5]).ar();

	partials = (2, 3 ..14);
	partials = partials + ( partials * partialstretch); // ich glaube das funzt nicht so wie ich will
	partials = [1, partials].flat;

	env = Env.adsr(1, 0.2, 0.9, 1.5, 1).ar(2, gate);

	sig = DynKlang.ar(`[
		partials, //freqs
		1/partials, //amps
		0//phases
	], freq) ! 2;
	sig = sig.tanh * env * amp;
	Out.ar(~vrbBus, sig * 0.3
	);
	Out.ar(out, sig * 0.4);
}).add;
)
a = Synth(\add);
a.set(\amp, 0);
a.set(\amp, 0.2);
a.free

(
Pdef(\x, Pbind(
	\instrument,\add,
	\scale, Scale.at(\harmonicMinor),
	\degree, Pseq([0, 2, 1, 1, 2, 0], inf),
	\legato, Prand([0.1, 0.5, 0.2, 0], inf),
	\dur, Pseq([0.6, 0.6, 0.6, 0.4] * 0.2, inf),
	\octave, Pseq([4, 4, 5, 4, 5]+1, inf)
)).play;
)
// noch erweitern
// HALL
// pattern
(
Ndef(\Hall,{
	var sig;
	sig = In.ar(~vrbBus, 2);
	sig = FreeVerb.ar(sig, 1, 0.9, 0);
}
).play;)
Quarks.gui;