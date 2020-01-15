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
	var in, amp, trig;
	trig = Impulse.ar(2);
	in = SoundIn.ar(0);
	amp = Amplitude.kr(in, 0.01, 0.01);
	SendReply.ar(trig, '/amp', amp);
	0;					//sicherung gegen DC
}).play;
)
(
var timeDelta, startTime, running;
timeDelta = 0;
running = false;
OSCdef(\auslöser, {|msg, time|
	var thresh, amp;
	thresh = 0.001;
	amp = msg[3];
	if(amp < thresh){
		if(running){
			timeDelta = time - startTime;
		}{
			running = true;
			startTime = time;
		};
	}{
		timeDelta = 0;
		running = false;
	};
	if(timeDelta > 2){
//hier kommt synthdef rein


	};
[running, timeDelta, amp].postln;
}, '/amp')
)





//idee: über zeit soll bei mod, beide frequenzen in verschieden richtungen wandern


(
SynthDef(\nervotron3000, { |out, amp = 0.3, modamt = 0.2, modattack = 0.5, modendfreq = 1000|
	var sig, mod, rampenv, modfreq;

//rampenv soll mithilfe von env den mod schneller werden lassen
//	rampenv = Env.kr([0, modamt], [modattack]);
	modfreq = Env.new([0, 1, 0.5, 0.3], [4,2,4]).ar(0)* modendfreq;
	mod = [SinOsc.ar(modfreq),LFTri.ar(modfreq)] * modamt;
	sig = LeakDC.ar(SinOsc.ar(440, mod));
	Out.ar(out, sig.tanh * amp);
}).add;
)

(
x = Synth(\nervotron3000, [
	\modamt, 10;
]);
)
x.free;

