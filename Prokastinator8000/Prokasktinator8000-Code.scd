
(
fork {
	~synthindex = 0;
	~syntharray = [\nervotron1000, \nervotron2000, \nervotron3000, \nervotron4000, \nervotron5000];
	~synthliste = List(8);


	SynthDef(\nervotron3000, { |out, amp = 0.3, modamt = 10, modfreq = 200, moddur = 2, gate = 1|
		var sig, mod, modenv, modtrig, env;												//modfreq-> freq wo der mod startet ( er geht 			dann bis null und 																				bis 2 * modfreq)
	modtrig = Impulse.kr(1/moddur);
	modenv = Env.new([0, (modfreq - 1), 0], [(moddur/2), (moddur/2)], 'lin').ar(0, modtrig);
	mod = [SinOsc.ar(modfreq - modenv),LFTri.ar(modfreq + modenv)] * modamt;				//basefreq +- env
	env = Env.adsr(0.01, 0, 1, 3, 1).ar(2, gate);
	sig = LeakDC.ar(SinOsc.ar(1000, mod) ! 2 * env);
	Out.ar(out, sig.tanh * amp);
	}).add;


	SynthDef(\nervotron2000, {|out = 0, amp = 0.3, modamt = 10, modfreq = 40, moddur = 5, gate = 1|
	var sig, mod, modenv, trig, env;
	trig = Impulse.kr(moddur);
	modenv = Env.new([0, modamt.clip(1)], [moddur]).ar(0, trig) * 10;					//clip, damit modamt nicht zu hoch übergeben 			werden kann
	mod = SinOsc.ar(modfreq * modenv);
	env = Env.adsr(0.01, 0, 1, 3, 1).ar(2, gate);
	sig = SinOsc.ar([800, 201], mod) * env;
	Out.ar(out, sig * amp);
	}).add;


	SynthDef(\nervotron1000, {|out = 0, gate = 1, amp = 0.3|
	var sig, mod, modenv, trig, env;
	trig = Impulse.kr(1);
	modenv = Env.new([0, 1, 0], [0.25, 0.75], loopNode: 0).ar(0, trig) * 1000;
	mod = SinOsc.ar(50) * modenv;
	env = Env.adsr(0.01, 0, 1, 3, 1).ar(2, gate);
	sig = SinOsc.ar([1000, 999], mod) * env;
	Out.ar(out, sig * amp);
	}).add;


	SynthDef(\nervotron4000, { |out, gate = 1, amp1 = 0.4, amp2 = 0.2, modfreq = 0.5, modamt = 3, dist = 10000|
	var sig1, sig2, env, env2 , freqenv, trig, env2mod;
	trig = LFPulse.ar(1/modfreq);
	env = Env.adsr(0.4, 0, 1, 1, 1).ar(2, gate);
	freqenv = Env([1, modamt, 1], [modfreq/2, modfreq/2]).ar(0, trig);
	sig1 = SinOsc.ar([400, 340] * freqenv) * env;
	Out.ar(out, sig1.tanh * amp1);

	env2mod = Env([3, 1, 3], [10, 10]).ar(0);
	env2 = LFPulse.ar(env2mod/modfreq);
	sig2 = LFSaw.ar([150, 155]) * env2 * dist;
	Out.ar(out, sig2.tanh * amp2);
	}).add;



	SynthDef(\nervotron5000, {|out, rate = 3, density = 13|
	var sig, trig, window, env;
	trig = Dust.ar(density);
	env = Env.perc(0.01, 0.2).ar(0, trig);
	window = LFPulse.ar(rate);

	sig = SinOsc.ar([8000, 8100]) * env;
	sig = sig * window;

	Out.ar(out, sig.tanh);
	}).add;


s.sync;

	Ndef(\guard, {
	var in, amp, trig;
	trig = Impulse.ar(2);
	in = SoundIn.ar(0);
	amp = Amplitude.kr(in, 0.01, 0.01);
	SendReply.ar(trig, '/amp', amp);
	0;
	}).play;

s.sync;
	{
	var timeDelta, startTime, running;
	timeDelta = 0;
	running = false;
	~ausloeser =
	{|msg, time|
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
 		~synthliste.add(Synth(~syntharray[~synthindex % ~syntharray.size]));
	};
	[running, timeDelta, amp].postln;
	};

	~stoppen = {
	~synthliste.do{|item|
		item.set(\gate, 0);
		item.postln;
	};

	~synthliste.clear;
	~synthindex = ~synthindex +1;
	}}.value;





	~starten = {
	var timeDelta;
	OSCdef(\ausloeser, {|msg, time|~ausloeser.value(msg, time, timeDelta);
	}, '/amp');
	}
})



