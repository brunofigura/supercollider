//-------1.IDEE: alle Ndefs spielen gleichzeitig und ein Ndef übernimmt das "arrangment"

//NDEF mischer

// zufallsort der Obertonreihe
s = [1, 2, 3, 4, 5, 6, 7, 8, 9];
o = [1 ,1 ,1 ,1 ,1 , 2, 2, 2, 2,  4,1, 1 ];

//sinuston

(
Ndef(\Bordun1, {|freq = 440, amp = 0.05|
	SinOsc.ar(freq) ! 2 * amp }).play;)


(
Ndef(\pattern1, {|freq = 440, dur = 1, amp= 0.2|
	var sig, env, trig,trig1, step, octave;

	trig = LFPulse.ar(dur);
	trig1 = LFPulse.ar(dur/4);
	octave = TChoose.kr(trig1, o);
	step = TChoose.kr(trig, s);
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(freq * step * octave) * env;
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
	step = TChoose.kr(trig, s);
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(freq * step) * env;
	sig = sig ! 2 * amp;
}).play;

)

//-------2.IDEE: Patterns

.do




//-----3.IDEE: 1 Arrays, dass von einem anderen nach und nach ersetzt wird
//.put





(
f = 440;
e = 453.47;
Tdef(\a, { g = [1, 2, (3/2), (4/3), (5/4), (6/5), (7/6), (8/7), (9/8)];g.postln;});		//arrays müssen noch mit freq multipliziert werden
Tdef(\c, { 9.do { |item, i| h = [1, 2, (3/2), (4/3), (5/4), (6/5), (7/6), (8/7), (9/8)]; g.add(h[i]); g.postln; 1.wait;}});
r = Task({
    "starting...".postln;
    2.wait;
    Tdef(\a).embed;
    2.wait;
    Tdef(\c).embed;
    "end".postln;
});
)
r.play;
// das sollte gehen

