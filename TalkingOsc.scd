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
w = Bus.alloc();
x = Bus.alloc();
y= Bus.alloc();
z = Bus.audio();
)
//--------------2.SynthDef ausführen----------

(
SynthDef(\play, {arg out;
	var trig, sig, sig1, sig2, sig3, sig4;
	trig = Impulse.ar(0.5);

	sig = PlayBuf.ar(1, a, 1, 1, 30000, 1, 2 );

	sig1 = BPF.ar(sig, 800, 0.1);
	sig2 = BPF.ar(sig, 1900, 0.1);
	sig3 = BPF.ar(sig, 3000, 0.1);
	sig4 = BPF.ar(sig, 4500, 0.1);

	Out.ar(x, sig1 ! 2);
	Out.ar(y, sig2 ! 2);
	Out.ar(z, sig3 ! 2);
	Out.ar(w, sig4 ! 2);

	//Out.ar(out, sig ! 2)
}).add;)

//----------3. Ndef asuführen:

(
Ndef(\1, {
	var in1,in2,in3,in4, sig, sig1, sig2, sig3, sig4 , freq1, freq2, freq3, freq4, amp = 0.7;

	in1 = In.ar(x, 2);
	in2 = In.ar(y, 2);
	in3 = In.ar(z, 2);
	in4 = In.ar(w, 2);

	freq1 = Pitch.kr(in1, 800, 100, 1000);
	freq2 = Pitch.kr(in2, 1900, 1200, 2400);
	freq3 = Pitch.kr(in3, 3000, 2600, 3200);
	freq4 = Pitch.kr(in4, 4500, 3600, 5000);

	sig1 = SinOsc.ar(freq1) * Amplitude.ar(in1) * 1.5;
	sig2 = SinOsc.ar(freq2) * Amplitude.ar(in2) * 1.5;
	sig3 = SinOsc.ar(freq3) * Amplitude.ar(in3) * 1.5;
	sig4 = SinOsc.ar(freq4) * Amplitude.ar(in4) * 1.5;

	sig = Splay.ar([sig1, sig2, sig3, sig4], 2)
}).play;
)

//--------------4. Synthdef ( Buffer ) abspielen

Synth(\play);





// aufnahme

a = Buffer.alloc(s, 5 * s.sampleRate, 1);

(
SynthDef(\rec, {|buf|
	var in;
	in = SoundIn.ar(0);
	RecordBuf.ar(in, buf, loop: 0, doneAction: Done.freeSelf);
}).add;
)

Synth(\rec, [\buf, a]);



(
Ndef(\play, {
	PlayBuf.ar(1, a, loop:1);
});

// bandfilter
Ndef(\bandpass, {
	var in = Ndef.ar(\play);
	var freqs = [800, 1900, 3000, 4500];
	BPF.ar(in, freqs, 0.1);
});

// resynthese
Ndef(\resynthese, {
	var signals, bands;
	var freqs = [800, 1900, 3000, 4500];
	var pitches;
	bands = Ndef.ar(\bandpass);
	signals = bands.collect { |signal, i|
		var p, freq, foundFreq, hasFound, amp;
		freq = freqs[i];
		p = Pitch.kr(signal, initFreq: freq, minFreq: freq * 0.6, maxFreq: freq * 1.4);
		foundFreq = p[0];
		hasFound = p[1];
		amp = Amplitude.ar(signal);
		SinOsc.ar(foundFreq) * amp * hasFound.lag(0.01)
	};
	Splay.ar(signals)
}).play
)



// alternativ:


(
Ndef(\play, {
	PlayBuf.ar(1, a, loop:1);
});

// bandfilter
Ndef(\bandpass, {
	var in = Ndef.ar(\play);
	var freqs = [800, 1900, 3000, 4500];
	BPF.ar(in, freqs, 0.1);
});

// analyse: kanäle sind abwechselnd: freq, amp, freq, amp
Ndef(\pitchanalyse, {
	var freqs = [800, 1900, 3000, 4500];
	var bands = Ndef.ar(\bandpass);
	var output = List.new;
	bands.collect { |signal, i|
		var freq = freqs[i];
		var p = Pitch.kr(signal, initFreq: freq, minFreq: freq * 0.6, maxFreq: freq * 1.4);
		var foundFreq = p[0];
		var hasFreq = p[1].lag(0.01);
		var amp = Amplitude.kr(signal);
		[foundFreq, hasFreq * amp]
	}.flatten(1);
});


Ndef(\resynthese, {
	var freqs, amps, pitchData;
	pitchData = Ndef.ar(\pitchanalyse).clump(2); // wieder zurück ins format [[freq, hasFreq], ...]
	pitchData = pitchData.flop; // dann ins format [[freqs..], [hasFreqs...]]
	freqs = pitchData.at(0);
	amps = pitchData.at(1);
	SinOsc.ar(freqs) * amps * 20
}).play;
)
