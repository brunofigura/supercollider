s.plotTree;

(
SynthDef(\a, {
	var sig = SinOsc.ar([650, 1100, 2860, 3300, 4500]);
	var amps = [0, -8, -13, -12, -19];	//in dB

	sig = sig * amps.dbamp;

	sig = PanAz.ar(2, sig, 0);

	Out.ar(0, sig);
}).add;)

a = Synth(\a);

