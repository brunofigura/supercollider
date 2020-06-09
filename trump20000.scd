
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
SynthDef(\y, {|out, gate = 1, amp = 0.05, dt = 0.1, pan = 0, detuneamt = 0, detunetime = 2, trig = 0, maxamp = 1|		//detune um später stauchen und strecken zu können ( vielleicht muss die methode geändert werden)
	var freqs = \freqs.ir(440 ! 119); //man kann dem synth ein16 großes array mit freqs als arg übergeben
	var amps = \amps.ir(1 ! 119);

	var mod = EnvGen.ar(Env.perc(detunetime/2, detunetime/2, detuneamt, \sin), trig);// mod staucht und streckt fq

	var env = EnvGen.kr(Env.asr, gate,doneAction: 2);
	var envfreq = EnvGen.ar(Env(freqs, dt ! freqs.size, curve: \sin).circle(dt));
	var envamp = EnvGen.ar(Env(amps, dt ! freqs.size).circle(dt));


	var sig = SinOsc.ar(envfreq + mod) * envamp * env;
		sig = sig * (amp/maxamp);

		//sig = FreeVerb.ar(sig);

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




(
var etwas = ~playAll.value(~file3);
var jenes = ~playAll.value(~file2);
~stopAll.value(etwas);
~stopAll.value(jenes);
)












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

b.do {|x| x.set(\dt, 0.0001, \pan, 0.01)}; // passiert zu direkt
(
var polarity = ((-1 ! (b.size/2))++(1 ! (b.size/2))).asArray; // muss so groß sein wie synths ereugt werden
b.do{|x, i| x.set(\detuneamt, 200* i * polarity[i], \trig, 1, \detunetime, 1)};
)

b.do{|x, i| x.set(\detuneamt, 200, \trig, 0, \detunetime, 5)};

(
b.do {|x| x.release(5)};
)

