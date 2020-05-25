

~fieldrec1 = Buffer.read(s,"/export/STE-006.wav".resolveRelative);


SpearFile2.verbose = true;
~file1 = SpearFile2("/spear data/Analysed-Fieldrecording.txt".resolveRelative, s);
~file2 = SpearFile2("/spear data/trump1.txt".resolveRelative, s); // wird falsch eingelesen
~file3 = SpearFile2("/spear data/trump-Press-are-liars(loud).txt".resolveRelative, s);

~file1= ~file1.initPartials;
~file2= ~file2.initPartials;
~file3= ~file3.initPartials;

~file3.partials.flatten.flop // alle Partials hintereinander gereiht
(189*119)
// Ndef soll init partials Datei bekommen und alle Partials enen nacheinander ( von oben nach unten ) abspielen




~file3.partials.flatten.flop.shape


(

SynthDef(\band, {|out, dt = 0.01|
	var sig, envamp,envfreqs,freqs,amps, trig;
	amps = ~file3.partials.flatten.flop.at(1);
	freqs = ~file3.partials.flatten.flop.at(0);
	envamp = EnvGen.ar(Env(amps,[dt], \sine));
	envfreqs = EnvGen.ar(Env(freqs,[dt], \sine), doneAction: 2);

	sig = SinOsc.ar(envfreqs) * envamp * 0.001;
	Out.ar(out, sig ! 2);
}).add;
)
Synth(\band);


().play;''











a = ~file3.partials.flatten.sort {|a, b| a[1] <= b[1]; }

// Funktion für Auswahl n bestimmte Partials
(
~partialselect = {|wdh = 10, array|
	var list, initindex, lastindex, currindex, step, i=0;
	list = List.new(wdh);

	b = array.partials.flatten.select {  arg item, i ; item[1] > 0.06  };

	c = b.flop[0];

	lastindex = c.size - 1 ;
	initindex = rand(lastindex);
	step = rrand(25, wdh);      // Auswahl könnte du eng sein
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

	list.postln.flop;
}
)
~partialselect.(100, ~file3);

//VORSICHT  LAUT UND SCHRILL

(
SynthDef(\sinebank, {|out,teiltöne = 100 ,filterfreq = 50, ampoffset = 2|
	var sig, pairs, amps, freqs;
	pairs = ~partialselect.(teiltöne, ~file1); // wieso geht das nicht
	freqs = pairs.flop[0];
	amps = pairs.flop[1];

	sig = SinOsc.ar(freqs) * (amps + ampoffset);
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, filterfreq);
	sig = Splay.ar(sig, 2);
	//sig = FreeVerb.ar(sig, 0.6, 1, 0.3);
	//sig = LeakDC.ar(sig);
	sig.tanh;
	Out.ar(out, sig);
}).add;
)

g = Synth(\sinebank).set([\teiltöne, 100]); // das will ich machen können


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