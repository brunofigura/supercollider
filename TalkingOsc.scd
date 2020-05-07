//Resynthese

a = Buffer.alloc(s, 5 * s.sampleRate, 1);

(
SynthDef(\rec, {|buf|
	var in;
	in = SoundIn.ar(0);
	RecordBuf.ar(in, buf, loop: 0, doneAction: Done.freeSelf);
}).add;
)

Synth(\rec, [\buf, a]);


//--------------1. Busse ausführen---------------


//busse um die gefilterten Signale hin und her zu schicken
(
x = Bus.audio(s, 2);
y= Bus.audio(s, 2);
z = Bus.audio(s, 2);
)

//--------------2.SynthDef ausführen----------

(
SynthDef(\play, {arg out;
	var trig, sig, siglo, sigmid, sighi;
	trig = Impulse.ar(0.5);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(1, a, 1, 1, 30000, 1, 2 );

	siglo = BPF.ar(sig, 300, 0.4);
	sigmid = BPF.ar(sig,2000, 0.4);
	sighi = BPF.ar(sig, 6000, 0.4);

	Out.ar(x, siglo ! 2);
	Out.ar(y, sigmid ! 2);
	Out.ar(z, sighi ! 2);

	//Out.ar(out, sig ! 2)
}).add;)

//----------3. Ndef asuführen: VORSICHT SEHR LAUT UND SCHRILL!!!!!!

(
Ndef(\1, {
	var sig, sig1, sig2, sig3 , freq1, freq2, freq3, amp = 0.7;

	freq1 = Pitch.kr(x.ar(2), 220, 60, 1000);
	freq2 = Pitch.kr(y.ar(2), 2000, 1000, 4000);
	freq3 = Pitch.kr(z.ar(2), 5000, 4000, 9000);

	sig1 = SinOsc.ar(freq1) * amp;
	sig2 = SinOsc.ar(freq2) * amp;
	sig3 = SinOsc.ar(freq3) * amp;

	sig = Splay.ar([sig1, sig2, sig3], 1)
}).play;
)

//--------------4. Synthdef ( Buffer ) abspielen

Synth(\play);