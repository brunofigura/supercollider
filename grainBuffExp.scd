//
init//
//path to audio
p = Platform.resourceDir +/+ "sounds/pianoImprov.wav";

//audio buffer
b = Buffer.readChannel(s, p, channels: [0]);		//Grainbuff kann nur mit Monobuffer was anfangen!
//
init//
//


b.play;
(
SynthDef.new(\default, {|out|
	var sig;
	sig = GrainBuf.ar(numChannels: 1,
		trigger: Impulse.ar(4),
		dur: 0.1,
		sndbuf: b,
		rate: 1,
		pos: rrand(0, 1.0)!2,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 1048,
		mul: EnvGen.ar(Env([1,0], [1]), doneAction: Done.freeSelf),
		add: 0
	);
	Out.ar(out, sig);
}).add;
)

().play;

// jetzt nicht mit default synth benutzen

(
SynthDef.new(\grainz, {|out, dur = 0.5, pan = 0, rate = 1, att = 0, rel = 4|
	var sig;
	sig = GrainBuf.ar(numChannels: 1,
		trigger: Dust.ar([45, 43]),
		dur: dur,
		sndbuf: b,
		rate: rate,
		pos: Rand(0.0, 1.0)!2,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 1048,
		mul: EnvGen.ar(Env([0, 1,0], [att, rel]), doneAction: Done.freeSelf),
		add: 0
	);
	sig = PanAz.ar(2, sig, pan);
	Out.ar(out, sig);
}).add;
)

(instrument: \grainz, dur: rand(0.025, 0.05), rate: 0.midiratio).play;


/*
neuster Plan. 2 Unterschiedliche Spacialisation Methoden überlegen und 2 unterschiedliche trigger Konditionen und damit dann Pdefs bauen.
*/



/*
Wie möchte ich das System benutzen?

- live codebar
- beim spielen eingreifen können mit möglichkeit von direkter UND langsamer klangveränderung
- midi steuerbar
- versch positionen-auswahl typen auswählbar. trueRandom, nur unterschiedliche Auswertung random ( RAND.ar), diskrete Werteermittlungen,

- added bonus: mit sensorik steuern
*/

/*
pitch shifter ausprobieren :D
*/

(
SynthDef.new(\granulator, {
	arg out, densityL = 5, densityR = 6, dur = 1, rate = 1, pos = 0.5, interp = 2, att = 0, rel = 0.5, pan = 0;
	var sig;
	sig = GrainBuf.ar(
		numChannels: 1,
		trigger: Dust.ar([densityL, densityR]),
		dur: dur,
		sndbuf: b,
		rate: rate,
		pos: pos,
		interp: interp,
		pan: 0,
		envbufnum: -1,
		maxGrains: 1048,
		mul: EnvGen.ar(Env([0, 1,0], [att, rel]), doneAction: Done.freeSelf),
		add: 0
	);
	sig = PanAz.ar(2, sig, pan);
	Out.ar(out, sig);
}).add;
)

(instrument: \granulator, dur: rand(0.025, 0.05), rate: 0.midiratio).play;

(
Pdef(\x,
	Pbind(\instrument, \granulator,
		\pos, Prand([0.1, 0.2, 0.3, 0.4], inf),
		\rel, Pseq([0.5, 0.5, 2, 1], inf),
		\densityL, 5,
		\densityR, 6
	)
).play;
)