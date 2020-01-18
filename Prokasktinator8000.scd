
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
OSCdef(\ausloeser, {|msg, time|
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
(
x = Synth(\nervotron3000, [
	\modamt, 10;
]);
)

	};
[running, timeDelta, amp].postln;
}, '/amp')
)





//(CHECK)-------idee: über zeit soll bei mod, beide frequenzen in verschieden richtungen wandern
//(CHECK)-------modenv soll loopen
// panning der kanäle mit lfo


(
SynthDef(\nervotron3000, { |out, amp = 0.3, modamt = 0.2, modfreq = 200, moddur = 2|
	var sig, mod, modenv, modtrig;												//modfreq-> freq wo der mod startet ( er geht dann bis null und 																				bis 2 * modfreq)
	modtrig = Impulse.kr(1/moddur);
	modenv = Env.new([0, (modfreq - 1), 0], [(moddur/2), (moddur/2)], 'lin').ar(0, modtrig);
	mod = [SinOsc.ar(modfreq - modenv),LFTri.ar(modfreq + modenv)] * modamt;				//basefreq +- env
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

