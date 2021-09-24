// Audio In Out
// SoundIn
// Buffer

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	DelayL.ar(in, 0.3, 0.3);
}).play;
)

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	DelayL.ar(in, 2, 0.3) * SinOsc.ar(700);
}).play;
)

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	DelayL.ar(in, 2, SinOsc.ar(7).range(0.3, 0.3035));
}).play;
)

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	DelayL.ar(in, 2, SinOsc.ar(500).range(0.3, 0.301));
}).play;
)

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	PitchShift.ar(in, 0.2, [0, 3, 7, 10].midiratio, 0.05, 0.05).mean;
}).play
)

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	PitchShift.ar(in, 0.2, [-0.15, 0.15].midiratio, 0.05, 0.05);
}).play
)

(
Ndef(\in, {
	var in;
	in = SoundIn.ar(0);
	DelayL.ar(in, 2, SinOsc.ar([0.3, 0.31]).range(0.3, [0.301, 0.305, 0.307])).mean;
}).play;
)

b = Buffer.alloc(s, 2 * s.sampleRate, 1);
c = Buffer.alloc(s, 3 * s.sampleRate, 1);

(
SynthDef(\rec, {|buf|
	var in;
	in = SoundIn.ar(0);
	RecordBuf.ar(in, buf, loop: 0, doneAction: Done.freeSelf);
}).add;
)

Synth(\rec, [\buf, b]);
Synth(\rec, [\buf, c]);

Ndef(\play).reshaping_(\elastic);

(
Ndef(\play, {
	// Splay "fächert" mir ein Multichannel Array anstatt auf einzelne Outputs im Stereofeld auf
	Splay.ar(PlayBuf.ar(1, c, (0.5, 0.505 .. 0.6), 1, 0, 1));
}).play;
)

(0.5, 0.505 .. 0.6).size
(0.5, 0.505 .. 1).size

(
// cutup 1
Ndef(\play, {
	var trig, sig;
	trig = Impulse.ar(12);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(1, c, 0.5, trig, BufFrames.kr(c) * TRand.ar(0, 1.0, trig), 1);
}).play;
)

(
// cutup 2 (ohne Klick)
Ndef(\play, {
	var trig, sig, env, freq;
	freq = 12;
	trig = Impulse.ar(freq);
	env = Env([0, 1, 0], [0.5, 0.5] * (1/freq)).ar(0, trig);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(1, c, 0.5, trig, BufFrames.kr(c) * TRand.ar(0, 1.0, trig), 1);
	sig * env;
}).play;
)

(
// cutup 2 (ohne Klick kurzer Fade)
Ndef(\play, {
	var trig, sig, env, freq;
	freq = 6;
	trig = Impulse.ar(freq);
	env = Env([0, 1, 1, 0], [0.005, 0.99, 0.005] * (1/freq)).ar(0, trig);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(1, c, 0.5, trig, BufFrames.kr(c) * TRand.ar(0, 1.0, trig), 1);
	sig * env;
}).play;
)

// resolveRelative erlaubt es uns das Sample mit einem Relativen Pfad zu laden
p = "_samples/oa_piano_loop_bliss_90_G#.wav".resolveRelative;
d = Buffer.read(s, p);
d.play

(
// cutup 1
Ndef(\play, {
	var trig, sig;
	trig = Impulse.ar(6);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(1, d, 1, trig, BufFrames.kr(c) * TRand.ar(0, 1.0, trig), 1);
}).play;
)

(
// cutup 1
Ndef(\play, {
	var trig, sig;
	trig = Impulse.ar([3, 5] / 3);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(1, d, 1, trig, BufFrames.kr(c) * TRand.ar(0, 1.0, trig), 1).mean;
}).play;
)

(
// cutup die verbotene variante
Ndef(\play, {
	var trig, sig, seq;
	seq = Demand.ar(Impulse.ar(0.5), 0, Dseq([[3,5], [2,3], [7, 11]], inf));
	trig = Impulse.ar(seq / 3);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(2, d, 1, trig, BufFrames.kr(d) * TRand.ar(0, 1.0, trig), 1).mean;
}).play;
)

(
// cutup die erlaubte variante
//            Das # Symbol deklariert das Array als "Literal"-Array und
// 			  erlaubt das übergeben von Arrays als Argumenten
Ndef(\play, {|div=#[1, 2]|
	var trig, sig, seq;
	trig = Impulse.ar(div / 2);
	// BufFrames gibt uns die Anzahl der Frames
	// TRand gibt einen zufälligen Wert aus, sobald es einen Trigger kriegt
	sig = PlayBuf.ar(2, d, 1, trig, BufFrames.kr(d) * TRand.ar(0, 1.0, trig), 1).mean;
}).play;
)

(
Tdef(\seq, {
	var seq;
	seq = [[3,5], [2,3], [7,8]];
	inf.do{|i|
		Ndef(\play).set(\div, seq[i % seq.size]);
		2.wait;
	};
}).play;
)

// literals
12
"hallo"
\symbol
#[1, 2, 3]

s.prepareForRecord("export/not noto 01.wav".resolveRelative, 2);
s.record;
s.stopRecording

"export/not noto 01.wav".resolveRelative





































