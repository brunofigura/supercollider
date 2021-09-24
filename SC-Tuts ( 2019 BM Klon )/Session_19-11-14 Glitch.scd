TempoClock.tempo = 130/60
(
~vrb = Bus.audio(s, 2);
Ndef(\vrb, {
	var sig;
	sig = In.ar(~vrb, 2);
	sig = JPverb.ar(sig,
		t60: 1.8, damp: 0.6, size: 0.4,
		earlyDiff: 0.618, modDepth: 0.3, modFreq: 1,
		low: 0.8, mid: 1.2, high: 1,
		lowcut: 500, highcut: 12000,
	);
	sig;
}).play;
)
(
SynthDef(\singleDirac, {|out, amp=0.7|
	var sig;
	sig = Impulse.ar(0) * amp ! 2;
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(~vrb, sig * -24.dbamp);
	Out.ar(out, sig)
}).add;

SynthDef(\hiTone, {|out, freq=12000, pan=0, modAmt=0, amp=0.1, sustain=1|
	var mod, sig, env;
	env = Env.perc(0, sustain).ar(2);
	mod = Logistic.ar(Rand(3, 3.4), 8000) * 100;
	sig = Impulse.ar(0) + (SinOsc.ar(freq + (mod * modAmt), ) * -12.dbamp);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(~vrb, sig*amp*(-24.dbamp));
	Out.ar(out, sig*amp)
}).add;

SynthDef(\bd, {|out, freq=30, amp=0.1|
	var env, sig;
	env = Env.perc(0, 2, 1, -12).ar(2);
	sig = SinOsc.ar(freq * (env + 1), 0.3) * env ! 2;
	Out.ar(out, sig*amp)
}).add;

SynthDef(\pseudonoise1, {|out, freq=30, seed=12345, pan=0, amp=0.1, gate=1|
	var env, sig, trig;
	env = Env.adsr(0, 0.02, -6.dbamp, 0).ar(2, gate);
	trig = Impulse.ar(freq);
	RandSeed.ar(trig, seed);
	sig = WhiteNoise.ar(0.1) * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig*amp)
}).add;
)

(
Pdef(\imp, Pbind(
	\instrument, \singleDirac,
	\amp, Pseq([1, 0.5, 0.3, 1, 0.3], inf) * 0.3,
	\dur, Pwrand([1, Pseq([0.1, 0.1, 0.8])], [0.9, 0.1], inf),
));

Pdef(\hi, Pbind(
	\instrument, \hiTone,
	\freq, Pseq([12000, 17000], inf),
	\modAmt, Pseq([2, 0.1], inf),
	\sustain, Pseq([0.1, 1], inf),
	\dur, Pseq([0.5, 15.5], inf),
));

Pdef(\pulse, Pbind(
	\instrument, \hiTone,
	\freq, 8000,
	\modAmt, Pwhite(0.01, 10, inf),
	\sustain, Pseq([0.3, 0.03, 0.03, 0.03, 0.2, 0.3, 0.1], inf),
	\dur, 0.5
));

Pdef(\bd, Pbind(
	\instrument, \bd,
	\freq, 30,
	\amp, -12.dbamp,
	\dur, 16
));
)

(
~noise1 =  Pbind(
	\instrument, \pseudonoise1,
	\freq, Pseq([100, 400, 40, 30], inf),
	\seed, 13458,
	\pan, Pseq([-1, 1, -0.5, 0.5, -0.3, 0.3, 0], inf),
	\legato, Pseq([1,1, 0.5, 0.5], inf),
	\dur, Pseq([0.25, 0.25, 0.5, 0.5], inf)
);

~noise2 = Ppar([
	Pbind(
		\instrument, \pseudonoise1,
		\freq, Pseq([100, 400, 40, 30], inf),
		\seed, 12345,
		\pan, -1,
		\legato, Pseq([1, 0.1, 0.5, 0.5], inf),
		\dur, Pseq([0.25, 0.125, 0.5, 0.5], inf)
	),
	Pbind(
		\instrument, \pseudonoise1,
		\freq, Pseq([1000, 400, 40, 3], inf),
		\seed, 6,
		\pan, 1,
		\legato, Pseq([1, 0.1, 0.5, 0.5], inf),
		\dur, Pseq([0.125, 0.5, 0.5], inf)
	)
]);

~noise3 = Pbind(
	\instrument, \pseudonoise1,
	\freq, Pseq([100, 0.1], inf),
	\seed, 5,
	\pan, Pseq([-1, 1], inf),
	\legato, 0.5,
	\dur, Pseq([(0.25 ! 12), (0.125 ! 8)].flat, inf)
);

~noise4 = Pbind(
	\instrument, \pseudonoise1,
	\freq, Pseq([100, 0.1], inf),
	\seed, 5,
	\pan, Pseq([-1, 1], inf),
	\legato, 0.5,
	\dur, Pseq([(0.25 ! 12), (0.125 ! 8)].flat, inf)
);

~imp1 = Pbind(
	\instrument, \singleDirac,
	\amp, Pseq([1, 0.5, 0.3, 1, 0.3], inf) * 0.3,
	\dur, Pwrand([1, Pseq([0.1, 0.1, 0.8])], [0.9, 0.1], inf),
);
)

(
Tdef(\score, {
	Pdef(\noi, ~noise1).play(quant: q);
	8.wait;
	Pdef(\noi, ~noise2).play(quant: q);
	12.wait;
	Pdef(\noi, ~noise3).play(quant: q);
	8.wait;
	Pdef(\noi, ~noise4).play(quant: q);
	16.wait;
	Pdef(\noi, ~imp1).play(quant: q);
}).play;
)

Tdef(\score).reset

q = Quant(0.125);