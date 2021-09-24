~file1 = SpearFile2("B:/supercolider-git/supercollider/spear data/trump-Im-Really-Rich.txt", s);
~file1 = ~file1.initPartials;
a = ~file1
a.partials[5].flop[0].size // ein partial hat 119 frequenzen
(
SynthDef(\test, {
	arg out = 0, amp = 0.4, pan = 0;

	var freqs = \freqs.ir(440 ! 90);
	var amps = \amps.ir(0.4, 90);

	//noch nicht fertig
}).add;
)


