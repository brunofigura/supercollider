/*
- synthdef der ton erzeugt
- synthdef der soundinput mic hat und analysiert wird
- server kommunikation
- eine art timer
*/

// Server zeugs
//ugen -sendreply um antwort von server zu bekommen

//such unter analysis ugens!
//man bräuchte OSCdef

~synthindex = 0;
~syntharray = [\nervotron1000, \nervotron2000, \nervotron3000];


(
SynthDef(\nervotron3000, { |out, amp = 0.3, modamt = 10, modfreq = 200, moddur = 2|
	var sig, mod, modenv, modtrig;												//modfreq-> freq wo der mod startet ( er geht dann bis null und 																				bis 2 * modfreq)
	modtrig = Impulse.kr(1/moddur);
	modenv = Env.new([0, (modfreq - 1), 0], [(moddur/2), (moddur/2)], 'lin').ar(0, modtrig);
	mod = [SinOsc.ar(modfreq - modenv),LFTri.ar(modfreq + modenv)] * modamt;				//basefreq +- env
	sig = LeakDC.ar(SinOsc.ar(440, mod));
	Out.ar(out, sig.tanh * amp);
}).add;
)

(SynthDef(\nervotron2000, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1/2);
	modenv = Env.new([0, 1, 0], [1, 1], loopNode: 0).ar(0, trig) * 10;
	mod = SinOsc.ar(40) * modenv;
	sig = SinOsc.ar([800, 201], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

(SynthDef(\nervotron1000, {|out = 0|
	var sig, mod, modenv, trig;
	trig = Impulse.kr(1);
	modenv = Env.new([0, 1, 0], [0.25, 0.75], loopNode: 0).ar(0, trig) * 1000;
	mod = SinOsc.ar(50) * modenv;
	sig = SinOsc.ar([1000, 999], mod) * 0.3;
	Out.ar(out, sig);
}).add;
)

(
Ndef(\guard, {
	var in, amp, trig;
	trig = Impulse.ar(2);
	in = SoundIn.ar(0);
	amp = Amplitude.kr(in, 0.01, 0.01);
	SendReply.ar(trig, '/amp', amp);
	0;
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
 a = Synth(~syntharray[~synthindex % ~syntharray.size]);
			~synthindex = ~synthindex+1;
)

	};
[running, timeDelta, amp].postln;
}, '/amp')
)

a.free;



//(CHECK)-------idee: über zeit soll bei mod, beide frequenzen in verschieden richtungen wandern
//(CHECK)-------modenv soll loopen
// panning der kanäle mit lfo





x.free;

