(SynthDef(\1, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1/8);
	modenv = Env.new([0, 1, 0], [4, 4], loopNode: 0).ar(0, trig) * 100;
	mod = SinOsc.ar(40) * modenv;
	sig = SinOsc.ar([200, 202], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

(SynthDef(\2, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1/2);
	modenv = Env.new([0, 1, 0], [1, 1], loopNode: 0).ar(0, trig) * 10;
	mod = SinOsc.ar(40) * modenv;
	sig = SinOsc.ar([800, 201], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

(SynthDef(\hallo, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1);
	modenv = Env.new([0, 1, 0], [0.25, 0.75], loopNode: 0).ar(0, trig) * 1000;
	mod = SinOsc.ar(50) * modenv;
	sig = SinOsc.ar([1000, 999], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

a = Synth(\1);
b = Synth(\2);
c = Synth(\hallo);
s.reboot;

//soweit die Strategie
f = {
	var zaehler = 0
	Synth(\"zaehler");
	zaehler++;
}
(
k = {
	var i = 0;
	var p = [1, 2, hallo];
	i.postln;
	Synth(\p[i % p.size]);
	i = i+1;
}
)

~zahl = 1;
Synth(\'zahl');




