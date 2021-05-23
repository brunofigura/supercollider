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
		Synth(\blip, [\freq, 68.midicps, \rel, 1.2, \relcrv, 0, \pan, 	0.5.rand2]);
		2.wait;
		Synth(\blip, [\freq, 63.midicps, \rel, 0.8, \relcrv, 0, \pan, 	0.5.rand2]);
		2.wait;
		Synth(\blip, [\freq, 65.midicps, \rel, 1.5, \relcrv, 0, \pan, 	0.5.rand2]);
		2.wait;
		Synth(\blip, [\freq, 61.midicps, \rel, 1.5, \relcrv, 0, \pan, 	0.5.rand2]);
		2.wait;
}}).play;
)


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

~b0 = Buffer.read(s, "B:/Samples/Andrew Huang - WMD Percussion/01 Kick/AndrewHuang_WMD_kick_one_shot_alias_1.wav");
~b1 = Buffer.read(s,"B:/Samples/Andrew Huang - WMD Percussion/06 Perc/AndrewHuang_WMD_perc_one_shot_brake_3.wav" );
~b2 = Buffer.read(s, "B:/Samples/Andrew Huang - WMD Percussion/07 FX/AndrewHuang_WMD_fx_one_shot_3.wav");
~b3 = Buffer.read(s, "B:/Samples/Andrew Huang - WMD Percussion/07 FX/AndrewHuang_WMD_fx_one_shot_10.wav");
~b4 = Buffer.read(s, "B:/Samples/Andrew Huang - WMD Percussion/08 Impacts/AndrewHuang_WMD_fx_impact_one_shot_noise_4.wav");
~b5 = Buffer.read(s, "B:/Samples/Andrew Huang - WMD Percussion/08 Impacts/AndrewHuang_WMD_fx_impact_one_shot_slowdown_5.wav");
(
Synth(\sample, [\buf, ~b1,
	\rate, 1]
);
)

(
SynthDef(\vrb, {
	var sig, wet;
	sig = In.ar(\in.ir(0), 2);
	sig = FreeVerb2.ar(sig[0], sig[1],mix: 1, room: 0.99, damp: 0.99);
	sig = LPF.ar(sig, 900);
	Out.ar(\out.ir(0), sig);
}).add;
)

//Order of exec

s.newBusAllocators // flushes busses
~vrbBus = Bus.audio(s, 2);

~fxGroup = Group.new;
~reverb = Synth(\vrb, [\in, ~vrbBus], ~fxGroup);


Synth(\blip, [\freq, 1500, \out, 0, \outfx, ~vrbBus, \send, -10]);

Synth(\sample, [\buf, ~b2, \rate, 0.7,]);

Synth(\sample, [\buf, ~b2, \rate, 0.7, \outfx, ~vrbBus, \send, -10]);

(
~sampPat = Pbind(
	\instrument, \sample,
	\dur, 1/8,
	\type, Pwrand([\note, \rest], [0.6, 0.4], inf),
	\buf, Prand([~b0,~b1,~b2,~b3,~b4,~b5], inf),
	\rate, Pwhite(0, 3, inf).midiratio,
	\amp, Pexprand(0.02, 0.5, inf),
	\atk, 0,
	\sus, 0,
	\rel, Pseq([0.2, 0.7, 0.1], inf),
	\out, 0,
	\outfx, ~vrbBus,
	\send, Pwhite(-40, -10, inf),
)
)

~samplePlayer = ~sampPat.play;
~samplePlayer.stop;

(
~blipPat = Pbind(
	\instrument, \blip,
	\dur, Prand([0.2, 0.1, 0.1, 0.4, 0.8, 1.5], inf) * 0.5,
	\freq, 70.midicps,
	\atk, 0,
	\sus, 0,
	\rel, 0.1,
	\out, 0,
	\outfx, ~vrbBus,
	\send, -10
)
)
~blipPlayer = ~blipPat.play;

~blipPlayer.stop;

//next task tweek blipPat und come up with drone Pat

