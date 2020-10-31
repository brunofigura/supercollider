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
	f.contents;
});
)


(
File.use("SDIFtest.sdif".resolveRelative, "r", {|f|
	f.next
});
)



(
File.use("SDIFtest.sdif".resolveRelative, "r", {|f|
	if(f.getLine != "SDIF", {
		"Error! Wrong Filetype".error.postln;
	}, {"This is a SDIF File!"});


});
)