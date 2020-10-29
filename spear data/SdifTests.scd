SpearFile2
//macht komisches
(
File.use("B:/supercolider-git/supercollider/spear data/SDIFtest.sdif", "r", {|f|
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
	f.getLine.postln;
});
)

//macht komisches aber anders als getLine
(
File.use("B:/supercolider-git/supercollider/spear data/SDIFtest.sdif", "r", {|f|
	f.getChar;
	f.getChar;
	f.getChar;
	f.getChar;
	f.getChar;
});
)
//wirft "random" Zahlen aus abhängig ob man Int8, INt16, Int32, Int32LE
(
File.use("B:/supercolider-git/supercollider/spear data/SDIFtest.sdif", "r", {|f|
	f.getInt32;
});
)