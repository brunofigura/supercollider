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
~synthliste = List(8);

(
SynthDef(\nervotron3000, { |out, amp = 0.3, modamt = 10, modfreq = 200, moddur = 2, gate = 1|
	var sig, mod, modenv, modtrig, env;												//modfreq-> freq wo der mod startet ( er geht dann bis null und 																				bis 2 * modfreq)
	modtrig = Impulse.kr(1/moddur);
	modenv = Env.new([0, (modfreq - 1), 0], [(moddur/2), (moddur/2)], 'lin').ar(0, modtrig);
	mod = [SinOsc.ar(modfreq - modenv),LFTri.ar(modfreq + modenv)] * modamt;				//basefreq +- env
	env = Env.adsr(0.01, 0, 1, 3, 1).ar(2, gate);
	sig = LeakDC.ar(SinOsc.ar(1000, mod) ! 2 * env);
	Out.ar(out, sig.tanh * amp);
}).add;
)

(SynthDef(\nervotron2000, {|out = 0, amp = 0.3, modamt = 10, modfreq = 40, moddur = 5, gate = 1|
	var sig, mod, modenv, trig, env;
	trig = Impulse.kr(moddur);
	modenv = Env.new([0, modamt.clip(1)], [moddur]).ar(0, trig) * 10;					//clip, damit modamt nicht zu hoch übergeben werden kann
	mod = SinOsc.ar(modfreq * modenv);
	env = Env.adsr(0.01, 0, 1, 3, 1).ar(2, gate);
	sig = SinOsc.ar([800, 201], mod) * env;
	Out.ar(out, sig * amp);
}).add;
)
//test synthdef 2000
Synth(\nervotron2000, [\modfreq, 800]).play;

(SynthDef(\nervotron1000, {|out = 0, gate = 1, amp = 0.3|
	var sig, mod, modenv, trig, env;
	trig = Impulse.kr(1);
	modenv = Env.new([0, 1, 0], [0.25, 0.75], loopNode: 0).ar(0, trig) * 1000;
	mod = SinOsc.ar(50) * modenv;
	env = Env.adsr(0.01, 0, 1, 3, 1).ar(2, gate);
	sig = SinOsc.ar([1000, 999], mod) * env;
	Out.ar(out, sig * amp);
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
~timeDelta = 0;
running = false;
OSCdef(\ausloeser, {|msg, time|
	var thresh, amp;
	thresh = 0.001;
	amp = msg[3];
	if(amp < thresh){
		if(running){
			~timeDelta = time - startTime;

		}{
			running = true;
			startTime = time;
		};
	}{
		~timeDelta = 0;
		running = false;
	};
	if(~timeDelta > 2){
 		~synthliste.add(Synth(~syntharray[~synthindex % ~syntharray.size]));
	};
[running, ~timeDelta, amp].postln;
}, '/amp')
)

(
{
	~synthliste.do{|item|
		item.set(\gate, 0);
		item.postln;
	};

	~synthliste.clear;
	~synthindex = ~synthindex +1;
	~timeDelta = 0;
}.value;
)

s.queryAllNodes;
Node
//(CHECK)-------idee: über zeit soll bei mod, beide frequenzen in verschieden richtungen wandern
//(CHECK)-------modenv soll loopen
// panning der kanäle mit lfo


//gestartete Synth werden in Liste gepackt
//Liste:

x.free;

