/*
Xdef(name, funktion)
*/

Tdef(\x, { "Hallo".postln;})
Tdef(\x).play;


{SinOsc.ar(100) }.play;

().play


(
SynthDef(\x, {|out, freq=100, gate=1|
	var sig, env;
	//  		   Att	Dec  Sus  Rel	 DoneAction, Gate
	env = Env.adsr(0.3, 0.4, 0.5, 0.6).ar(2, gate); // das selbe wie Done.freeSelf
	sig = Saw.ar(freq ! 2) * env;
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)

n = s.nextNodeID;             // get an available nodeID from the server and assign it to n
s.sendMsg("/s_new", "x", n);  // use the SynthDef "default" to create a synth with ID n
s.sendMsg("/n_free", n);      // release the synth n

OSCFunc.trace(true, true);


Ndef(\x, { SinOsc.ar(100)});
Ndef(\x).play;


// Randomness
SimpleNumber // -> Hier im Helpfile nachgucken was man alles mit Zahlen machen kann
// Zufallszahlen von 0 bis (receiver - 1)
10.rand;
rand(10);
// Zufallszahlen von einer Zahl bis zu einer anderen Zahl
rrand(1, 10);
1.rrand(10);
// Zufallszahlen von negativ receiver bis positiv receiver
2.rand2;
rand2(10);
// Gauss'sche Normalverteilung
10000.collect { |num| gauss(0.0, 10000) }.histo.plot;

// Verschiedene Verteilungen
10000.collect { |num| linrand(10000) }.histo.plot;
10000.collect { |num| bilinrand(10000) }.histo.plot;
10000.collect { |num| exprand(1, 100) }.histo.plot;

(
SynthDef(\x, {|out, freq=300, ffreq=1000, gate=1|
	var env, sig;
	env = Env.adsr(0.3, 0.3, 0.5, 0.3).ar(Done.freeSelf, gate);
	sig = RLPF.ar(Saw.ar(freq), ffreq, 0.3) * env ! 2;
	Out.ar(out, sig);
}).add;
)

a = Synth(\x);
a.set(\freq, 500)
a.set(\gate, 0)

(
Tdef(\x, {
	loop{
		var synth;
		synth = Synth(\x, [\freq, 600.rand]);
		1.wait;
		synth.set(\ffreq, 200);
		1.wait;
		synth.set(\gate, 0);
		1.wait;
	};
}).play;
)

Tdef(\x).stop;




(
Tdef(\otto, {
	loop{
		1.wait;
	};
}).play;
)

(
Tdef(\otto, {
	inf.do{|i|
		i.postln;
		1.wait;
	};
}).play;
)

(
SynthDef(\y, {|out, freq=100, sustain=0.3|
	var env, sig;
	env = Env([0, 1, 0.3, 0], [0.3, 0.3, 0.4] * sustain).ar(2);
	sig = SinOsc.ar(freq) * env * 0.2 ! 2;
	Out.ar(out, sig)
}).add;
)

(
Tdef(\x, {
	var waitTime;
	loop{
		waitTime = rrand(0.5, 2);
		Synth(\y, [\freq, rrand(100, 700), \sustain, waitTime * 4]);
		waitTime.wait;
	};
}).play;
)


(
SynthDef(\y, {|out, freq=100, gate=1|
	var env, sig;
	env = Env.adsr(0.25, 0.25, 0.5, 0.5).ar(2, gate);
	sig = SinOsc.ar(freq) * env * 0.2 ! 2;
	Out.ar(out, sig)
}).add;
)

(
Tdef(\x, {
	var waitTime, sustainTime, synth;
	loop{
		sustainTime = rrand(0.5, 2);
		synth = Synth(\y, [\freq, rrand(100, 700)]);
		(sustainTime + 0.5).wait;
		synth.set(\gate, 0);
		0.5.wait;
	};
}).play;
)

Tdef(\x).stop;

(
SynthDef(\y, {|out, freq=100, gate=1, att, dec, rel|
	var env, sig;
	env = Env.adsr(att, dec, 0.5, rel).ar(2, gate);
	sig = SinOsc.ar(freq) * env * 0.2 ! 2;
	Out.ar(out, sig)
}).add;

)

(
Tdef(\x, {
	var waitTime, sustainTime, synth, attack, decay, release;
	loop{
		attack = rrand(0.01, 0.6);
		decay = rrand(0.01, 0.3);
		release = rrand(0.1, 0.7);
		sustainTime = rrand(0.5, 2);
		synth = Synth(\y, [\freq, rrand(100, 700), \att, attack, \dec, decay, \rel, release]);
		(sustainTime + attack + decay).wait;
		synth.set(\gate, 0);
		release.wait;
	};
}).play;
)

Tdef(\x).stop;

Ndef(\fm).reshaping_(\elastic)
(
Ndef(\fm, {
	SinOsc.ar(400 + (SinOsc.ar(450) * 4 )) ! 2;
}).play;
)
(
Ndef(\fm, {
	var sig = SinOsc.ar(3 + (SinOscFB.ar([450, 452], 1.6) * 16 ));
	sig = LeakDC.ar(sig);
}).play;
)


(
Ndef(\fm, {
	SinOsc.ar(400 + (Saw.ar(2000) )) ! 2;
}).play;
)

(
Ndef(\fm, {
	SinOsc.ar(Saw.ar(1400).linlin(-1, 1, 1000, 2000) ) ! 2;
}).play;
)


(
Ndef(\fm, {
	SinOsc.ar(400 + (SinOsc.ar(MouseX.kr(0.3, 500)) * MouseY.kr(5, 1500)) ) ! 2;
}).play;
)

Ndef(\fm).free;

(
Ndef(\fm, {
	SinOsc.ar(100 + (SinOsc.ar(450 + (SinOsc.ar(470 + (Saw.ar(1020) * (600 * SinOsc.ar(3.1)))) * (700 * SinOsc.ar(3)))) * (40 * SinOsc.ar(3.2)) )) ! 2;
}).play;
)

(
Ndef(\pm, {
	SinOsc.ar(400, SinOsc.ar(410) * MouseX.kr(0, 80)) ! 2;
}).play;
)

Ndef(\pm).stop;

(
SynthDef(\pm, {|out, freq=100, modFreq=100, modAmt=0.1, amp=0.1, sustain=0.5|
	var env, modEnv, sig, mod;
	env = Env.perc(0, sustain).ar(2);
	modEnv = Env([1, 0, 1], [0.5, 0.5]*sustain).ar;
	mod = SinOsc.ar(modFreq) * modAmt * modEnv;
	sig = SinOsc.ar(freq, mod) * env ! 2;
	Out.ar(out, sig.tanh * amp);
}).add;
)


(
Tdef(\pmSeq, {
	var freq, modFreq, modAmt, waitTime, sus;
	freq = [100, 150, 1500, 400];
	modFreq = [15, 6000, 430, 300, 12000];
	modAmt = [4, 1, 0.1];
	waitTime = 0.1;
	sus = 40.collect{|i| i.linlin(0, 39, 0, pi).sin };
	inf.do{ |i|
		Synth(\pm, [
			\amp, 0.6,
			\freq, freq[i % freq.size],
			\modFreq, modFreq[i % modFreq.size],
			\modAmt, modAmt[i % modAmt.size],
			\sustain, waitTime * (sus[i % sus.size] * 3),
		]);
		waitTime.wait;
	};
}).play;
)

(
Tdef(\mod, {
	var a = ["hallo","hinzugefügt", "10", 50, \zwei, "vier"];
	inf.do{|i|
		a[i % a.size].postln;
		0.5.wait;
	};
}).play;
)
