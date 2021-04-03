SDIFFile {
	var <header;
	var <frames;
	var <numFrames;

	*read{|path|
		^super.new.read(path);		//aus Superclass Object .new aufrufen dann eigene read funktion ausführen
	}

	read{|path|
		File.use(path, "rb", {|file |this.readFromFile(file)}); //not sure about "rb", i used "r" and it was fine
	}

	readHeaderFromFile{

	}

	readFromFile{

	}

}

SDIFFrame {
	var <header;
	var <matrices;
	var <numMatrices;

}

SDIFMatrix1TRC{
	var <header;
	var <array;
	var numRows, numCols;

}
