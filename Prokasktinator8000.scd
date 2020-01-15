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
});
)

a = Ndef(\guard);




//idee: über zeit soll bei mod, beide frequenzen in verschieden richtungen wandern


(
SynthDef(\nervotron3000, { |out, amp = 0.3, modamt = 0.2, modattack = 0.5|
	var sig, mod, rampenv;

//rampenv soll mithilfe von env den mod schneller werden lassen
//	rampenv = Env.kr([0, modamt], [modattack]);
	mod = [SinOsc.ar(10),LFTri.ar(15)] * modamt;
	sig = SinOsc.ar(440, mod);
	Out.ar(out, sig.tanh * amp);
}).add;
)

(
x = Synth(\nervotron3000, [
	\modamt, 10;
]);
)

x.free



s.freeAll;
s.reboot;

