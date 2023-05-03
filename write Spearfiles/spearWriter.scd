~data2 = SDIFFile.read("B:/supercolider-git/supercollider/spear data/trump.sdif");

~data2.headerSpecialFrameSize;

//creating SDIF file with File header

(
f = File.new("B:/supercolider-git/supercollider/writtenData/test1.sdif", "w");

f.write("SDIF");				//signature "SDIF"
f.putInt32(8);			//Header Special Frame Size
f.putInt32(2);				//SDIF Specification Version
f.write("'/0'");				//Padding
f.close
)

//FRAGE: was ist dieses Padding???

g = File.open("B:/supercolider-git/supercollider/writtenData/test1.sdif","r");
g.getLine(4);
g.seek(4,0);
g.getInt32();
g.seek(8,0);
g.getInt32();
g.seek(12,0);
g.getLine(4);
g.close;

~data = SDIFFile.read("B:/supercolider-git/supercollider/writtenData/test1.sdif");
~data.headerSpecialFrameSize;