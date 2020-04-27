





(
Ndef(\pattern1, {|freq1 = 440, dur = 1, amp= 0.2, array = [0, 1]|
	var sig, env, trig, step;

	trig = LFPulse.ar(dur);

	step = TChoose.kr(trig, (array * freq1));
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(step) * env;
	sig = sig ! 2 * amp;
}).play
)





(
	Tdef(\arranger1, {
	var step;

	step = [1, 2, (3/2), (4/3), (5/4), (6/5), (7/6), (8/7), (9/8)];

	Ndef(\pattern1).set(\array, step).play;

	}).play;
)


/*
	Frage : wie kann ich dem Ndef ein Array als argument übergeben
*/





// Versuch: kein Arry wird übergeben sondern die Grundfreqenz

(
Ndef(\pattern1, {|freq = 440, dur = 1, amp= 0.2|
	var sig, env, trig, step, array;

	array = [1, 2, (3/2), (4/3), (5/4), (6/5), (7/6), (8/7), (9/8)];

	trig = LFPulse.ar(dur);

	step = TChoose.kr(trig, (array * freq));
	env = Env.perc(0.02, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(step) * env;
	sig = sig ! 2 * amp;
});
)
(
Ndef(\Bordun, {|freq = 440, amp = 0.05|
	SinOsc.ar(freq) ! 2 * amp });
)




(
	Tdef(\arranger2, {
	var freq1, freq2;

	freq1 = 440;
	freq2 = 452;

	loop{
	Ndef(\pattern1).set(\freq, freq1).play;

	4.rand.wait;

	Ndef(\pattern1).set(\freq, freq2).play;

	4.rand.postln.wait;
	};

}).play;
)

Ndef(\Bordun).set(\freq, 440).play;

Ndef(\Bordun).set(\freq, 452).play;




//-------1.IDEE: alle Ndefs spielen gleichzeitig und ein Ndef übernimmt das "arrangment"

//NDEF mischer

// zufallsort der Obertonreihe
s = [1, 2, 3, 4, 5, 6, 7, 8, 9];
o = [1 ,1 ,1 ,1 ,1 , 2, 2, 2, 2,  4,1, 1 ];

//sinuston

(
Ndef(\test, {|freq = 440, amp = 0.05|
	SinOsc.ar(freq) ! 2 * amp }).play;)


(
Ndef(\patterna, {|freq1 = 440, dur = 1, amp= 0.2|
	var sig, env, trig, trig1, step, array;

	array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

	trig = LFPulse.ar(dur);
	trig1 = LFPulse.ar(dur/4);
	step = TChoose.kr(trig, (array * freq1));
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(step) * env;
	sig = sig ! 2 * amp;
})
)

(
Ndef(\Bordun2, {|freq = 453.47, amp = 0.05|
	SinOsc.ar(freq) ! 2 * amp }).play;

)


(
Ndef(\patternb, {|freq = 453.47,  dur = 1, amp= 0.2|
	var sig, env, trig, step;

	trig = LFPulse.ar(dur);
	step = TChoose.kr(trig, s);
	env = Env.perc(0.01, (dur/2), 1, -4.0).ar(0, trig);
	sig = SinOsc.ar(freq * step) * env;
	sig = sig ! 2 * amp;
}).play;

)

// _____________________ Tdef arranger ____________________
(
	Tdef(\arranger, {
	var a1;

	a1 = [1, 2, (3/2), (4/3), (5/4), (6/5), (7/6), (8/7), (9/8)];

	Ndef(\pattern1).set(\array, a1).play;

	}).play;
)



//-------2.IDEE: Patterns






//-----3.IDEE: 1 Arrays, dass von einem anderen nach und nach ersetzt wird
//.put


(
Ndef(\was, {|freq = 440, amp = 0.05|
	SinOsc.ar(freq) * amp }).play;
)



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
// warum wird bei den letzten 3 "do's" das Array g nicht erweitert
