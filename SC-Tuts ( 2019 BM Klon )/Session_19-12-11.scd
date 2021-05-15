// https://www.birmingham.ac.uk/facilities/ea-studios/research/supercollider/mailinglist.aspx

// Wie man arrays übergibt
a = [10, 40, 60, 70];

f = { |x| postf("Klasse: % Objekt: %\n", x.class, x);  };
// Array Objekt wird "im ganzen" übergeben
f.(a);
// explizit nur eine Stelle des Arrays übergeben
f.(a[1]);

// Jede stelle des Arrays einzeln übergeben mit .do und .collect
a.do{|item, i| [item, i].postln };

// einmal ausgeschrieben
(
{
	{|x, y| [x, y].postln }.value(a[0], 0);
	{|x, y| [x, y].postln }.value(a[1], 1);
	{|x, y| [x, y].postln }.value(a[2], 2);
	{|x, y| [x, y].postln }.value(a[3], 3);
}.value;
)

d = Dictionary.new(6);
d.put(\a, 0);
d.put(\b, 12340);
d.put(\56, "hallo");

d.do{ |item, i| [item, i].postln };

b = Bag.new(4)
b.add("g")
b.do{ |item, i| [item, i].postln };

a = [1, 2, 3, 4, 5, 6, 7];
c = a.collect{|item, i| item * 2};
c = a.collect{|item, i| if( item == 4){ "vier" }{ item*2 } };
c = a.collect{|item, i| if( item == 4){ item**2}{ item*2 } };
c = a.collect{|item, i| if( item.isPrime ){ item**2}{ item*0.5 } };

// tests
3 > 1
3 < 1
1 == 0
1 == 1
"hallo" != "welt"
<=
>=
a = [1, 2, 3];
c = Array.newFrom(a);
a === c;
a == c;
2.isPrime
2.even
2.odd

(
x = 2;
switch(x.even,
	0, {"null".postln},
	1, {"eins".postln},
	2, {"zwei".postln},
);
)

69.midicps()
2.midiratio()

b = Buffer.read(s, "C:/Users/Raffael/Dropbox/Sample Magic - White Label - Organic Ambient (Raffael Seyfried)/Sample Magic - White Label - Organic Ambient/melodic loops/90/oa_piano_loop_minutes_90_Eb.wav");
(
Ndef(\x, {
	PlayBuf.ar(2, b, ((0, 0.01 .. 4)).midiratio, loop: 1).mean;
}).play;
)

(0, 0.1 .. 1)

// P A T T E R N S

// Events -> Patterns -> Streams
// Events
().play;

(
SynthDef(\x, {|out, freq, pan=0, feed=0.7, amp|
	var sig, env;
	env = Env.perc(0, 1).ar(2);
	sig = SinOscFB.ar(freq, feed) * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * amp);
}).add;
)

(instrument: \x, scale: Scale.at(\mixolydian), degree: 0, octave: 3, amp: 0.1).play;

// Patterns
a = Pseq([0, 1, 2], inf);
a = a.asStream;
a.next

a = Pwhite(0.0, 1.0, inf);
a = a.asStream;
a.next

// Streams
a = Pseq([0, 1, 2], inf);
b = Pbind(\degree, a);
c = b.asStream;
c.next(()).play

TempoClock.tempo = 160/60;

(
b = Pbind(
	\instrument, \x,
	\degree, a,
	\feed, Pseq([1, 1.5, 0.2, 0.5], inf),
	\dur, 0.5,
)
);

d = b.play;

Pdef(\x, b);
Pdef(\x).play
Pdef(\x).stop;

(
Pdef(\x, Pbind(
	\instrument, \x,
	\scale, Scale.at(\minor),
	\feed, Pseq([1.5, 1.2, 0.7], inf),
	\degree, Ptime(inf),
	\dur, 0.5
))
)


Pdef(\x).play;

// Aliasing
(
Ndef(\alias, {
	var sig, imp, sRate;
	sRate = 6000;
	imp = Impulse.ar(sRate);
	sig = SinOsc.ar(MouseX.kr(100, 4000));
	sig = Latch.ar(sig, imp);
	sig = RLPF.ar(sig, 3000);
}).play;
)

(
Ndef(\alias, {
	var sig, imp, sRate;
	sig = LFSaw.ar(MouseX.kr(1000, 20000));
}).play;
)
