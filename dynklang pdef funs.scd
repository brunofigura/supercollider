1/(1..16)
(
SynthDef(\d, {|out, basefreq = 600, amp = 0.2|
	var harmonics = (1 .. 18);
	var amps = 1/(1..18);

	var env = Env.perc(0.01, 0.2).ar(2);

	var osc = DynKlang.ar(`[harmonics * basefreq, amps, o]);


	var sig = osc * env * amp;


	sig = FreeVerb.ar(sig, 0.3, 0.8, 0.4);

	sig = Pan2.ar(sig, SinOsc.ar(1,0, 0.3));
	Out.ar(out, sig);
	}).add;
)





(
Tdef(\ka, {

	loop { 0.175.wait;
		7.do{|i|(\instrument: \d, \basefreq: 61.midicps + (1.2 * i), \amp: 0.07).play;}
	}

}).play;
)
(
Pdef(\ea, {
	Pbind(\instrument, \d,
		\basefreq, Prand([Pseq([[60, 75], 60, [63, 77], 60, [67, 75], 55, [60, 74]], 1), Prand([[64, 73], 63, [62, 75], 60, 67])], inf).midicps,
		\dur, 0.1
	)
}).play;)

(
Pdef(\ea, {
	Pbind(\instrument, \d,
		\basefreq, Pseq([[60, 75], 60, [63, 77], 60, [67, 75], 55, [60, 74]], inf).midicps,
		\dur, Pseq([0.2, 0.1, 0.1], inf)
	)
}).play;)

(
Pdef(\ea, {
	Pbind(\instrument, \d,
		\basefreq, Pseq([[60, 75], 60, [63, 77], 60, [67, 75], 55, [60, 74]], inf).midicps,
		\dur, 0.1
	)
}).play;)