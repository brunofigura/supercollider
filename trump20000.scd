
~file3 = SpearFile2("B:/supercolider-git/supercollider/spear data/Trump-Press-are-liars(loud).txt", s); // windows
~file2 = SpearFile2("B:/supercolider-git/supercollider/spear data/fieldrec(eq+c).txt", s) // ist sehr leise einfach so.

// amp abhängig vom array werden machen!!!!!!!!!!! sowas wie maxamp

//Spearvorbereitung jetzt mit spear
~file3 = SpearFile2("/Users/brunofigura/GitHub/supercollider/spear data/Trump-Press-are-liars(loud).txt".resolveRelative, s);

~file3 = ~file3.initPartials;
~file2 = ~file2.initPartials;
a = ~file3
a.partials[5].flop[0].size // ein partial hat 119 frequenzen


(
SynthDef(\y, {|out, gate = 1, amp = 0.05, dt = 0.1, pan = 0, detuneamt = 0, detunetimerise = 1, detunetimefall = 1, trig = 0, maxamp = 1|		//detune um später stauchen und strecken zu können ( vielleicht muss die methode geändert werden)
	var freqs = \freqs.ir(440 ! 119); //man kann dem synth ein16 großes array mit freqs als arg übergeben
	var amps = \amps.ir(1 ! 119);

	var mod = EnvGen.ar(Env.perc(detunetimerise, detunetimefall, detuneamt, \sin), trig);// mod staucht und streckt fq

	var env = EnvGen.kr(Env.asr, gate,doneAction: 2);
	var envfreq = EnvGen.ar(Env(freqs, dt ! freqs.size, curve: \sin).circle(dt));
	var envamp = EnvGen.ar(Env(amps, dt ! freqs.size).circle(dt));


	var sig = SinOsc.ar(envfreq + mod) * envamp * env;
		sig = sig * (amp/maxamp);

		sig = FreeVerb.ar(sig);

		Out.ar(out,Pan2.ar(sig, SinOsc.ar(pan, mul: 0.4)));
}).add;
)

(

~playAll = {|file|
a = file;
a.partials.size.post;
( " Partials werden gespielt\n\n").post;
	b = a.partials.collect{|x, i| // in Liste speichern
	var partial = a.partials[i].flop;
	var maxamp = a.partials.collect { |y| y.collect { |x| x.at(1) } }.flat.maxItem;
	Synth(\y, [\freqs, partial[0], \amps, partial[1], \pan, 1, \maxamp, maxamp]);
}

};
)

~stopAll = {|name|name.do {|x| x.release(5)};}
// funktion für partial scan
//funktion für random partial scan
//organisches weißes rauschen ( alla meer )
//funktion für stauchen und strecken
// interlacing funktion neues array aus 2 files.

~setSpeed = {|name, speed = 0.1|name.do {|x|x.set(\dt, speed)};}



(
~stretchAll = {|syntharray, amt = 200, riseTime = 1, fallTime = 1|
var polarity = ((-1 ! (b.size/2))++(1 ! ((b.size/2)+1))).asArray;

syntharray.do{|x, i| x.set(\detuneamt, 0, \trig, 0, \detunetime, 0)};
syntharray.do{|x, i| x.set(\detuneamt, (amt* i) * polarity , \trig, 1, \detunetime, 1)};
}
)


(
var etwas = ~playAll.value(~file3);
//var jenes = ~playAll.value(~file2);
~stretchAll.value(etwas);
~stopAll.value(jenes);
)

(
Tdef(\test, {
	1.do {
		var etwas = ~playAll.value(~file3);
		etwas.postln;
		4.wait;
		~setSpeed.value(etwas, 0.01);
		2.wait;
		~stretchAll.value(etwas, 100, 19, 1);//file, amt, riseTime, fallTime
		20.wait;
		~setSpeed.value(etwas, 0.001);
		2.wait;
		~setSpeed.value(etwas, 10);
		~stretchAll.value(20, 1, 1);
		4.wait;
		~setSpeed.value(etwas, 0.0001);
		5.wait;
		~stopAll.value(etwas);
};}
).play;)

(
p = a.partials[5].flop; // 5. Partial wird abgespielt
p = a.partials[].flop; // was passiert dann
var maxAmp = a.partials.collect { |y| y.collect { |x| x.at(1) } }.flat.maxItem; // max amp von file 3 0.726028
b = Synth(\y, [\freqs, p[0], \amps, p[1]]);
)

//alle partials absipielen
(
a.partials.size.post;
( " Partials werden gespielt\n\n").post;
b = a.partials.collect{|x, i|
	var partial = a.partials[i].flop;
	var maxamp = a.partials.collect { |y| y.collect { |x| x.at(1) } }.flat.maxItem;
	Synth(\y, [\freqs, partial[0], \amps, partial[1], \pan, 1, \maxamp, maxamp]);
}
)

b.do {|x| x.set(\dt, 0.01, \pan, 0.01)}; // passiert zu direkt
(
var polarity = ((-1 ! (b.size/2))++(1 ! ((b.size/2)+1))).asArray; // muss so groß sein wie synths ereugt werden
b.size.postln;
b.do{|x, i| x.set(\detuneamt, 200, \trig, 0, \detunetime, 0)};
b.do{|x, i| x.set(\detuneamt, 200 * i * polarity[i], \trig, 1, \detunetime, 50)};
)

b.do{|x, i| x.set(\detuneamt, 200, \trig, 0, \detunetime, 5)};

(
b.do {|x| x.release(5)};
)

