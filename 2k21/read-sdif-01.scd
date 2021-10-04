

(
var a;
q = ();
a = SDIFFile.read("data/Sdiftest1(EI).sdif".resolveRelative);
q.partials = SPEARPartials.newFrom(a);
q.partials.addFadeOut(0.3);
x = q.partials.array;
x.sort { |a, b| a.meanAmp > b.meanAmp };
)


// information
q.partials.maxNumFrames // max time steps

z = q.partials.array.at(0); // take one partial

z.deltas;
z.freqs;
z.amps;
z.phases;


z.maxAmp;
z.minAmp;
z.meanAmp;
z.minFreq;
z.maxFreq;
z.meanFreq;

z.startTime;
z.endTime;
z.duration;
z.numFrames;


q.partials.array.collect { |p| p.startTime }.plot


// one can sort the whole array according to various properties:
// first, pick out a copy:

y = q.partials.copy;

y.sort { |a, b| a.meanAmp > b.meanAmp };
y.sort { |a, b| a.duration > b.duration };


y = y.sort { |a, b| a.meanAmp > b.meanAmp }.keep(64); // get the loudest 64
y = y.sort { |a, b| a.duration > b.duration }.keep(32); // sort these by duration and keep the longest 32
y.sort { |a, b| a.startTime > b.startTime }; // sort these by start time


(
var maxNumFrames = q.partials.maxNumFrames;// may take a while

SynthDef(\sin, { |out, pan, sustain, amp = 0.1, speed = 1, harmonic = 1, detune = 0, hlag = 0.03, dlag = 0.03|
	var deltas = \deltas.ir(0 ! maxNumFrames);
	var freqs = \freqs.ir(0 ! maxNumFrames);
	var amps = \amps.ir(0 ! maxNumFrames);
	var phases = \phases.ir(0 ! maxNumFrames);
	// let time run a little over, so we can free below:
	var time = Phasor.kr(0, speed * ControlDur.ir, 0, sustain + ControlDur.ir);
	var freq = IEnvGen.kr(Env(freqs, deltas), time);
	var phase = IEnvGen.kr(Env(phases, deltas), time);
	var mul = IEnvGen.kr(Env(amps, deltas), time) * (amp * 10);
	var fadeEnv = IEnvGen.kr(Env.linen(0.01, sustain - 0.06, 0.05), time);
	var signal;

	// free when over time
	FreeSelf.kr(time > sustain);

	mul = mul * (freq > 0.01).lag; // just to be safe
	mul = mul * fadeEnv;

	freq = harmonic.lag(hlag) * freq + detune.lag(dlag);

	signal = Pan2.ar(SinOsc.ar(freq, phase, mul), pan);

	Out.ar(out, signal)

}).add
)


(
y = x.keep(37);
y.sort { |a, b| a.startTime < b.startTime };


q.synths = List.new;
q.synthPartials = List.new; // for each synth, the corresponding partial


Tdef(\x, {
	var delta, time = y.first.startTime; // start immediately with the first one
	y.do { |p|
		var synth;
		delta = p.startTime - time;
		time = p.startTime;
		synth = Synth(\sin, [
			freqs: p.freqs,
			amps: p.amps,
			deltas: p.deltas,
			sustain: p.duration
		]);
		synth.onFree {
			q.synths.remove(synth);
			q.synthPartials.remove(p);
		};
		q.synths.add(synth);
		q.synthPartials.add(p);
		delta.wait;
	}
}).play;
)

q.synths.do { |x| x.set(\detune, 30.rand) };
q.synths.do { |x| x.set(\harmonic, 1.2, \hlag, 7) };
q.synths.do { |x| x.set(\speed, 0.3) };

// pause the progression
(
Tdef(\x).pause;
q.synths.do { |x| x.set(\speed, 0) };
)

// how to do something with a selection of partials?
// first, we select the indices whose synths we want to change
q.indices = q.synthPartials.selectIndices { |p| p.meanFreq < 500 }

// then selecte the synths with these indices
q.synths[q.indices].do { |x| x.set(\harmonic, 2) }; // set all partials below 500 Hz one octave higher
q.synths[q.indices].do { |x| x.set(\harmonic, 1) }; // set all partials below 500 Hz back.

// one could also generate indices that represent a specific order
// for example the order of the meanFreq
q.indices = q.synthPartials.order { |a, b| a.meanFreq < b.meanFreq }.postln;

// and now set the detune relative to the order
q.synths[q.indices].do { |x, i| x.set(\detune, i * 10) };

// reset them
q.synths.do { |x| x.set(\detune, 0) };

// amps auffächern
(
fork {
	q.synths.do { |x| x.set(\amp, 0) };
	q.synths.do { |x|
		x.set(\amp, 0.1);
		0.5.wait;
	};
};
)


(
Tdef(\x).resume;
q.synths.do { |x| x.set(\speed, 1) };
)



///////////////////////////////
// test with slice

x = q.partials.cutSlice(0.1, 1.7).array;
x.sort { |a, b| a.meanAmp > b.meanAmp };

// then use the Tdef above.





/// a Klank synthdef
(
var n = 612;
var name = \spectrum_klank_ ++ n.asInteger;
name.postln;
SynthDef(name, { |out, amp = 0.1, sustain = 1, numPartials = 128, pan = 0|
	var freqs, amps, dts, sig, exciter;

	freqs = \freqs.ir(300 ! n);
	amps = \amps.ir(1 ! n);
	dts = \dts.ir(1 ! n);
	amps = amps.collect { |x, i| (i < numPartials) * x };

	amps = amps * AmpCompA.ir(freqs);
	dts = dts.max(10/freqs);

	exciter = Impulse.ar(0);
	exciter = Decay2.ar(Impulse.ar(0), 0.0002, 0.001, WhiteNoise.ar(0.2, 1));

	sig = Klank.ar(`[freqs, amps, dts], exciter, decayscale: sustain);
	sig = HPF.ar(sig, 20);
	sig = sig * amp;

	DetectSilence.ar(sig, doneAction: 2);

	sig = Pan2.ar(sig, pan);

	OffsetOut.ar(out, sig)

}).add
)

Synth(\spectrum_klank_612, [\freqs: { exprand(200, 2000) } ! 612], numPartials: 612);

(instrument: \spectrum_klank_612, freqs: [{ exprand(200, 12000) } ! 612], numPartials: 612, dts: 2).play;



// Ich würde gern die Freqs über N-Channels verteilen, zB mit SplayAz

// dann musst du die frequenzen aufteilen auf verschiedene Synths.





// eine Variante
(
var maxNumFrames = q.partials.maxNumFrames;// may take a while

SynthDef(\sin, { |out, pan, sustain, amp = 0.1, speed = 1, harmonic = 1, detune = 0, hlag = 0.03, dlag = 0.03|
	var deltas = \deltas.ir(0 ! maxNumFrames);
	var freqs = \freqs.ir(0 ! maxNumFrames);
	var amps = \amps.ir(0 ! maxNumFrames);
	var phases = \phases.ir(0 ! maxNumFrames);
	// let time run a little over, so we can free below:
	var time = Phasor.kr(0, speed * ControlDur.ir, 0, sustain + ControlDur.ir);
	var freq = IEnvGen.kr(Env(freqs, deltas), time);
	var phase = IEnvGen.kr(Env(phases, deltas), time);
	var mul = IEnvGen.kr(Env(amps, deltas), time) * (amp * 10);
	var fadeEnv = IEnvGen.kr(Env.linen(0.01, sustain - 0.06, 0.05), time);
	var signal;

	// free when over time
	FreeSelf.kr(time > sustain);

	mul = mul * (freq > 0.01).lag; // just to be safe
	mul = mul * fadeEnv;

	freq = harmonic.lag(hlag) * freq + detune.lag(dlag);

	signal = Pan2.ar(Ringz.ar(LPF.ar(Dust.ar(6, 3), 800) + Impulse.ar(0), freq, sustain, mul), pan);

	Out.ar(out, signal)

}).add
)










////////////////////////////// TODO, doesn't work yet

a = SDIFFile.read("2.sdif".resolveRelative);
(
f = { |sdifFile, ndef|
	fork {
		var currentTime;
		sdifFile.frames.keep(3).do { |frame|
			var parameters = frame.matrices[0].array; // for spear that's fine for now
			var ids, time, p, order;
			time = frame.time;
			if(frame.time != -inf) {
				p = parameters.flop;
				order = p[1].order;
				ndef.set(\freqs, [p[1][order]], \amps, [p[2][order]]);
				if(currentTime.notNil) {
					(time - currentTime).wait;
				};
				currentTime = time;
			}
		}
	}
};
)

(
var n = 500;
Ndef(\x, {
	var freqs, amps, dts;
	freqs = \freqs.kr(0 ! n, 0.02);
	amps = \amps.kr(0.1 ! n, 0.02);
	dts = \dts.kr(1 ! n);
	freqs[0].poll;
	amps = amps.collect { |x, i| x * (freqs[i] > 1) };
	Splay.ar(SinOsc.ar(freqs, 0, amps)) * 0.1
}).play
)

f.(a, Ndef(\x));


