a = {rrand(1, 4)};
(
SynthDef(\test, {|out = 0, amp = 0.7|
	var sig, env;

	env = Env.perc(0.01, 0.2, amp).ar(doneAction: 2);

	sig = SinOsc.ar(
		{rand(200, 800)!2}
	);

	sig = sig * env;

	Out.ar(0, sig);
}).add;

)
(
Tdef(\test1, {
	loop {
		1.0.rand.wait;
		Synth(\test);
	}
}).play;
)

rand