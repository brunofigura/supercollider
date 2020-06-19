(
Ndef(\etwas, {
	var sig = Saw.ar(440, SinOsc.ar(Rand(0, 1000), SinOsc.ar(0.1, 9), 2)) * 0.3;
	Pan2.kr(sig, SinOsc.ar(1));
}).play;)

Ndef(\etwas).stop;