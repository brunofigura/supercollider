//Synthdefs i like:




// the HyperDisCo Quark comes with a collection of sound functions, loaded upon startup.

// have a peek here:
(q.hyperfolder +/+ "libs/").openOS;

// this is the SynthLib;
(q.hyperfolder +/+ "libs/_SynthLib.scd").openOS;

// the variable q.synthDefs collects them all for exploration:
q.synthDefs;

// play a random one with an Event.play:
(instrument: q.synthDefs.choose.postcln).play;

Event.help; // look this up, scroll to Bottom to see which default keys you can use for pitch, amp etc.


(
// explore them all. How long does it take?
Tdef(\exploreSynthDefs, {
	q.synthDefs.do{|sd, i|
		">> playing SynthDef '%', Nr. % from %\n".postf(sd, i, q.synthDefs.size );
		(instrument: sd, pan: i%2*2-1).play;
		0.25.wait;
	}
}).play;
);

// similarly, all SynthDefs that have a freq input are collected in
q.tonalDefs;

(
// explore them all with 3 different pitches. How long does it take?
Tdef(\exploreTonals, {
	q.tonalDefs.do{|sd, i|
		">> playing tonal SynthDef '%', Nr. % from %\n".postf(sd, i, q.tonalDefs.size );
		3.do{|j|
			(instrument: sd, midinote: j+2*24, pan: i%2*2-1).play;
			0.25.wait;
		};
		0.25.wait;
	}
}).play;
);


// all these SynthDef's parameters are stored in a dictionary, too, with the SynthDef's name as key.
q.paramNames;
q.paramNames.keys;
q.paramNames.choose;
q.paramNames['grainFM_a'];

(
// explore all params of 1 sound;
// CAUTION: this can explode some values, providing VERY LOUD sounds !!
Tdef(\exploreParams).set(\mySynthDef, 'grainFM_a');
Tdef(\exploreParams, { |ev|
	var mySynthDef = ev.mySynthDef;
	var myParams = q.paramNames[mySynthDef].postln;

	myParams.keysValuesDo{|param, val, i|
		3.do{|j|
			var nuVal = val * [1/3, 1, 3][j];
			[mySynthDef, param, nuVal].postln;
			(instrument: mySynthDef, pan: i%2*2-1).put(param, nuVal).play;
			 0.25.wait;
		};
		0.25.wait;
	};
	"Tdef explorer ended".postln;
}).play;
);

// explore another one...
Tdef(\exploreParams).set(\mySynthDef, q.synthDefs.choose.postcln ).stop.play;
(
Pdef(\test1,
	Pbind(\instrument, 'grainFM_a',
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175], 1)], inf)* 0.1,
		\decay, Pshuf([0.3, 0.5, 0.7, 1, 1.5], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([0], 7), Prand([1,2,3,4,5,6], 1)], inf),
		\freqFm, Pshuf([100, 300, 500, 900, 300], inf),
		\fmi, 50,

	)
).play;)

q.paramNames['Mridangam'];
(
Pdef(\test1,
	Pbind(\instrument, 'Mridangam',
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.325], 1)], inf)* 0.25,
		\decay, Pshuf([0.3, 0.5, 0.7, 1, 1.5], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([1],Prand([3,5,7,1,2, 2], 1)), Prand([1,2,3,4,5,6], 1)], inf),


	)
).play;)

q.paramNames['pandeiro1'];
(
Pdef(\test1,
	Pbind(\instrument, 'pandeiro1',
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.325], 1)], inf)* 0.5,
		\decay, Pshuf([0.3, 0.5, 0.7, 1, 1.5], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([1],Prand([3,5,7,1,2, 2], 1)), Prand([1,2,3,4,5,6], 1)], inf),


	)
).play;)

q.paramNames['ana2'];
(
Pdef(\test1,
	Pbind(\instrument, 'ana2',
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.325], 1)], inf),
		\decay, Pshuf([0.3, 0.5, 0.7, 1, 1.5], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([4],Prand([3,5,7,1,2, 2], 1)), Prand([1,2,3,4,5,6], 1)], inf),


	)
).play;)

q.paramNames['amacherFlimmern'];
(
Pdef(\test1,
	Pbind(\instrument, 'amacherFlimmern',
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.325], 1)], inf),
		\sustain, Pshuf([0.3, 0.5, 0.7, 1, 1.5], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([4],Prand([3,5,7,1,2, 2], 1)), Prand([1,2,3,4,5,6], 1)], inf),
		\id, Pseq([1, 1, 2], inf),

	)
).play;)

q.paramNames['gong_0'];
(
Pdef(\test1,
	Pbind(\instrument, Prand(['gong_0', 'gong_1', 'gong_2', 'gong_3', 'gong_4', 'gong_5'], inf),
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.325], 1)], inf),
		\decay, Pshuf([0.3, 0.5, 0.7, 1, 1.5], inf),
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([2],Prand([3,5,3,1,2, 2], 1)), Prand([1,2,3,4,5,6], 1)], inf),
		\soft, Pseq([1, 1, 2], inf),

	)
).play;)

q.paramNames['kick_electro1'];
(
Pdef(\test1,
	Pbind(\instrument, 'kick_electro1',
		\dur, Pshuf([Pseq([0.5], 9), Pseq([1, 0.75, 0.5, 0.25, 0.175, 0.325], 1)], inf)*0.5,
		\note, Pshuf([1, 1, 1, 3, 1, 9], inf),
		\octave, Pseq([Pseq([2],Prand([3,5,3,1,2, 2], 1)), Prand([1,2,3,4,5,6], 1)], inf),


	)
).play;)