~reverb = Bus.audio(s, 2);
~master = Bus.audio(s, 2);

(
SynthDef(\arp, {|out, freq = 300, tempo = 12, arp_rel = 0.2 |
	var sig, env, stabs, mod, fsig;

	stabs = LFPulse.ar(tempo, 0, arp_rel);
	env = Env.perc(0.1, 5).ar(2);
	sig = Saw.ar(freq) * env * stabs;
	fsig = MoogFF.ar(sig, stabs.linexp(0, 1, 100, 2000), 1.5 );
	Out.ar(~reverb, fsig ! 2);
	Out.ar(~master, fsig ! 2);
}).add;
)

a = Synth(\arp);

(
Pbind([

])
)

(
Ndef(\reverb, {
	var in, sig;
	in = In.ar(~reverb, 2);
	sig = FreeVerb.ar(in, 1, SinOsc.ar(3, 3));
}).play(~master);
)


(
Ndef(\master, {
	var in, sig;
	in = In.ar(~master, 2);
	sig = in * 0.5;
}).play();
)

(
Ndef(\soundin, {
	var in;
	in = SoundIn.ar(0);
	DelayN.ar(in, 0.3, 0.3
	);
})
)

Quarks.gui