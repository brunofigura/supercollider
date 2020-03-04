~reverb = Bus.audio(s, 2);
~master = Bus.audio(s, 2);
(
SynthDef(\crackle, {|release = 0.5, gate = 1, density = 1.7, amp = 0.7|
	var sig, env, trig;
	trig = Impulse.ar(4);
	env = Env.perc(0.01, release).ar(2, trig);
	sig = Pulse.ar(500, 0.7) * env;
	sig = sig.tanh * amp;

	Out.ar(~reverb, sig);
	Out.ar(~master, sig);

}).add;
)
(
Ndef(\vrb, {
	var in, sig;
	in = In.ar(~reverb, 2);
	sig = FreeVerb.ar(in, 2.3);
	sig
}).play(~master);

Ndef(\mstr, {
	var in, sig;
	in = In.ar(~master, 2);
	sig = in.tanh;
}).play;
)
a = Synth(\crackle);
a.free;
s.freeAll;
().play;

