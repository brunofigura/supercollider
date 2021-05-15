// Für Fragen:
// raffael.seyfried@rsh-duesseldorf.de

(
Ndef(\x, {|freq|
	SinOsc.ar(MouseX.kr(20, 200)) * 0.1 ! 2;
}).play;
)

(
Ndef(\x, {|freq=200|
	SinOsc.ar(freq) * 0.1 ! 2;
}).play;
)

Ndef(\x).set(\freq, MouseX.kr());


Ndef(\x).set(\freq, Ndef(\y, { MouseY.kr(20, 200) }));


Ndef(\comp, {|in|

})

Ndef(\comp).set(\in, Ndef... )


Out.ar(
)

s.options.numInputBusChannels;
s.options.numInputBusChannels;


// wie finden wir heraus ob ein pattern zuende gespielt hat?


p = Pbind(\degree, Pseq([0, 1, 2, 3, 4], 1), \callback, { "done".postln });
a = p.asStream;
a.next(())

p.play

p.play
p.isPlaying

().play;


// Additive Synthese
// 1. Teiltöne einzeln Kontrollieren

(
SynthDef(\add, {|out, gate=1, freq=200, amp=0.1|
	var envAmp, sig, partials, numPartials;
	partials = (3, 5 .. 12);
	partials = [1, partials].flat;
	numPartials = partials.size;
	envAmp = Env.adsr(0.01, 0.3, 0.5, 1).ar(2, gate);
	sig = DynKlang.ar(`[
		partials, // freqs
		1/partials, // amps
		0, // phases
	], freq) ! 2;
	Out.ar(out, (sig * amp).tanh * envAmp);
}).add;
)


a = Synth(\add);
a.set(\gate, 0)

a = (3, 5 .. 12)
[1, a].flat


(
SynthDef(\add, {|out, gate=1, freq=200, ratio, amp=0.1, partialStretch=0|
	var envAmp, sig, partials, numPartials;
	partials = (2, 3 .. 12);
	partials = partials + (partials * partialStretch);
	partials = [1, partials].flat;
	numPartials = partials.size;
	envAmp = Env.adsr(0.01, 0.3, 0.5, 1).ar(2, gate);
	sig = DynKlang.ar(`[
		partials, // freqs
		1/partials, // amps
		0, // phases
	], freq * ratio) ! 2;
	Out.ar(out, (sig * amp).tanh * envAmp);
}).add;
)

gtranspose
(
Pdef(\x, Pbind(
	\instrument, \add,
	\note, 0,
	\ratio, Pseq([1, 2.2], inf),
	\partialStretch, 0.1,
	\legato, 2,
	\dur, 1
)).play;
)

a = [2, 3, 4, 5];
a + (0.1 * a)





(
~dlyBus = Bus.audio(s, 2);
~vrbBus = Bus.audio(s, 2);

Ndef(\vrb, {
	var sig;
	sig = In.ar(~vrbBus, 2);
	sig = JPverb.ar(sig,
		t60: 12, damp: 0, size: 1.2,
		earlyDiff: 0.70, modDepth: 0.3, modFreq: 1,
		low: 0.8, mid: 1, high: 1,
		lowcut: 500, highcut: 3000,
	);
	sig;
}).play;

Ndef(\dly, {
	var sig;
	sig = In.ar(~dlyBus, 2) + LocalIn.ar(2, 0);
	sig = DelayL.ar(sig, 4, [0.4, 0.3] * SinOsc.ar(0.2, 0, 0.005, 1));
	sig = MoogVCF.ar(sig, 5500, 0.3);
	sig = HPF.ar(sig, 200);
	sig = sig.tanh * 0.9;
	LocalOut.ar(sig);
	sig;
}).play;
)

(
SynthDef(\add, {|out, sustain, gate=1, freq=200, amp=0.1|
	var envAmp, sig, partials, numPartials, partialStretch;
	partialStretch = Env([0, 0.5, -0.5], sustain*[0.5, 0.5]).ar();
	partials = (2, 3 .. 12);
	partials = partials + (partials * partialStretch);
	partials = [1, partials].flat;
	numPartials = partials.size;
	envAmp = Env.adsr(3, 0.3, 0.5, 3).ar(2, gate);
	sig = DynKlang.ar(`[
		partials, // freqs
		1/partials, // amps
		0, // phases
	], freq) ! 2;
	sig = (sig * amp).tanh * envAmp;
	Out.ar(~dlyBus, sig * 0.3);
	Out.ar(~vrbBus, sig * 0.5);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\x, Pbind(
	\instrument, \add,
	\scale, Scale.at(\harmonicMinor),
	\degree, Pseq([0, 0, 2, -1, 4], inf),
	\legato, 4,
	\dur, 8
)).play;
)

// 2. Envelopes über die Amplitude der Teiltöne:
(
SynthDef(\add, {|out, gate=1, freq=200, sustain=0.3, amp=0.1|
	var envAmp, envPartials, sig, partials, numPartials, envLength;
	partials = Rand(1.5, 30!5);
	partials = [1, partials].flat;
	numPartials = partials.size;
	envLength = Rand(0.001, sustain!numPartials);
	envPartials = Env.perc(envLength, sustain - envLength).ar;
	envAmp = Env.adsr(0, 0.3, 1, 1).ar(2, gate);
	sig = DynKlang.ar(`[
		partials, // freqs
		(1/partials) * envPartials, // amps
		0, // phases
	], freq) ! 2;
	Out.ar(out, (sig * amp).tanh * envAmp);
}).add;
)

(
Pdef(\x, Pbind(
	\instrument, \add,
	\scale, Scale.at(\harmonicMinor),
	\degree, Pseq([0, 0, 2, -1, 4], inf),
	\legato, 1,
	\dur, 0.5
)).play;
)

// 3. Modulation von einzelnen Teiltönen
(
SynthDef(\add, { |out, amp=0.1, sustain=0.7, freq=400|
	var envAmp, modPartials, sig, partials, numPartials;
	partials = (3, 5 .. 13);
	partials = [1, partials].flat;
	numPartials = partials.size;
	envAmp = Env([0, 1, 1, 0], [0.1, sustain, 0.1]).ar(2);
	modPartials = SinOsc.ar(Rand(0.1, 20!numPartials)) * Rand(0.001, 0.1!numPartials);
	modPartials = modPartials.linlin(-1, 1, 0.5, 1.5);
	sig = DynKlang.ar(`[
		partials * modPartials, // freqs
		1/partials, // amps
		0  // phases
	], freq) * envAmp ! 2;
	// filtering to reduce aliasing
	sig = LPF.ar(sig, 12000);
	Out.ar(out, (sig * amp).tanh );
}).add;
)

(
Pdef(\x, Pbind(
	\instrument, \add,
	\scale, Scale.at(\harmonicMinor),
	\degree, Pseq([0, 0, 2, -1, 4], inf),
	\legato, 1,
	\dur, 0.5
)).play;
)

// 4. Morphen von Obertonspektren
(
SynthDef(\add, {|out, gate=1, freq=200, amp=0.1, sustain=0.3|
	var envAmp, sig, partials, partialsStart, partialsEnd, numPartials;
	partialsEnd = (3, 5 .. 45);
	numPartials = partialsEnd.size;
	partialsStart = Rand(1.5, 30 ! numPartials);
	partials = Env([partialsStart, partialsEnd], sustain).ar;
	partials = [1, partials].flat;
	envAmp = Env.adsr(0.01, 0.3, 0.5, 1).ar(2, gate);
	sig = DynKlang.ar(`[
		partials, // freqs
		1/partials, // amps
		0, // phases
	], freq) ! 2;
	Out.ar(out, (sig * amp).tanh * envAmp);
}).add;
)

rand(1.0 ! 2)

(
Pdef(\x, Pbind(
	\instrument, \add,
	\scale, Scale.at(\harmonicMinor),
	\degree, Pseq([0, 0, 2, -1, 4], inf),
	\legato, 1,
	\dur, 6
)).play;
)

Pdef(\x).stop


























