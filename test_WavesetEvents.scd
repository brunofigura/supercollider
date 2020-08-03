(
a = WavesetsEvent.read(Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
b = WavesetsEvent.read(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
c = WavesetsEvent.read("B:/supercolider-git/supercollider/export/KavalSviriCut.wav");
WavesetsEvent.prepareSynthDefs;
)



start: from which waveset to start
num: how many wavesets to play
end: up to which waveset to play (if given, overrides num)
repeats: how many times to repeat the selected wavesets
startTime: where to start in the file - will be rounded to the next waveset (if given, overrides start)
endTime: where to end in the file - will be rounded to the next waveset (if given, overrides start)
amp: scale the amplitude of the original sound
wsamp: normalize the amplitude to that value
rate: playback speed of the audio file
rate2: end playback speed of the audio file (will create a linear glisson sweep)
pan: stereo panorama position

(
Tdef(\Kaval, {
	inf.do{|i|
		var event = c.asEvent((start: i % c.size, rate: 1, legato: 1/3));
	event.play;
	event[\dur].wait;
	}
}).play;
)

//add to dictionary
(
Tdef(\rs, {
	var start = 0, num = 1, pan = 0;
	inf.do { |i|
		var event;
		event = c.asEvent((start: start, num: num, rate: -1, pan: pan));
		event.play;
		event[\dur].wait;

		start = start + num % a.size;
		num = rrand(1, 3) * (i / 10 % c.size + 1);
		pan = rand(-1.0, 1.0);
	}
}).play
)
c.add(\one);

(
Pdef(\x,
	Pwavesets(
		Pbind(
			\name, \one,
			\start,
			Pstutter(120, Pseq([
				1000,
				1800,
				98,
				298,
				841,
			], inf)),
			\num, Pn(Pseries(100, 0.6, 80)),
			\repeats, Pstutter(60, Pseries(0, 0.5, 100)),
			\legato,Pbrown(0.3, 1.2, 0.01, inf) ,
			\rate, Pbrown(0.8, 1.2, 0.01, inf),
			\amp, 0.1,
			\pan, Pwhite(-1.0, 1.0)
		)
	)
).play
)

//was hochfreqenteres alla LEAD?!?!?

(
Pdef(\y,
	Pwavesets(
		Pbind(
			\name, \one,
			\start,
			Pstutter(120, Pseq([
				1000,
				1800,
				98,
				298,
				841,
			], inf)),
			\num, Pn(Pseries(100, 0.6, 80)),
			\repeats, Pstutter(60, Pseries(0, 0.5, 100)),
			\legato,Pbrown(0.3, 1.2, 0.01, inf) ,
			\rate, Pbrown(0.8, 1.2, 0.01, inf),
			\amp, 0.1,
			\pan, Pbrown(-1, 1, 0.2)
		)
	)
).play
)