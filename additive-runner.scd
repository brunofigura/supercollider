(SynthDef(\add, {|out, freq = 200, amp = 0.4, stretch = 0.8, gate = 1|
	var sig, partials, env, freqmod;

	freqmod = Env.adsr(5, 5, stretch, 1).ar(2, gate) ;
	partials = (2, 3 ..15);
	partials = partials + ( partials * freqmod);
	partials = [1, partials].flat;

	env = Env.adsr(1, 0.2, 0.9, 1, 1).ar(2, gate);

	sig = DynKlang.ar(`[
		partials, //freqs
		1/partials, //amps
		0//phases
	], freq) ! 2;
	Out.ar(out, sig.tanh * env * amp)
}).add;
)
a = Synth(\add);

// noch erweitern
// HALL
// pattern