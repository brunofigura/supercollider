(
Tdef(\x, {
	a = Synth(\a);
	1.wait;
	b = Synth(\b);
	a.free;
}).play;
)

(
Tdef(\stueck, {
	Tdef(\x).play;
	1.wait;
	Tdef(\y).play;
	1.wait;
	Tdef(\x).stop;
	1.wait;
	Tdef(\y).stop;
}).play;
)

(
var arr =[Tdef(\x), Tdef(\y)];
Tdef(\stuek, {
	inf.do{|i|
		arr[i%arr.size].play;
		1.wait;
	};
}).play
)

(
Ndef(\steuk, {
	// sehr langsame modulation
}).play
)


// mit Human Input

// mit Live-Coding

// material Sammlung -> Woanders bearbeiten

// Anweisungen schreiben für jemand anderen
// "Partitur" erstellen graphisch oder anders
// Anweisungen für den Computer schreiben
// Stück Factories

// mit Verschiedenen Files -> siehe Sonderzeichen Orchester

// daten von einer Externen Quelle "Sonification"


a = "aba";
a.replace("a", "3");
a.class;
a = Array();
a.class;
"2 * 2".interpret;
"f = {|i| i * 2}".interpret.value(i: 120)

// Sonifikation:
// Daten die von außen kommen
f = File.open("weather.json".resolveRelative, "r");
g = f.readAllString;
// Strategie 1: Kann ich direkt in dem String daten finden
g.find("\London");
// Strategie 2: Kann ich den String in ein Event umformen

g = g.replace("{", "(");
g = g.replace("}", ")");
g = g.replace("[", "");
g = g.replace("]", "");
g = g.replace("\"", "");

e = g.interpret;

f = ("n": 3);
f.at('\"n\"')
e.at('name')
e = (coord: (lon: -0.13,lat: 51.51),weather:(id: 300 ,main: "Drizzle",description: "light intensity drizzle",icon:"09d"),base:"stations",main:(temp:280.32,pressure:1012,humidity:81,temp_min:279.15,temp_max:281.15),visibility:10000,wind:(speed:4.1,deg:80),clouds:(all:90),dt:1485789600,sys:(type:1,id:5091,message:0.0103,country:"GB",sunrise:1485762037,sunset:1485794875),id:2643743,name:"London",cod:200)

(freq: e.at('main').at('temp')).play;

f = CSVFileReader.read("cities.csv".resolveRelative, true, true, startRow: 1);

a = f.collect{|item| item[0].asInt};
a.cs
p = Pbind(\note, Pseq(a, 1), \dur, 0.5);
p.play;

().play

a = [3, "hallo", 14, '1'];
a.do{|item| item.postln}


d = Dictionary.new();
d.put(\coord, 3);
d.at(\coord);
d.do{|item| item.postln};

e = (
	a: 3,
	e: (a: 3, b: 4),
	b: "hallo",
	c: {"welt".postln},
);

().play;

e.at(\c).value

// P A T T E R N S / E V E N T S
().play;

(freq: 440).play;

(note: 4).play;

(degree: [0,2,4,6,9]).play;

Scale.directory
Event

(degree: [0,2,4,6,9], gtranspose: 0, scale: Scale.at(\partch_o3)).play;

(
SynthDef(\x, {|out, freq=440, amp=0.1, sustain=1, cutoff=200, pan=0|
	var env, sig;
	env = Env.perc(0, sustain).ar(2);
	sig = MoogFF.ar(Saw.ar(freq), cutoff * env.linlin(0, 1, 1, 4), 2);
	sig = Pan2.ar(sig, pan) * env;
	Out.ar(out, sig.tanh * amp);
}).add;
)

(
(
instrument: \x,
degree: [0,2,4,6,9],
scale: Scale.at(\partch_o3),
cutoff: 1000,
pan: -1,
).play;
)


(
Pdef(\seq, Pbind(
	\instrument, \x,
)).play;
)


(
SynthDef(\x, {|out, freq=440, amp=0.1, sustain=1, cutoff=200, pan=0|
	var env, sig;
	env = Env.perc(0.1, sustain).ar(2);
	sig = MoogFF.ar((Saw.ar(freq * [1, 0.99]) + LFPulse.ar(freq*0.501)), cutoff * env.linlin(0, 1, 1, 4), 2).mean;
	sig = Pan2.ar(sig, pan) * env;
	Out.ar(out, sig.tanh * amp);
}).add;
)

(
Pdef(\seq, Pbind(
	\instrument, \x,
	\scale, Scale.at(\lydian),
	\octave, Pseq([2, 2, 2, 2, 4], inf),
	\ctranspose, Pstutter(16, Pseq([0, 2], inf)),
	\degree, Pseq([[0, 4], 1, Pstutter(3, Pseq([2, 1])), Pseq([3, 6], 2)], inf),
	\cutoff, Pwhite(200, 1000, inf),
	\legato, 2,
	\amp, Pseq([1, 0.5, 0.3], inf),
	\dur, 0.25
)).play;
)

Pdef(\seq).stop;

TempoClock.tempo = 300/120;
(
Pdef(\seq, Pbind(
	\instrument, \x,
	\scale, Scale.at(\partch_o2),
	\octave, 5,
	\degree, Prand([[0,1,4,5], [4,5,7,9], [1,9], [9,18,15]], inf),
	\cutoff, Pwhite(200, 1000, inf),
	\legato, Pwhite(0.1, 4),
	\amp, 0.3,
	\dur, Prand([1, 2, Pseq([0.125, 0.125, 0.25], 2), Pseq([1/3, 1/3, 1/3])], inf)
)).play;
)



// Busse
~reverb = Bus.audio(s, 2);
~master = Bus.audio(s, 2);

(
SynthDef(\x, {|out, freq=440, amp=0.1, sustain=1, cutoff=200, pan=0|
	var env, sig;
	env = Env.perc(0, sustain).ar(2);
	sig = MoogFF.ar((Saw.ar(freq * [1, 0.99]) + LFPulse.ar(freq*0.501)), cutoff * env.linlin(0, 1, 1, 4), 2).mean;
	sig = Pan2.ar(sig, pan) * env;
	Out.ar(~reverb, sig * -24.dbamp);
	Out.ar(~master, sig.tanh * amp);
}).add;
)

(
Ndef(\reverb, {
	var in, sig;
	in = In.ar(~reverb, 2);
	sig = JPverb.ar(in, 2.3);
	sig
}).play(~master);
)

(
Ndef(\master, {
	var in, sig;
	in = In.ar(~master, 2);
	sig = Compander.ar(in, in, -16.dbamp, 1, 1/8, 0.03, 0.05);
	sig = (sig * 5).tanh * 0.7;
}).play;
)
