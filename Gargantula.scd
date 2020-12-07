(
SynthDef(\gargantula, {|out = 0, freq = 300, mod = 10, atk = 0.1, dcy = 0, sus = 1, rel = 1 |
	var sum = VarSaw.ar(freq, SinOsc.ar(100), SinOsc.ar(3, SinOsc.ar(mod)));

	var env = Env.adsr(atk, dcy, sus, rel).ar();

	sum = sum * env * 0.4;

	sum = FreeVerb.ar(sum, 0.2, 0.9);

	Out.ar(out, Splay.ar(sum, 0) );

}).add;
)

Synth(\gargantula)