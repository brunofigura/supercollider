// SpearFile2
~path = "spear data/SDIFtest(exact interplated).sdif"
~path = "spear data/SDIFtest(rbep).sdif"
~path = "spear data/SDIFtest.sdif"
~path = "spear data/Sdiftest1(RF).sdif"
~path = "spear data/Sdiftest1(EI).sdif"
~path = "spear data/Sdiftest1(RBEP).sdif"
~path = "spear data/Sdiftest2(RF).sdif"
~path = "spear data/Sdiftest2(EI).sdif"
~path = "spear data/Sdiftest2(RBEP).sdif"
~path = "spear data/Sdiftest3(RF).sdif"
~path = "spear data/Sdiftest3(EI).sdif"
~path = "spear data/Sdiftest3(RBEP).sdif"
~path = "lick5.sdif"
~path = "trump.sdif"
~path = "tamtam.res.sdif"

// nicht nach anzahl Frames sondern alle Frames
a = ~sdifallFrames.value(~path.resolveRelative);


// too much data!!!!
// lets break it down to the top 10 partials per frame

(
File.use(~path.resolveRelative, "r", { |f|
	var fileType, headerSpecialFrameSize, sdifVersion, frameSignature1, frameSize, frameTime, frameStreamID, frameMatrixCount, frameSize1, frameTime1, frameStreamID1, frameMatrixCount1, matrixSignature, matrixDataType, rowCount, columnCount, matrixSignature1, matrixDataType1, rowCount1, columnCount1, firstFrameData;

	fileType = 4.collect({ f.getChar });								//wie kann ich das als String speichern und ausgeben?
	postf("File format: % \n", fileType.join);

	headerSpecialFrameSize = f.getInt32;
	postf("Size Header special frame: % \n", headerSpecialFrameSize);

	sdifVersion = f.getInt32;
	postf("SDIF Version: % \n", sdifVersion);

	4.do({ f.getChar });							//Padding FileHeader

	frameSignature1 = 4.collect({ f.getChar }).join;
	//frameSignature1 = String.fill(4, { f.getChar });
	postf("Frame 1 Signature: % \n", frameSignature1);

	frameSize = f.getInt32;
	postf("Size remaining Frame: % Bytes \n", frameSize); //ausgeschlossen sind: signature und size
	postln(f.pos);

	f.seek(frameSize, 1);
	frameTime = f.getDouble;
	postf("Frame store data at time: % \n", frameTime);

	frameStreamID = f.getInt32;
	postf("StreamID Frame: %\n", frameStreamID);

	frameMatrixCount = f.getInt32;
	postf("Number matrices in Frame: %\n", frameMatrixCount);

	postln(f.pos);
	//ab hier Matrixheader
	matrixSignature = 4.collect{f.getChar}.join;
	postf("Matrix 1 Signature: % \n", matrixSignature);//Matrix signature "1nvt"

	matrixDataType = f.getInt32;
	postf("Matrix 1 DataType: % \n", matrixDataType.asHexString);

	rowCount = f.getInt32;
	postf("Matrix 1 row count: % \n", rowCount);

	columnCount = f.getInt32;
	postf("Matrix 1 column count: % \n", columnCount);

	f.pos.postln;			//ist hier Specialframe zu ende? Anscheinend ja, ich ging davon aus dass in der Matrix was steht. Nachdem ich die "überschaut habe " macht das ergebnis für den zweiten Frame mehr Sinn als davor



/*	16.do({ f.getChar.asAscii.post});			//nach meiner Idee sollten hier 8 ASCII Symbole ausgegeben werden.
	16.do({ f.getChar});
	f.pos;*/



	frameSignature1 = 4.collect({ f.getChar }).join;
	//frameSignature1 = String.fill(4, { f.getChar });
	postf("\n\n\n\n\nFrame 2 Signature: % ", frameSignature1);

	frameSize1 = f.getInt32;
	postf("\nGröße des verbleibenden Frames: % Bytes ", frameSize1); //ausgeschlossen sind: signature und size
	postln(f.pos);
	frameTime1 = f.getDouble;
	postf("\nFrame enthält Daten für Zeitpunkt: % ", frameTime1);

	frameStreamID1 = f.getInt32;
	postf("\nStreamID vom Frame: %", frameStreamID1);

	frameMatrixCount1 = f.getInt32;
	postf("\nIm Frame enthaltene Matrizen: %\n", frameMatrixCount1);

	/*matrixSignature1 = 4.collect{f.getChar}.join;
	postf("Matrix 2 Signature: % \n", matrixSignature1);//Matrix signature "1nvt"

	matrixDataType1 = f.getInt32;
	postf("Matrix 2 DataType: % \n", matrixDataType1.asHexString);

	rowCount1 = f.getInt32;
	postf("Matrix 2 row count: % \n", rowCount1);

	columnCount1 = f.getInt32;
	postf("Matrix 2 column count: % \n", columnCount1);*/



	/*First real Matrix Data

	columnCount1.do{f.getFloat.postln}; //row1
	columnCount1.do{f.getFloat.postln}; //row2
	columnCount1.do{f.getFloat.postln}; //row3*/
	/*firstFrameData = Array.fill2D(rowCount1, columnCount1, {arg i; f.getFloat});
	//-> Array mit allen Infos aus erstem Frame

	firstFrameData.postln;*/



});
)

(
~sdif = {|path|
	var filePath, firstFrameData, rowCountTemp, columnCountTemp;
	filePath = path;

		File.fileSize(path).postln;

	File.use(filePath, "r", {|f|
		var array = Array.new();
		f.seek(16, 1);						//Jump file header
		f.seek(4, 1);						//Jump frame signature
		f.seek(f.getInt32, 1);				//Jump special frame

		f.seek(24,1 );						//jump frame header (matrix count always 1 (1TRC))
		f.seek(8, 1);						//jump to matrix column and row count

		rowCountTemp = f.getInt32;
		columnCountTemp = f.getInt32;
		firstFrameData = Array.fill2D(rowCountTemp, columnCountTemp, {arg i; f.getFloat});
	})
}
)
