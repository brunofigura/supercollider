(
SynthDef(\x, {|out, gate = 1, amp = 0.1, dt = 0.1, pan = 0, detune = 0|		//detune um später stauchen und strecken zu können ( vielleicht muss die methode geändert werden)
	var freqs = \freqs.ir(440 ! 16); //man kann dem synth ein16 großes array mit freqs als arg übergeben
	var amps = \amps.ir(1 ! 16); // zum test wird das erstmal nicht benutzt

	var env = EnvGen.kr(Env.asr, gate,doneAction: 2);
	var envfreq = EnvGen.ar(Env(freqs, dt ! freqs.size, curve: \sin).circle(dt)).poll;
	var envamp = EnvGen.ar(Env(amps, dt ! freqs.size).circle(dt));

	var sig = SinOsc.ar(envfreq + detune) * envamp * env;
		sig = sig * amp;

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


// mit .do mehrere Synths erzeugen