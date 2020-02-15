b = Buffer.read(s, "C:/Users/FiguraCarl-Bruno/supercollider/export/Strings_F#_80BPM.wav");
b.plot;
b.play;

(
SynthDef(\sample1, {|out = 0, bufnum = 0, rate = 0.5, gate = 1|
	var sig, env, posmod;
	env = Env.adsr(0.5, 1, 0.8, 0.1).ar(gate, 2);
	posmod = TRand.ar(0, 1, LFPulse.ar(3));
	sig = PlayBuf.ar(2, b, rate, LFPulse.ar(30), posmod *  BufFrames.kr(b), 1, 2);
	Out.ar(out, sig.tanh);
}).add;
)

(
a = Pbind(
	\instrument, \sample1,
	\scale, Scale.at(\minor),
	\degree, Pseq([0, 0, 2, 6, 1, 3], inf),
	\dur, Prand([1, 1, 2, 3], inf),
)
)
a.play