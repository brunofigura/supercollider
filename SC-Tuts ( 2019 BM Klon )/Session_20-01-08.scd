
// Value Pattern:
// 0 5 6 9 0 5 6

// Pbind "bindet" die einzelnen Value Patterns zu einem Event-Pattern zusammen
// (\note, 0)-> (\note, 5) -> (\note...

// MIDI
// OSC
// SendReply

// Distortion x
// Pitch Shifting x
// Pisound
// MIDI Daten importieren x
// MIDI Input x
// Transient Detection
// Looper

s.options.hardwareBufferSize_(128);
s.reboot
// buffer laden:
b = Buffer.read(s, "_samples/oa_piano_loop_bliss_90_G#.wav".resolveRelative);
// testen:
b.plot;
b.play;
b.numFrames;

(
Ndef(\x, {
	var imp, pos;
	imp = Dust.ar(MouseX.kr(0.5, 12));
	pos = TRand.ar(0.0, 1, imp);
	PlayBuf.ar(2, b, 1 * BufRateScale.kr(b), imp, pos * BufFrames.kr(b), 1);
}).play;
)

Ndef(\x).stop;

s.prepareForRecord("export/not noto 02.wav".resolveRelative, 2);
s.record;
s.stopRecording

b = Buffer.read(s, "_samples/oa_piano_loop_bliss_90_G#.wav".resolveRelative);
c = Buffer.read(s, "_samples/oa_fx_loop_knock_90.wav".resolveRelative);

c.play;

// zwei sounds
(
Ndef(\x, {
	var imp, pos, soundA, soundB;
	imp = Dust.ar(MouseX.kr(0.5, 12));
	pos = TRand.ar(0.0, 1, imp);
	soundA = PlayBuf.ar(2, b, 1 * BufRateScale.kr(b), imp, pos * BufFrames.kr(b), 1);
	soundB = PlayBuf.ar(2, c, 1 * BufRateScale.kr(b), imp, pos * BufFrames.kr(b), 1);
	Select.ar(TRand.ar(0, 1, imp).round, [soundA, soundB])
}).play;
)

Ndef(\x).stop;

// M I D I
// Initialisieren:
MIDIClient.init;
MIDIIn.connect(0, 1);
s.latency_(0);
s.reboot;
s.latency

(
MIDIdef.cc(\nano_test, {arg ...args;
	args.postln;
})
)

MIDIdef(\nano_test).free;

(
Ndef(\x, {|cutOff=500, freq|
	RLPF.ar(Saw.ar(freq), cutOff) * 0.1 ! 2;
}).play;
)



(
MIDIdef.cc(\nano_cc, {|val, ccNum, chan|
	switch(ccNum,
		0, {
			Ndef(\x).set(\cutOff, val.lincurve(0, 127, 50, 6000));
		},
		1, {
			Ndef(\x).set(\freq, val.lincurve(0, 127, 50, 600));
		}
	);

})
)

MIDIdef(\nano_cc).free;




(
var synth;
MIDIdef.cc(\nano_cc, {|val, ccNum, chan|
	switch(ccNum,
		32, {
			if(val == 127){
				synth = Synth(\x, [\freq, rrand(100, 700)])
			}{
				synth.set(\gate, 0);
			}
		};
	);
})
)

MIDIdef.noteOn(\nano_on, {|note, vel, chan|
	switch(note,
		36, { /* hier starten wir unseren synth */ }
	);
});
MIDIdef.noteOff(\nano_off, {|note, vel, chan|
	switch(note,
		36, { /* hier stoppen wir unseren synth */ }
	);
});

(
SynthDef(\x, {|out, freq=100, amp=0.1, gate=1, cutoff=5000|
	var sig, env;
	env = Env.adsr(0.3, 0.3, 0.5, 1).ar(Done.freeSelf, gate);
	sig = RLPF.ar(Saw.ar(freq), cutoff * env.linlin(0, 1, 1, 2)) * env;
	Out.ar(out, sig * amp ! 2)
}).add
)

a = Synth(x, [\freq, 100])



SimpleMIDIFile





// Quark wslib

// read it
m = SimpleMIDIFile.read( "_samples/fugue1.mid".resolveRelative );

// play it (cmd-. to stop)
m.p.play; // takes a few seconds to start because this midifile starts with a rest


m.p

// play it with another instrument
(
SynthDef( "organ", { |freq = 440, sustain = 1, amp = 0.1|
        var sig;
        sig = LFPar.ar( freq * [1,2,3,5], 0, amp/[2,4,5,7] ) >> LFSaw.ar(10) * 100;
        Out.ar( 0, Env([0,1,1,0], [0.025,sustain,0.025]).kr(2) * sig.dup )
}).add;
);

x = m.p( \s0 ).play;
x.stop;

TempoClock.tempo = 16

(
SynthDef(\s0, {|out, freq, modFreq=10, amp=0.1, sustain=0.03, pan=0|
	var env, sig, mult;
	mult = 1000;
	env = Env.perc(sustain/3, sustain).ar(2);
	sig = (Saw.ar(freq/2) * mult) << (LFSaw.ar(freq * modFreq) * mult);
	sig = sig / mult;
	sig = Pan2.ar(sig, pan).tanh * env * amp;
	Out.ar(out, sig);
}).add;
)




" An\" fuerung\"szeichen ".class


// P I T C H S H I F T I N G

b = Buffer.read(s, "_samples/oa_piano_loop_bliss_90_G#.wav".resolveRelative);
b.play;
(
Ndef(\pitch, {
	var in, sig;
	in = PlayBuf.ar(2, b, rate: BufRateScale.kr(b), loop: 1);
	sig = PitchShift.ar(in,
		windowSize: 0.5,
		pitchRatio: 0.25,
		pitchDispersion: 0.01,
		timeDispersion: 3
	) * 5;
	sig.tanh;
}).play;
)

// D I S T O R T I O N
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).tanh, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).sin, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).tan, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).cos, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).cosh, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).sinh, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).sinh, mul:0.4).tanh.scope}).play;
Ndef(\x, { LeakDC.ar((SinOsc.ar(100) * MouseX.kr(0.7, 7)).fold(-1, 1), mul:0.4).tanh.scope}).play;

Ndef(\x, { CrossoverDistortion.ar(SinOsc.ar(100),1, 0.3) }).play;
Ndef(\x, { Disintegrator.ar(SinOsc.ar(100), 0.6, 2) }).play;
Ndef(\x, { Disintegrator.ar(SinOsc.ar(100), 0.6, 2) }).play;
Ndef(\x, { SinOsc.ar(100).round(MouseX.kr(0, 0.5)).scope }).play;
Ndef(\x, { Latch.ar(Saw.ar(100), Impulse.ar(MouseX.kr(20000, 50))).round(MouseY.kr(0, 0.5)).scope }).play;

// L O O P E R
b = Buffer.alloc(s, 4 * s.sampleRate, 1);
(
Ndef(\x, {
	var in, rec, play, imp, speaker;
	speaker = Dseq([-1, 1], inf);
	imp = Impulse.ar(1/4);
	in = SoundIn.ar(0);
	rec = RecordBuf.ar(in, b, 0.99 * BufFrames.kr(b), 1, 0);
	play = PlayBuf.ar(1, b, 0.5, loop: 1);
	Pan2.ar(play, Demand.ar(imp, 0, speaker));

}).play;
)

Ndef(\x).stop;


/// A N F A N G
(
SynthDef(\rec, {|buf|
	var in, rec;
	in = SoundIn.ar(0);
	rec = RecordBuf.ar(in, buf, 0, 1, 0, doneAction: 2);
}).add;

SynthDef(\play, {|out, buf|
	var play;
	play = PlayBuf.ar(1, buf, 1, loop: 0, doneAction: 2);
	Out.ar(out, play)
}).add;
)

(
~numSpeakers = 2;
~length = 2;
~bufs = (~numSpeakers + 1).collect{
	Buffer.alloc(s, ~length * s.sampleRate);
};
)
["a", "b", "c", "d"].rotate(1)
(
var recSynth, playSynth;
playSynth = Array.new(~numSpeakers);
Tdef(\looper, {
	inf.do{|iteration|
		playSynth.do{|item| item.postln; item.free };
		~bufs = ~bufs.rotate(1);
		recSynth = Synth(\rec, [\buf, ~bufs[~numSpeakers].postln]);
		playSynth = ~numSpeakers.collect{|i|
			Synth(\play, [\buf, ~bufs[i], \out, i]);
		};
	~length.wait;
	};
};
).play
)

(
var recSynth, playSynth;
playSynth = Array.new(~numSpeakers);
Tdef(\looper, {
	inf.do{|iteration|
		playSynth.do{|item| item.postln; item.free };
		~bufs = ~bufs.rotate(1);
		if(iteration < ~numSpeakers){
			recSynth = Synth(\rec, [\buf, ~bufs.last]);
		}{
			~bufs.last.zero;
		};
		playSynth = ~numSpeakers.collect{|i|
			Synth(\play, [\buf, ~bufs[i], \out, i]);
		};
	~length.wait;
	};
};
).play
)




(
var a = 1;
a.postln
)

Array.new(3);
[1, 2, "a"].do{|item| item.postln;}
3.collect{}

a = ["a", "b", "c"]
a.removeAt(0)

a = [1, 2, 3, 4]

a = a.collect{|item, i|
	item * i;
}

























