
Ndef(\y).fadeTime = 3;

(

Ndef(\y, {
	var amp, rates;
	rates = { rrand(0.2, 1.5) } ! 16;
	amp = LFNoise2.kr(rates).range(0.3, 1);
	PinkNoise.ar(amp * 0.1)
	+
	WhiteNoise.ar(amp.scramble * 0.01)

}).play;
)

// 1 100 mousex .1 dust play
(
Ndef(\v, {
	var in = Ndef.ar(\y, 1, 8);
	BPF.ar(in, 900 * 1.5, 0.01) * 70
	* Decay2.ar(Dust.ar(1), 0.1, 2)
}).play;
)


(
{
	var env, dur, freq;
	freq = 1000;
	dur = 49/freq;
	env = Env.sine(dur);
	SinOsc.ar(freq) * env.ar(2) * 0.3
}.play
)

(
Ndef(\x, {
	var env, dur, freq;
	x = MouseX.kr(2, 100, 1);
	freq = 1000;
	dur = x/freq;
	env = Env.sine(dur);
	SinOsc.ar(freq) * env.ar(0, Impulse.ar(1)) * 0.3
}).play
)

(
Ndef(\x, {
	var env, dur, freq;
	x = Env([1, 100, 1], [20, 20], \exp).circle(0).kr;
	freq = 1000;
	dur = x/freq;
	env = Env.sine(dur);
	SinOsc.ar(freq) * env.ar(0, Impulse.ar(1)) * 0.3
}).play
)


(
{
	var env, dur, freq;
	freq = 1200;
	dur = 16/freq;
	env = Env.sine(dur);
	SinOsc.ar(freq, SinOsc.ar(freq * 0.5)) * env.ar(2)
}.play
)



(
{
	var env, dur, freq;
	freq = 200;
	dur = 16/freq;
	env = Env.sine(dur);
	SinOsc.ar(freq) * LFPulse.kr(0.3, 0, 0.1) * 0.1
}.play
)



