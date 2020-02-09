(SynthDef(\1, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1/8);
	modenv = Env.new([0, 1, 0], [4, 4], loopNode: 0).ar(0, trig) * 100;
	mod = SinOsc.ar(40) * modenv;
	sig = SinOsc.ar([200, 202], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

(SynthDef(\2, {|out = 0, modamt = 10, amp = 0.3|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1/2);
	modenv = Env.new([0, 1, 0], [1, 1], loopNode: 0).ar(0, trig) * modamt;
	mod = SinOsc.ar(40) * modenv;
	sig = SinOsc.ar([800, 201], mod) * amp;
	Out.ar(out, sig);
}).add;
)

(SynthDef(\3, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1);
	modenv = Env.new([0, 1, 0], [0.25, 0.75], loopNode: 0).ar(0, trig) * 1000;
	mod = SinOsc.ar(50) * modenv;
	sig = SinOsc.ar([1000, 999], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)



a = Synth(\2, [\modamt, 10,					//beim starten des synthies arg verändern
				\amp, 0.5
]);

]);
b = Synth(\2);
c = Synth(\hallo);
s.reboot;


d = [\1, \2, \3];

Synth(d[i % d.size])


//soweit die Strategie
f = {
	var zaehler = 0
	Synth(\"zaehler");
	zaehler++;
}

 i = 0;
({

	var p = [\1, \2, \3];
	i.postln;
	Synth(p[i % p.size]);
	i = i+1;
}.value;)



k.value

//------Synth-Baustelle-----------

(
SynthDef(\sirenebuzz, { |out, gate = 1, amp1 = 0.4, amp2 = 0.2, modfreq = 0.5, modamt = 3, dist = 10000|
	var sig1, sig2, env, env2 , freqenv, trig, env2mod;
	trig = LFPulse.ar(1/modfreq);
	env = Env.adsr(0.4, 0, 1, 1, 1).ar(2, gate);
	freqenv = Env([1, modamt, 1], [modfreq/2, modfreq/2]).ar(0, trig);
	sig1 = SinOsc.ar([400, 340] * freqenv) * env;
	Out.ar(out, sig1.tanh * amp1);

	env2mod = Env([3, 1, 3], [10, 10]).ar(0);
	env2 = LFPulse.ar(env2mod/modfreq);
	sig2 = LFSaw.ar([150, 155]) * env2 * dist;
	Out.ar(out, sig2.tanh * amp2);
}).add;
)

(
SynthDef(\fiepen, {|out, rate = 3, density = 13|
	var sig, trig, window, env;
	trig = Dust.ar(density);
	env = Env.perc(0.01, 0.2).ar(0, trig);
	window = LFPulse.ar(rate);

	sig = SinOsc.ar([8000, 8100]) * env;
	sig = sig * window;

	Out.ar(out, sig.tanh);
}).add;
)
Synth(\fiepen);
a = Synth(\sirenebuzz);