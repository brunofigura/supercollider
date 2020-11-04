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
	f.getChar(4);
});
)
(
File.use("SDIFtest.sdif".resolveRelative, "r", {|f|
	f.length;
});
)


(
File.use("SDIFtest.sdif".resolveRelative, "r", {|f|

	4.do({f.getChar.post;});

	f.pos.postln;
	f.getInt32.postln;
	f.getInt32.postln;

	4.do({f.getChar;});
	4.do({f.getChar.post;});
	f.getChar;
	f.getChar;
	f.getChar.asAscii;
});
)



(
File.use("SDIFtest.sdif".resolveRelative, "r", {|f|
	if(f.getLine(4) != "SDIF", {
		"Error! Wrong Filetype".error.postln;
	}, {"This is a SDIF File!".postln});
	f.pos.postln;
	f.getInt32;

});
)

(
File.use("SDIFtest.sdif".resolveRelative, "r", {|f|
	a = 4.collect({f.getChar});
	a.asString.postln; // wie kann ich ein Array als String vergleichen
});
)

