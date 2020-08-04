OSCRouterClient.groups['hyperIMM'].peers.printAll;

(
Ndef(\bruno, {arg amp = 0.4;
	var trig = LFPulse.ar(1);
	var env = Env.perc(0.01, 1, 1, \sin).ar(trig);
	var sig = SinOsc.ar(1000, SinOsc.ar(300, 0, 4)) * amp;
	sig;
}).play;)


Ndef(\bruno).set(\amp, 0.6);

q.synthDefs[1];

3.do{Synth(\SOShats);

};
q.Synthdefs
(
Tdef(\kickz, {
	inf.do{|sd, i|(instrument: 'SOSkick', amp: [0.1, 0.1, 0.2, 0.1].choose, freq:exprand(50, 400)).play;
		[0.5, 0.25, 0.25, 0.25, 0.175, 0.175].choose.wait;
	}
}).play;)

q.tonalDefs.choose
(
Tdef(\bruno,{arg anzahlAnDefs = 6;
	var inst = [\fooA, \pfeifchen, \Mridangam, \grainFM_b];
	var freqs = 100.collect{exprand(50, 1000)};
	var dur = 0.2;

	inf.do{|i|(instrument: inst.choose, freq: [freqs.choose, freqs[i]]).play;
		 dur.wait;
	}

}).play;)


// 5 Pdefs machen!