SpearFile2
//macht komisches
(
File.use("B:/supercolider-git/supercollider/spear data/SDIFtest.sdif", "r", {|f|
	var fileType, headerSpecialFrameSize, sdifVersion, frameSignature1, frameSize, frameTime, frameStreamID, frameMatrixCount;

	fileType = 4.collect({f.getChar});
	postf("Das Format der Datei ist: % \n", fileType);

	headerSpecialFrameSize = f.getInt32;
	postf("Die Größe des Header Special Frame ist: % \n", headerSpecialFrameSize);

	sdifVersion = f.getInt32;
	postf("SDIF Version: % \n", sdifVersion);

		4.do({f.getChar;});							//Padding FileHeader


	frameSignature1 = 4.collect({f.getChar;});
	postf("Frame 1 Signature: % \n", frameSignature1);

	frameSize = f.getInt32;
	postf("Größe des verbleibenden Frames: % Bytes \n", frameSize);

	frameTime = f.getFloat + f.getFloat;
	postf("Frame enthält Daten für Zeitpunkt: % \n", frameTime);

	frameStreamID = f.getInt32;
	postf("StreamID vom Frame: %\n", frameStreamID);

	frameMatrixCount = f.getInt32;
	postf("Im Frame enthaltene Matrizen: %\n", frameMatrixCount);

	//ab hier Matrixheader
	4.do({f.getChar.post;});					//Matrix signature "1nvt"
	f.pos;

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

