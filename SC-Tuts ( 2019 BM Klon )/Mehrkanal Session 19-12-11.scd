().play;


(
Ndef(\x, { Impulse.ar(rrand(1, 8 ! 16)) }).play;
)



Ndef(\x).reshaping(\elastic);



b = Buffer.readChannel(s, "/Users/laborant/seminarloop.wav", channels: 0);

b.play


b = Buffer.readChannel(s, "/Users/laborant/Sounds/400909__inspectorj__voice-request-25-where-i-am.wav", channels: 0);

b = Buffer.readChannel(s, "/Users/laborant/Sounds/palestrina.wav", channels: 0);

(
Ndef(\y, {
	PlayBuf.ar(1, b, a.midiratio, loop: 1);

}).play;
)


(
Ndef(\y, {
	var sig;
	sig = PlayBuf.ar(1, b, (a*1).midiratio, loop: 1);
	sig = Splay.ar(sig, 1);
}).play;
)

(
// stereo version
Ndef(\y, {
	var sig;
	sig = PlayBuf.ar(1, b, (a*12).midiratio, loop: 1);
	sig = Splay.ar(sig, 1);
}).play;
)

a = (0.125, 0.25 .. 2)

// stueck
a = (1/16, 2/16 .. 1);
b = Buffer.readChannel(s, "/Users/laborant/Sounds/431873__esares__106-bpm-drum-loop-2.wav", channels: 0);
(
Ndef(\y, {
	PlayBuf.ar(1, b, (a * XLine.ar(0.1, 12, 4*60).poll).midiratio, loop: 1);
}).play;
)


(
a = (1, 1.001 .. 1.015);
Ndef(\x, {
	var sig, env, imp;
	imp = Impulse.ar(a);
}).play;
)

(
a = (1, 1.002 .. 1.030);
c = Scale.at(\dorian);
Ndef(\x, {
	var sig, env, imp;
	imp = Impulse.ar(a);
	env = Env.perc(0, 1).ar(0, imp);
	sig = SinOsc.ar(c.degreeToFreq((0, 1 .. 15), 300, 0)) * env * 0.2;
}).play;
)

(
a = (1, 1.004 .. 1.060).scramble;
c = Scale.at(\dorian);
Ndef(\x, {
	var sig, env, imp;
	imp = Impulse.ar(a);
	env = Env.perc(0, 1).ar(0, imp);
	sig = SinOsc.ar(c.degreeToFreq((0, 1 .. 15), 300, 0)) * env * 0.2;
}).play;
)

(
a = rrand(1, 1.1 ! 16);
c = Scale.at(\dorian);
Ndef(\x, {
	var sig, env, imp;
	imp = Impulse.ar(a);
	env = Env.perc(0, 1).ar(0, imp);
	sig = SinOsc.ar(c.degreeToFreq((0, 1 .. 15), 300, 0)) * env * 0.2;
}).play;
)

(
SynthDef(\x, {|out,
	freqs=#[
		100, 200, 300, 400, 500, 600, 700, 800,
		900, 1000, 1100, 1200, 1300, 1400, 1500, 1600
	],
	amps=#[
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1
	], gate=1|
	var sig, env;
	env = Env([0, 1, 0], [0.05, 0.05], 'sin', 1).ar(2, gate);
	sig = SinOsc.ar(freqs) * amps * env;
	Out.ar(out, sig * 0.1);
}).add;
)

(
Tdef(\x, {
	var synth, freqs, amps;
	freqs = (1, 2 .. 16) * 100;
	amps = 1 ! 16;
	inf.do{
		if(synth.notNil){synth.set(\gate, 0)};
		synth = Synth(\x, [
			\freqs, freqs.scramble,
			\amps, amps
		]);
		1.wait;
	};

}).play;
)


(
Tdef(\x, {
	var synth, freqs, amps;
	freqs = rrand(50, 2000 ! 16);
	amps = rrand(0.01, 1 ! 16);
	inf.do{
		if(synth.notNil){synth.set(\gate, 0)};
		synth = Synth(\x, [
			\freqs, freqs.scramble,
			\amps, amps.scramble
		]);
		1.wait;
	};

}).play;
)

(
SynthDef(\x, {|out,
	freqs=#[
		100, 200, 300, 400, 500, 600, 700, 800,
		900, 1000, 1100, 1200, 1300, 1400, 1500, 1600
	],
	amps=#[
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1
	], gate=1|
	var sig, env;
	env = Env([0, 1, 0], [0.05, 0.05], 'sin', 1).ar(2, gate);
	sig = XFade2.ar(SinOsc.ar(freqs), WhiteNoise.ar(0.2), amps)  * env;
	Out.ar(out, sig * 0.1);
}).add;
)

(
Tdef(\x, {
	var synth, freqs, amps;
	freqs = rrand(50, 2000 ! 16);
	amps = (1 ! 16).rand2;
	inf.do{
		if(synth.notNil){synth.set(\gate, 0)};
		synth = Synth(\x, [
			\freqs, freqs.scramble,
			\amps, amps.scramble
		]);
		1.wait;
	};
}).play;
)


(
Ndef(\z, {
	var sig;
	sig = SinOsc.ar(300) + WhiteNoise.ar(0.1);
	sig = PanAz.ar(16, sig, LFSaw.ar(SinOsc.ar(0.03).range(0.1, 2) )) * 0.1

}).play;
)

(
Ndef(\y, {
	var sig;
	sig = SinOscFB.ar(100, 1.5) + WhiteNoise.ar(0.1);
	sig = PanAz.ar(16, sig, LFSaw.ar(SinOsc.ar(0.03).range(-0.1, -2) )) * 0.1
}).play;
)


b = Buffer.readChannel(s, "/Users/laborant/Sounds/400909__inspectorj__voice-request-25-where-i-am.wav", channels: 0);
(
a = (1, 1.002 .. 1.030);
Ndef(\y, {
	var sig;
	sig = PlayBuf.ar(1, b, (a*12).midiratio, loop: 1);
	sig = SplayAz.ar(8, sig, 1, center: LFSaw.ar(0.1));
}).play;
)
