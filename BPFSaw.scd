s.boot;
s.meter;
s.plotTree;

Scale.directory;

(
SynthDef(\bpfsaw, {|atk = 2, sus=0, rel=3, c1=1, c2=(-1),
					freq=300, cf = 800, rq=0.3, amp=1, out=0|
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus, rel],[c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq);
	sig = BPF.ar(sig, cf, rq);
	sig = sig * env;
	Out.ar(out, sig*amp);
}).add;
)



(
[58, 65, 70, 73].midicps.do{|f|
	Synth(
		\bpfsaw,
		[
			\freq, f,
			\amp, 0.25,
			\cf, f * exprand(1, 12),
			\rf, exprand(0.1, 0.5),
		]
	)
};
)

(
5.do{
	Synth(
		\bpfsaw,
		[
			\freq, exprand(100,1500),
			\amp, 0.2,
			\cf, exprand(100, 5000),
			\rf, exprand(0.01, 0.5),
		]
	)
};
)
//mit scales
(
(1..10).choose.do{
	Synth(
		\bpfsaw,
		[
			\freq, (Scale.scriabin.degrees+59).midicps.choose,
			\amp, 0.2,
			\cf, exprand(100, 5000),
			\rf, exprand(0.01, 0.5),
		]
	)
};

)
(
Tdef(\test,{
	loop {
		[58, 65, 70, 73].midicps.do{|f|
	Synth(
		\bpfsaw,
				[
					\freq, f,
					\amp, 0.25,
					\cf, f * exprand(1, 12),
					\rf, exprand(0.1, 0.5),
				]
			)
		};
	2.wait;
	}
} )
)

Tdef(\test).play;
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
(
SynthDef(\bpfsaw2, {|atk = 2, sus=0, rel=3, c1=1, c2=(-1),
					freq=300, cfmin = 500,cfmax=5000, rqmin=0.1, rqmax=0.3, amp=1, out=0, detune=0.3, pan = 0|
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus, rel],[c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5, detune).midiratio);//detune in semitones angegeben
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(0.2).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)
(
10.do{
	Synth(
		\bpfsaw2,
		[
			\amp, 0.3,
			\detune, 0.2,
			\freq, 50,
			\cfmin, 50*2,
			\cfmax,50*50,
			\rqmin, 0.05,
			\rqmax, 0.3
		]
	)
};
)

(
10.do{
	Synth(
		\bpfsaw2,
		[
			\amp, 0.3,
			\detune, 0.2,
			\freq, 50,
			\cfmin, 50*2,
			\cfmax,50*50,
			\rqmin, 0.05,
			\rqmax, 0.3
		]
	)
};
)

//patternssssssssssssssssssssssssssssssssssssssssssssssssssssss
(
Pdef(\x, Pbind(
	\instrument, \bpfsaw2,
	\freq, Pseq([50, 55, 80], 2),
	\cfmin, Pseq([50*2, 55*2, 80*2],2),
	\cfmax, Prand([1000,2000,5000], inf),
		)
	).play;
)