b = Buffer.read(s, "C:/Users/FiguraCarl-Bruno/supercollider/export/Strings_F#_80BPM.wav");
b.plot;
b.play;

~reverb = Bus.audio(s, 2);
~master = Bus.audio(s, 2);

(
SynthDef(\sample1, {|bufnum = 0, rate = 0.5, gate = 1, amp = 1|
	var sig, env, posmod, modfreq;
	modfreq = TRand.ar(0, 5,LFPulse.ar(2));
	env = Env.adsr(0.5, 1, 0.8, 1).ar(2, gate);
	posmod = TRand.ar(0, 1, LFPulse.ar(3));
	sig = PlayBuf.ar(2, b, rate, LFPulse.ar(modfreq), posmod *  BufFrames.kr(b), 1, 2);
	sig = sig * env * amp;
	Out.ar(12, sig);
	Out.ar(14, sig.tanh);
}).add;
)


c = Synth(\sample1);
c.set(\gate, 0);
c.free
(
a = Pbind(

	\instrument, \sample1,
	\scale, Scale.at(\minor),
	\degree, Pseq([0, 0, 2, 6, 1, 3], inf),
	\dur, Prand([2, 2, 3, 4], inf),
	\rate, Pshuf([0.5, 1, -0.5, 0.75, 1.25, 1.5, 2, -1.25], inf),
	\legato, Pshuf([1, 2, 4, 0.5], inf);
)
)
a.play



(
Ndef(\vrb, {
	var in, sig;
	in = In.ar(12, 2);
	sig = CombC.ar(in, 0.4, 0.2, 1);
	sig;

}).play(14);
)

(
Ndef(\mstr, {
	var sig, in;
	in = In.ar(14, 2);
	sig
}).play;)