s.boot;

(
SynthDef.new(\blip, {
	var sig, env;
	sig = Saw.ar(\freq.ir(1000));
	env = Env(
		[0, 1, 1, 0],
		[\atk.ir(0), \sus.ir(0.05), \rel.ir(0)],
		[\atkcrv.ir(2), \relcrv.ir(-2)]
	).ar(2);

	sig = sig * env;
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(0.3));

	Out.ar(\out.ir(0), sig);
	Out.ar(\outfx.ir(0), sig * \send.ir(-30).dbamp);
}).add;
)

Synth(\blip, [\freq, 300]);
(
Tdef.new(\key, {
	loop{
		Synth(\blip, [\freq, 34.midicps, \rel, 0.4, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
		Synth(\blip, [\freq, 34.midicps, \rel, 0.4, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
		Synth(\blip, [\freq, 36.midicps, \rel, 0.2, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
		Synth(\blip, [\freq, 32.midicps, \rel, 0.4, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
		Synth(\blip, [\freq, 34.midicps, \rel, 0.4, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
		Synth(\blip, [\freq, 34.midicps, \rel, 0.1, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
		Synth(\blip, [\freq, 34.midicps, \rel, 0.4, \relcrv, 0, \pan, 	1.0.rand2]);
		0.2.wait;
}}).play;


Tdef.new(\key2, {
	loop{
		Synth(\blip, [\freq, 60.midicps, \rel, 1.2, \relcrv, 0, \pan, 	1.0.rand2]);
		2.wait;
		Synth(\blip, [\freq, 63.midicps, \rel, 0.8, \relcrv, 0, \pan, 	1.0.rand2]);
		2.wait;
		Synth(\blip, [\freq, 65.midicps, \rel, 1.5, \relcrv, 0, \pan, 	1.0.rand2]);
		2.wait;
		Synth(\blip, [\freq, 61.midicps, \rel, 1.5, \relcrv, 0, \pan, 	1.0.rand2]);
		2.wait;
}}).play;
)

~buf = Buffer.read(s,"B:/Musik/AA-eigenes/tests/fieldrec(eq+c).wav" );

(
SynthDef.new(\sample, {
	var sig, env;
	sig = PlayBuf.ar(2, \buf.ir(0), BufRateScale.ir(\buf.ir(0))*\rate.ir(1), 1, \spos.ir(0));

	env = Env(
		[0, 1, 1, 0],
		[\atk.ir(0), \sus.ir(0.5), \rel.ir(0.7)],
		\lin
	).ar(2);

	sig = sig * env;
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(0.4));

	Out.ar(\out.ir(0), sig);
	Out.ar(\outfx.ir(0), sig * \send.ir(-30).dbamp);
}).add;
)
(
Synth(\sample, [\buf, ~buf,
	\rate, [0.5, 0.6]]
);

)