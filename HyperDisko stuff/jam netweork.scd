/*
Instruments:'Mridangam', 'pandeiro1', 'ana2', 'amacherFlimmern', 'gong_0', 'gong_1', 'gong_2', 'gong_3', 'kick_electro1'

*/

q.paramNames['Mridangam'];
q.paramNames['pandeiro1'];
q.paramNames['ana2'];
q.paramNames['amacherFlimmern'];
q.paramNames['gong_0'];
q.paramNames['kick_electro1'];


(
Pdef(\BrunoMridangam, Pbind(\instrument, 'Mridangam',
	//\amp, Pwhite(0.01, 0.2,inf),
	\amp, Pseries(0.2, 0.001,2000),
	\dur, Pshuf([0.5, 0.5, 0.25, 1.75, 1.75], inf) * 1/8,
		\note, Pshuf([1, 1, 1, 2, 1, 5], inf),
		\octave, Pseq([Pseq([1], 6), Prand([4,5], 1)], inf),
	)
).play;)

(
Pdef(\BrunoAna2,
	Pbind(\instrument, 'ana2',
		//\amp, Pseq([Pseq([0.05], 9), Pseq([0.1], 3)], inf),
		\amp, Pseq([0.1, 0.1, 0.2], inf),
		\dur, Pshuf([Pseq([0.175], Prand([3, 7, 9], inf)), Pseq([1/2], 2)], inf),
		\note, Pwhite([1, 1, 1, 3, 1, 1], inf),
		\decay, Prand([Pseries(0.1, 0.1, 50)], inf),
		\octave, Pseq([Pseq([4], 9), Prand([1,2,3,4,5,6], 3)], inf),
		\pfreq,100,
		//\rq,,
		//\sfreq,,
		//\t_trig,,
	)
).play;)

(
Pdef(\BrunoPandeiro, Pbind(\instrument, 'pandeiro1',
		\amp, 0.01,
		\dur, Pshuf([Pseq([0.5], 3), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.25 ], 1)], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		//\octave, Pseq([Pseq([1], 6), Prand([3,2,3,4,5,6], 1)], inf),
		\beldec, Prand([Pseries(0, 0.2, 5)], inf),
	)
).play;)





Tdef(\tada, { loop({
	(instrument:'pm', 'dur': 1/8, 'amp': 0.3, 'midinote': 36, mfreq: 1000, mindex: 5).play;
	0.25.wait;
}) }).play;


SynthDef('pm',{|freq=440, mfreq=50, mindex=1, dur=0.1, amp=0.1|
    Out.ar(0,
        Pan2.ar( PMOsc.ar(freq*4, mfreq, mindex, 0, EnvGen.ar( Env.perc(0.01,dur), doneAction: 2 ) * amp))
    )
}).add;