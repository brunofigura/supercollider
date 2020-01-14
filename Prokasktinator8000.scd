/*
- synthdef der ton erzeugt
- synthdef der soundinput mic hat und analysiert wird
- server kommunikation
- eine art timer
*/

// Server zeugs
//ugen -sendreply um antwort von server zu bekommen
SendReply



//such unter analysis ugens!
//man bräuchte OSCdef

//Ndef i = mic

(
Ndef(\guard, {
	var input, sig;
	input = SoundIn.ar(0);
	sig = DelayL.ar(input, 0.3, 0.3);
	//Amplitude.kr(sig, 0.01, 0.01);
	//if (DetectSilence.ar(sig, 0.5, 1, 2) < 1){postln("psssst");
}).play;
)




// KEIN TON

(
SynthDef(\nervotron3000, { | out |
	var freq, sig, trig, env;
	trig = Dust.kr(2);
	env = EnvGen.kr(Env.perc(0.02, 0.5), trig);
	freq = exprand(100, 10000);
	sig = SinOsc.ar(1000, SinOsc(20)) * env;
	Out.ar(out, sig * 0.7)
}).add;
)

x = Synth(\nervotron3000);




s.freeAll;
s.reboot;

