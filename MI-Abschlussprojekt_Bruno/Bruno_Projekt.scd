~path = "spear data/Sdiftest2(RF).sdif"
~path = "spear data/Sdiftest2(EI).sdif"
~path = "spear data/Sdiftest2(RBEP).sdif"



a = ~sdifallFrames.value(~path.resolveRelative);



(
~sdifallFrames = {|path|
	var filePath, fileData, frameData, rowCountTemp, columnCountTemp;
	filePath = path;

	fileData = List.new();

	File.use(filePath, "r", {|f|
		var array = Array.new();
		f.seek(16, 1);						//Jump file header
		f.seek(4, 1);						//Jump frame signature
		f.seek(f.getInt32, 1);				//Jump special frame

		while ({f.pos < File.fileSize(path)}, {						//collects Data from all count of frames

			f.seek(24,1 );						//jump frame header (matrix count always 1 (1TRC))
			f.seek(8, 1);						//jump to matrix column and row count

			rowCountTemp = f.getInt32;
			columnCountTemp = f.getInt32;
			frameData = Array.fill2D(rowCountTemp, columnCountTemp, {arg i; f.getFloat});
			fileData.add(frameData);
		});
		fileData;
	})
}
)