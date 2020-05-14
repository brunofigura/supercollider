~fieldrec1 = Buffer.read(s,"/Users/brunofigura/GitHub/supercollider/export/STE-006.wav");

SpearFile2.verbose = true;
~file = SpearFile2("/Users/brunofigura/GitHub/supercollider/spear data/Analysed-Fieldrecording.txt", s);

(
Ndef(\fieldrec, {|trig = 1, start = 0, loop = 1, rate = 1|
	var sig;
	sig = PlayBuf.ar(2,~fieldrec1,rate, trig, start, loop);
	sig = Splay.ar(sig, 2);
});
)
//tests
Ndef(\fieldrec).set(\trig, 1, \loop, 1).play;