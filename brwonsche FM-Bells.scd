(~brownschemov = {arg x = 0;
	{x = x + [-1, -0.5,0.5, 1].choose;}
};
)

b = ~brownschemov.value;
(b ! 100).fold(0, 12).plot
(
Ndef(\Bells, {arg time = 60, amp = 0.3;
	var a, sig, env, trig, values, modamtLFO;
modamtLFO = SinOsc.ar(0.33);
a = ~brownschemov.value;
values = a ! 1024;
values.plot;

	trig = Dust.ar(Select.kr(Line.kr(0, 100, time), values.fold(0, 20)));
	env = Env.perc(0.01, 0.4).ar(0, trig);

	sig = SinOsc.ar(440, (SinOsc.ar(503) * modamtLFO)) * env;
	sig = sig * amp;
}).play;
)