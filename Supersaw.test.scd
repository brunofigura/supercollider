//////////super saw óhne ugen array///////////
(SynthDef(\supersaw, {|out|
	var sig1, sig2, sig3, sig4, sig;

	sig1 = Saw.ar(440);
	sig2 = Saw.ar(445);
	sig3 = Saw.ar(450);
	sig4 = Saw.ar(455);
	sig = sig1+sig2+sig3+sig4;


	Out.ar(out, LeakDC.ar(sig));
}).add;)

a = Synth(\supersaw);
a.free;

//////////super saw mit ugen array///////////
(SynthDef(\ss, {|out|
	var sig;
}).add;)