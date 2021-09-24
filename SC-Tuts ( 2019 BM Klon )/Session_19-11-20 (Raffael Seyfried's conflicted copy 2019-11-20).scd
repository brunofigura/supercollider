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










