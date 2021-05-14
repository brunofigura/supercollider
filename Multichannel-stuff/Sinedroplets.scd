(
Ndef(\oI, {
	var sig, amp = 2, pan, trig, mod, modamt, rhythm;

	modamt = LFSaw.ar(1, 0, 3);
	mod = SinOscFB.ar(\modfreq.ir(1000), 0.2, modamt);

	trig = Dust.kr(\density.ir(1.2));
	sig = SinOsc.ar(\freq.ir(400), mod);

	sig = sig*3;
	sig = sig.tanh;
	sig = sig * amp;
	sig = RLPF.ar(sig, 1000, 2);

	rhythm = Env.perc(releaseTime: Line.ar(0.02, 2, 25, doneAction: 0)).ar(0, trig);


	sig = sig * rhythm;
	sig = FreeVerb.ar(sig, 0.3, 0.9) * 2;

	pan = PanAz.ar(16, sig, 0);
});
)

Ndef(\oI).play;

Ndef(\oI).set(\density, 2, \freq, 63.midicps, \modfreq, 1);
Ndef(\oI).set(\freq, 63.midicps);

Ndef(\oI).free;
{rand(0.8, 3)} ! 12