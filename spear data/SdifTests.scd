SpearFile2
//macht komisches
(
File.use("B:/supercolider-git/supercollider/spear data/SDIFtest.sdif", "r", {|f|
	var fileType, headerSpecialFrameSize, sdifVersion, frameSignature1, frameSize, frameTime, frameStreamID, frameMatrixCount;

	fileType = 4.collect({f.getChar});								//wie kann ich das als String speichern und ausgeben?
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
	8.do({f.getChar.asAscii.post;});			//nach meiner Idee sollten hier 8 ASCII Symbole ausgegeben werden.

	//Wie komme ich an name value pairs innerhalb von "{}", wenn alles in ASCII ist?
});
)

