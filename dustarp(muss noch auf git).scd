~reverb = Bus.audio(s, 2);
~master = Bus.audio(s, 2);
(
SynthDef(\crackle, {|release = 0.5, gate = 1, density = 1.5, amp = 0.7, freq = 220|
	var sig, env, trig, mod;
	mod = SinOsc.ar(450);
	trig = Dust.kr([density, density-1]);
	env = Env.perc(0.01, release).ar(0, trig);
	sig = SinOsc.ar(freq, mod) * env;
	sig = sig.tanh * amp;

	Out.ar(~reverb, sig);
	Out.ar(~master, sig);

}).add;
)

(
SynthDef(\flaschenpfeifen, {
	var sig, env, trig;
	trig = LFPulse.ar(0.5);
	env = Env.perc(0, 0.01).ar(0, trig);
	sig = LFNoise0.ar(500, 2) * env;

	Out.ar(~reverb, sig.tanh * 0.2);
}).add;
)
c = Synth(\flaschenpfeifen);
c.free;


(
Ndef(\vrb, {
	var in, sig;
	in = In.ar(~reverb, 2);
	sig = FreeVerb.ar(in, 1, 2.3);
	sig;
}).play(~master);)

(Ndef(\mstr, {
	var in, sig;
	in = In.ar(~master, 2);
	sig = in.tanh;
}).play;
)
a = Synth(\crackle);
a.free;
s.freeAll;
().play;



(
Ndef(\distantwhisper, {
	var sig,sig2,sig3, env, trig;
	trig = LFPulse.ar(1);
	env = Env.perc(0, 0.5, 1).ar(0, trig);
	sig = SinOsc.ar(440) * 0.3;
	sig = sig * env;
	sig = FreeVerb.ar([sig, sig], 1);
	sig2 = DelayC.ar(sig, 0.3);
	sig2 = sig2 * 0.6;
	sig3 = sig +sig2;
}).play;)
// signal vielleicht mono machen und dann mit lfo panen
