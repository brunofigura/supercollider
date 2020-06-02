
~file3 = SpearFile2("B:/supercolider-git/supercollider/spear data/Trump-Press-are-liars(loud).txt", s); // windows
//Spearvorbereitung jetzt mit spear
~file3 = SpearFile2("/Users/brunofigura/GitHub/supercollider/spear data/Trump-Press-are-liars(loud).txt".resolveRelative, s);

~file3 = ~file3.initPartials;

a = ~file3
a.partials[5].flop[0].size // ein partial hat 119 frequenzen


(
SynthDef(\y, {|out, gate = 1, amp = 0.05, dt = 0.1, pan = 0, detuneamt = 0, detunetime = 2, trig = 0|		//detune um später stauchen und strecken zu können ( vielleicht muss die methode geändert werden)
	var freqs = \freqs.ir(440 ! 119); //man kann dem synth ein16 großes array mit freqs als arg übergeben
	var amps = \amps.ir(1 ! 119);

	var mod = EnvGen.ar(Env.perc(detunetime/2, detunetime/2, detuneamt, \sin), trig);// mod stacht und streckt fq

	var env = EnvGen.kr(Env.asr, gate,doneAction: 2);
	var envfreq = EnvGen.ar(Env(freqs, dt ! freqs.size, curve: \sin).circle(dt));
	var envamp = EnvGen.ar(Env(amps, dt ! freqs.size).circle(dt));


	var sig = SinOsc.ar(envfreq + mod) * envamp * env;
		sig = sig * amp;

		//sig = FreeVerb.ar(sig);

		Out.ar(out,Pan2.ar(sig, SinOsc.ar(pan, mul: 0.4)));
}).add;
)

(
p = a.partials[5].flop; // 5. Partial wird abgespielt

b = Synth(\y, [\freqs, p[0], \amps, p[1]]);
)

//alle partials absipielen
(
a.partials.size; // diese Datei hat 189 parials
b = a.partials.collect{|x, i|
	var partial = a.partials[i].flop;
	Synth(\y, [\freqs, partial[0], \amps, partial[1], \pan, 1]);
}
)

b.do {|x| x.set(\dt, 0.001, \pan, 0.01)}; // passiert zu direkt
(
var polarity = ((-1 ! (b.size/2))++(1 ! (b.size/2))).asArray; // muss so groß sein wie synths ereugt werden
b.do{|x, i| x.set(\detuneamt, 200* i * polarity[i], \trig, 1, \detunetime, 1)};
)

b.do{|x, i| x.set(\detuneamt, 200, \trig, 0, \detunetime, 5)};

(
b.do {|x| x.release(5)};
)

