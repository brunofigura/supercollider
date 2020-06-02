(
SynthDef(\x, {|out, gate = 1, amp = 0.05, dt = 0.1, pan = 0, detuneamt = 0, detunespeed = 0, detunephase = 0|		//detune um später stauchen und strecken zu können ( vielleicht muss die methode geändert werden)
	var freqs = \freqs.ir(440 ! 16); //man kann dem synth ein16 großes array mit freqs als arg übergeben
	var amps = \amps.ir(1 ! 16); // zum test wird das erstmal nicht benutzt

	var mod = SinOsc.ar(detunespeed,phase: detunephase , mul: detuneamt);

	var env = EnvGen.kr(Env.asr, gate,doneAction: 2);
	var envfreq = EnvGen.ar(Env(freqs, dt ! freqs.size, curve: \sin).circle(dt));
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
b = {Synth(\x,[\freqs, 300 ! 16, \amp, 0.01])} ! 7;
)


(
var size = b.size;

var amt = {rrand(0.0, 15)} ! size;
var phase = {rrand(0.0, 2.0)} ! size;
var speed ={rrand(0.0, 1.0)} ! size;
b.do {|x, i| x.set(\detuneamt, amt.at(i),
					\detunephase, phase.at(i),
					\detunespeed, speed.at(i))
}
)

(
b.do {|x| x.release(5)};
)