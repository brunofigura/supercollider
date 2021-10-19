"B:/supercolider-git/supercollider/spear data/trump_whatIsGoingOn.sdif"

(
~sdiffile = SDIFFile.read("B:/supercolider-git/supercollider/spear data/trump_whatIsGoingOn.sdif");
~spearfile = SPEARPartials.newFrom(~sdiffile);
~spearfile.addFadeOut(0.3);
x = ~spearfile.array;

x.collect {|p| p.startTime}.plot;
)


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

Tdef(\x, {
	var delta, time = y.first.startTime; // start immediately with the first one
	x.do { |p|
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
