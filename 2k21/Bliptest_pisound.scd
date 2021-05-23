(Tdef(\blips, {
	{SinOsc.ar(1000) * Env.perc().ar(2)}.play;
	0.25.wait;
	{SinOsc.ar(500) * Env.perc().ar(2)}.play;
	0.25.wait;
	{SinOsc.ar(1500) * Env.perc().ar(2)}.play;
	0.25.wait;
	{SinOsc.ar(1100) * Env.perc().ar(2)}.play;
})
)

Tdef(\blips).play;
