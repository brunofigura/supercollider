~data2 = SDIFFile.read("B:/supercolider-git/supercollider/spear data/trump.sdif");

~data2.headerSpecialFrameSize;


[[1, 200, 0.5, 0], [2, 300, 0.5, 0], [3, 400, 0.5, 0], [4, 500, 0.5, 0], [5, 600, 0.5, 0]]

//MacOS Pfad"/Users/brunofigura/Documents/supercollider_git/writtenData/test1.sdif"
//creating SDIF file with File header

(
f = File.new("B:/supercolider-git/supercollider/writtenData/test1.sdif", "w");					//Windows Pfad
//f = File.new("/Users/brunofigura/Documents/supercollider_git/writtenData/test1.sdif", "w");		//MacOS Pfad

var frameSize = 16;

f.write("SDIF");				//signature "SDIF"
f.putInt32(8);			//Header Special Frame Size
f.putInt32(2);				//SDIF Specification Version
f.write("'/0'");				//Padding

//1Frame
f.write("1TRC");
f.putInt32(frameSize);
f.putDouble(0);			//Time
f.putInt32(1);			//StreamID
f.putInt32(1);			//numMatrices

//1MatrixHeader
f.write("1TRC");
f.putInt32(004);		//Datatype: float
f.putInt32(5);			//num Rows
f.putInt32(4);			// num Collumns-> id, freq, amp, phase

var dataMatrix = [[1, 200, 0.5, 0], [2, 300, 0.5, 0], [3, 400, 0.5, 0], [4, 500, 0.5, 0], [5, 600, 0.5, 0]];
f.close;
)

//FRAGE: was ist dieses Padding???
g = File.open("/Users/brunofigura/Documents/supercollider_git/writtenData/test1.sdif", "r");		//MacOS Pfad
g = File.open("B:/supercolider-git/supercollider/writtenData/test1.sdif","r");
g.getLine(4);
g.seek(4,0);
g.getInt32();
g.getInt32();
g.seek(12,0);
g.getLine(4);
g.close;

~data = SDIFFile.read("B:/supercolider-git/supercollider/writtenData/test1.sdif");
~data = SDIFFile.read("/Users/brunofigura/Documents/supercollider_git/writtenData/test1.sdif"); //MacOS Pfad


~data.headerSpecialFrameSize;