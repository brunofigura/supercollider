//-------1.IDEE: alle Ndefs spielen gleichzeitig und ein Ndef übernimmt das "arrangment"

//NDEF mischer

// zufallsort der Obertonreihe
o = [1, 2, (3/2), (4/3), (5/4), (6/5), (7/6), (8/7), (9/8)]

//sinuston

(
Ndef(\Bordun1, {|freq = 440, amp = 0.05|
	SinOsc.ar(freq) ! 2 * amp }).play;)


(
Ndef(\pattern1, {|freq = 440, dur = 1, amp= 0.2|
	var sig, env, trig, step;

	trig = LFPulse.ar(dur);
	step = TChoose.kr(trig, o);
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(freq * step) * env;
	sig = sig ! 2 * amp;
}).play;
)

(
Ndef(\Bordun2, {|freq = 453.47, amp = 0.05|
	SinOsc.ar(freq) ! 2 * amp }).play;)


(
Ndef(\pattern2, {|freq = 453.47,  dur = 1, amp= 0.2|
	var sig, env, trig, step;

	trig = LFPulse.ar(dur);
	step = TChoose.kr(trig, o);
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(freq * step) * env;
	sig = sig ! 2 * amp;
}).play;

)

