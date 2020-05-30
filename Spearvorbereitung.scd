(
SynthDef(\x, {|out, gate = 1, amp = 0.05, dt = 0.1, pan = 0, detuneamt = 0, detunespeed = 0, detunephase = 0|		//detune um später stauchen und strecken zu können ( vielleicht muss die methode geändert werden)
	var freqs = \freqs.ir(440 ! 16); //man kann dem synth ein16 großes array mit freqs als arg übergeben
	var amps = \amps.ir(1 ! 16); // zum test wird das erstmal nicht benutzt

	var mod = SinOsc.ar(detunespeed,phase: detunephase , mul: detuneamt);

	var env = EnvGen.kr(Env.asr, gate,doneAction: 2);
	var envfreq = EnvGen.ar(Env(freqs, dt ! freqs.size, curve: \sin).circle(dt)).poll;
	var envamp = EnvGen.ar(Env(amps, dt ! freqs.size).circle(dt));

	var sig = SinOsc.ar(envfreq + mod) * envamp * env;
		sig = sig * amp;

		sig = FreeVerb2.ar(sig, sig, room: 0.7, damp: 0);

		Out.ar(out,Pan2.ar(sig, pan));
}).add;
)

Synth(\x);

(
Synth(\x, [
	\freqs, [220, 330, 440, 220, 440, 550, 330, 220, 550, 330],
	\amps, [0.5, 1, 2, 1, 0.6, 0.7, 0.3, 1],
	\dt, 1]);
)




(
b = {Synth(\x,[\freqs, {exprand(220, 990)}! 16])} ! 16;
)

(
b.do {|x| x.release(5)};
)

//jede synthinstanz soll eine unterschidliche random detune bewegung haben
(
b = {Synth(\x,[\freqs, 300 ! 16] )} ! 8;
)

(
b.do {|x| x.set(\detune, 55)} // kann ich hier auch Ugens reinschreiben?
)
({rand(5, 19)} ! 6).postln.at(0) // das geht, aber das dadrunter nicht
(
b.do {|x| x.set(\detuneamt, ({rand(0.0, 120.0)} ! 8).at(x),    // ich würde gerne für jeden synth andere detune Werte ( am liebsten zufällig bestimmt)
				\detunephase, ({rand(0.0, 2.0)} ! 8).at(x),
				\detunespeed, ({rand(0.0, 3.0)} ! 8).at(x),
)}
)


(
b.do {|x| x.release(5)};
)