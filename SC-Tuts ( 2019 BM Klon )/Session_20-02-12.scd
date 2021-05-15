// Skalen
// Telemann Skala: Eine Oktave in 55 gleich große Schritte eingeteilt

~scale = Scale.new((0 .. 54), 55, name: "Telemann55");
~vrb = Bus.audio(s, 2);

(
Ndef(\verb, {
	var in, sig;
	in = In.ar(~vrb, 2);
	sig = JPverb.ar(in,
		6, // time
		0.6, // damp
		5, // size
		0.6, // early Diff
		0.2, // mod depth
		1, // modFreq
		1.5, // low time
		1.2, // mid time
		0.7, // high time
	)
}).play;
)

(
SynthDef(\x, {|out, freq, amp, gate=1|
	var sig, env, pEnv;
	env = Env.adsr(3, 2, 0.2, 3).ar(2, gate);
	pEnv = Line.kr(1, 0.98, 2);
	sig = LFSaw.ar(freq * pEnv, Rand(0, 1.0));
	sig = HPF.ar(RLPF.ar(sig, freq * env.linlin(0, 1, 0.7, Rand(1.1, 5)), 0.1), freq*1.5, 0.3).tanh * env;
	Pan2.ar(sig, Rand(-1.0, 1.0));
	Out.ar(~vrb, sig*0.4);
	Out.ar(out, (sig * amp).tanh);
}).add;
)

(
Pdef(\x, Pbind(
	\instrument, \x,
	\scale, ~scale,
	\degree, Pseq([10, [10, 9], [10, 8], [10, 5, 15], [20, 10], [20, 11, ]], inf),
	\legato, 5,
	\dur, 1.6
)).play;
)

(
Pdef(\x, Pbind(
	\instrument, \x,
	\scale, Scale.new((0 .. 11), 12, Tuning.at(\just)),
	\degree, [0, 7],
	\dur, 2
)).play
)

(
Pdef(\x, Pbind(
	\instrument, \x,
	\scale, ~scale,
	\degree, Pseq([[0, 0], [0, 1], [0, 2], [0, 3], [0, 10], [2, 10], [1, 3]], 1),
	\amp, 0.05,
	\legato, 2,
	\dur, 2
)).play
)

t = ~scale.tuning
t.semitones[32]

Tuning.directory()







