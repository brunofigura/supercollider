(SynthDef(\envloop, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1/8);
	modenv = Env.new([0, 1, 0], [4, 4], loopNode: 0).ar(0, trig) * 100;
	mod = SinOsc.ar(40) * modenv;
	sig = SinOsc.ar([200, 202], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

a = Synth(\envloop);
a