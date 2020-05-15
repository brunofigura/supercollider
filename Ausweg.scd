

~fieldrec1 = Buffer.read(s,"/export/STE-006.wav".resolveRelative);


SpearFile2.verbose = true;
~file = SpearFile2("/spear data/Analysed-Fieldrecording.txt".resolveRelative, s);

a= ~file.initPartials;
a = a.partials.select { |x| x.any { |pair| pair[1] > 0.05 } }
// ich habe ein Problem damit Pärchen mit zu leise Amplitude aus der Liste zu packen





// Funktion für Auswahl n bestimmte Partials
(
~partialselect = {|wdh = 10|
	var list, initindex, lastindex, currindex, step, i=0;
	list = List.new(wdh);

	b = a.flatten;

	c = b.flop[0];

	lastindex = c.size - 1 ;
	initindex = rand(lastindex);
	step = rrand(50, wdh);      // Auswahl könnte du eng sein
	currindex = initindex;

		while ({(currindex + step.value < lastindex)&&(i <wdh)},{
			currindex = currindex + step.value;
			list.add(b.[currindex]);
			step.postln;
			i = i + 1;
		});
	i = 0;
		while ({(currindex + step.value >= lastindex)&&(i <wdh)}, {
			currindex = currindex - step.value;
			list.add(b.[currindex]);
		});

	list.flop;
}
)
~partialselect.(100).flop;

//VORSICHT  LAUT UND SCHRILL

(
Ndef(\sinebank, {|teiltöne = 10, ampoffset = 0|
	var sig, pairs, amps, freqs;
	pairs = ~partialselect.(200);
	freqs = pairs.flop[0];
	amps = pairs.flop[1];

	sig = SinOsc.ar(freqs) * (amps + ampoffset);
	sig = LeakDC.ar(sig);
	sig = Splay.ar(sig, 1);
	sig = FreeVerb.ar(sig, 0.6, 1, 0.3);
	sig = LeakDC.ar(sig);
	sig;
}).play;
)




(
Ndef(\fieldrec, {|trig = 1, start = 0, loop = 1, rate = 1|
	var sig;
	sig = PlayBuf.ar(2,~fieldrec1,rate, trig, start, loop);
	sig = HPF.ar(sig, 200);
	sig = Splay.ar(sig, 2);
});
)
//tests
Ndef(\fieldrec).set(\trig, 1, \rate, 3).play;