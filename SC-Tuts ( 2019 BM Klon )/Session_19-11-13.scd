a = 0;
(
var a = 0;
a = 2;
{
	var a = 1;
	postf("a in der funktion: %\n", a);
}.value;
postf("a im block: %\n", a);
)
a.postln;

a = 0;
/////////////////////////////////////////////////////////////////////


(
f = {
	var a = 4;
	a = a * 2;
	postf("a in der funktion: %\n", a);
};
)

a.postln;

f.value;

a = 2;

postf("a im block: %\n", a);


////////////////////////////////////////////////////////////////////////


Env.perc(0, 1, 10, 'exp').plot;


(
Ndef(\bd, {
	var env, freqEnv, sig;
	env = Env.perc(0, 0.3, 1, -4).circle.ar();
	freqEnv = env.linexp(0, 1, 50, 250);
	sig = SinOsc.ar(freqEnv) * env;
	sig = Pan2.ar(sig, 0);
	sig
}).play;
)

(
Ndef(\bd, {
	var env, freqEnv, sig;
	env = Env([1, 0.3, 0.9, 0], [0.3, 0.6, 0.1]).circle.ar();
	freqEnv = env.linexp(0, 1, 50, 250);
	sig = SinOsc.ar(freqEnv) * env;
	sig = Pan2.ar(sig, 0);
	sig
}).play;
)

(
Ndef(\randShape, {
	var sig;
	sig = Env(rand(1.0 ! 12), 1/rrand(50, 7000 ! 11), rand2(-12 ! 11)).circle.ar;
	sig = LeakDC.ar(sig);
	sig;
});
)

Ndef(\randShape).play;
Ndef(\randShape).fadeTime = 5;
Ndef(\randShape).free;
Ndef(\randShape).stop;

Env.perc(0.4, 1).plot;
Env([1, 0.3, 0.9, 0], [0.3, 0.6, 0.1], [-3, 3, 12]).plot
Env(rand(1.0 ! 4), rand(1.0 ! 3), rand2(-12, 12 ! 3)).plot
Env(rand(1.0 ! 7), 1/rrand(50, 700 ! 6), rand2(-12 ! 6)).plot

////////////////////////////////////////////////////////////////////////

// SynthDef - Synth Definition
(
SynthDef(\x, {
	Out.ar([0, 1], Saw.ar(Rand(100, 700)) * 0.1;);
}).add;
)

(
SynthDef(\x, {
	Out.ar([0, 1], Saw.ar(rrand(100, 700)) * 0.1;);
}).add;
)

rand(10)
Rand(0, 10)

a = Synth(\x);
a.stop;

(
SynthDef(\x, {|out|
	var sig;
	sig = Saw.ar(Rand(200, 700)) ! 2;
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)

a = Synth(\x);
a.stop;

(
SynthDef(\x, {|out, freq=100|
	var sig;
	sig = Saw.ar(freq ! 2);
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)

a = Synth(\x);
a.set(\freq, 400);
a.free;

(
SynthDef(\x, {|out, freq=100, gate=1|
	var sig, env;
	//  		   Att	Dec  Sus  Rel	 DoneAction, Gate
	env = Env.adsr(0.3, 0.4, 0.5, 0.6).ar(2, gate); // das selbe wie Done.freeSelf
	sig = Saw.ar(freq ! 2) * env;
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)

a = Synth(\x);
b = Synth(\x);
a.set(\freq, 400);
a.set(\gate, 0);
b.set(\gate, 0);
a.free
a.stop;

(
SynthDef(\x, {|out|
	var sig, env;
	env = Env.perc(0, 1).ar(2);
	sig = Saw.ar(Rand(200, 700)) * env ! 2;
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)

a = Synth(\x);

(
f = {
	300.do{ Synth(\x) };
}.value;
)

(
fork{
	"hallo".postln;
	1.wait;
	"...".postln;
	1.wait;
	"Kurs".postln;
};
)

(
f = {
	300.do{ Synth(\x); 0.1.wait };
}.fork;
)

(
f = {
	150.do{|i| i.postln; Synth(\x); rrand(0.01, 0.2).wait };
}.fork;
)

(
f = {
	loop{ Synth(\x); rrand(0.01, 0.2).wait };
}.fork;
)

(
f = {
	loop{ Synth(\x); rrand(0.01, 0.2).wait };
}.fork;
)

(
f = {
	inf.do{ |i| i.postln; Synth(\x); 0.001.wait };
}.fork;
)

(
Tdef(\seq, {
	"hallo".postln;
	1.wait;
	"kurs".postln;
}).play;
)


(
SynthDef(\x, {|out, freq|
	var sig, env;
	env = Env.perc(0, 0.2).ar(2);
	sig = Saw.ar(freq) * env ! 2;
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)


// Tdefs laufen auf der TempoClock und quantisieren auf den nächsten Downbeat

TempoClock.tempo = 106/60;

(
Tdef(\seqA, {
	loop{
		Synth(\x, [\freq, 1000]);
		(3/7).wait;
	};
}).play;
)

(
Tdef(\seqB, {
	loop{
		Synth(\x, [\freq, 500]);
		(1/7).wait;
	};
}).play;
)


//	  0   1   2  3
a = [15, 12, 34, 6];
a[0 % a.size];
4 % a.size

(
SynthDef(\x, {|out, freq|
	var sig, env;
	env = Env.perc(0, 0.2).ar(2);
	sig = Saw.ar(freq) * env ! 2;
	Out.ar(out, sig.tanh * 0.1 );
}).add;
)

60.midinote
TempoClock.tempo = 160/60

(
Tdef(\tempi, {
	var length = 32;
	loop{
		~tempoA = 1;
		~tempoB = 1;
		length.wait;
		~tempoA = 1;
		~tempoB = 1 + (1/length);
		length.wait;
	};
}).play;

Tdef(\seqA, {
	var freqs = [60, 62, 67, 69, 70, 62, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		Synth(\x, [\freq, freqs[i % freqs.size]]);
		(~tempoA/2).wait;
	};
}).play;

Tdef(\seqB, {
	var freqs = [60, 62, 67, 69, 70, 62, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		Synth(\x, [\freq, freqs[i % freqs.size]]);
		(~tempoB/2).wait;
	};
}).play;
)


{[SinOsc.ar(4, 0, 1), SinOsc.ar(4, 0, 2)]}.plot(1);
{[SinOsc.ar(4, 0, 1, 0), SinOsc.ar(4, 0, 1, 1)]}.plot(1);




(
Tdef(\seqA, {
	var freqs = [60, 62, 67, 69, 70, 62, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		Synth(\x, [\freq, freqs[i % freqs.size]]);
		(1/2).wait;
	};
}).play;
)

true != true

(
Tdef(\seqA, {
	var freqs = [60, \rest, 67, 69, \rest, \rest, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		var freq = freqs[i % freqs.size];
		if(freq != \rest){
			Synth(\x, [\freq, freq]);
		};
		(1/2).wait;
	};
}).play;
)

(
Tdef(\seqA, {
	var freqs = [60, 62, 67, 69, 70, 62, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		var freq = freqs[i % freqs.size];
		if((i % 3) != 0){
			Synth(\x, [\freq, freq]);
		};
		(1/2).wait;
	};
}).play;
)

(
Tdef(\seqA, {
	var freqs = [60, 62, 67, 69, 70, 62, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		var freq = freqs[i % freqs.size];
		if(0.9.coin){
			Synth(\x, [\freq, freq]);
		};
		(1/2).wait;
	};
}).play;
)

["hi", 1, \a].choose;
(
Tdef(\seqA, {
	var freqs = [60, 62, 67, 69, 70, 62, 60, 69, 67, 62, 70, 69].midicps;
	inf.do{ |i|
		Synth(\x, [\freq, freqs[i % freqs.size]]);
		([1, 0.5, 3, 0.05].choose/2).wait;
	};
}).play;
)












































