s.boot;
s.plotTree;
s.meter;
s.options.numOutputBusChannels;

~vrbBus = Bus.audio(s, 2);
~dlyBus = Bus.audio(s, 2);

(
SynthDef.new(\blip, {|out, fund=300, decay=0.2, dens=2|
	var freq = LFNoise0.kr(3).exprange(fund, fund*5).round(150); //rnd 4 partials of 300 Hz
	var sig = SinOsc.ar(freq) * 0.25;
	var trig2= Dust.kr(dens-0.2);
	var trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), [trig, trig2]);
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\vrb, {|in, out = 0, room=0.5|
	var sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig,0.5, room);
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\dly, {|in, out = 0, time=0.3, decay = 1|
	var sig = In.ar(in, 2);
	sig = CombC.ar(sig, 0.5, time, decay);
	Out.ar(out, sig);
}).add;
)

~sourceGroup = Group.new();
~fxGroup = Group.after(~sourceGroup);

10.do{
	Synth.new(\blip,
	[
		\out, ~vrbBus,
		\fund, exprand(60, 300).round(30)
	],
	~sourceGroup
);
}


~sourceGroup.set(\dens, 0.5);

y = Synth.new(\vrb, [\in, ~vrbBus], ~fxGroup);


Synth.new(\dly, [\in, ~dlyBus], ~fxGroup);




~sourceGroup.freeAll();
~fxGroup.freeAll();

