~data2 = SDIFFile.read("B:/supercolider-git/supercollider/spear data/trump.sdif");

~data.headerSpecialFrameSize;

//creating SDIF file with File header

(
f = File.new("B:/supercolider-git/supercollider/writtenData/test1.sdif", "wb");

f.write("SDIF");				//signature "SDIF"
f.putInt32(8);			//Header Special Frame Size
f.putInt32(2);				//SDIF Specification Version
f.write("'/0'");				//Padding
f.close
)

~data2 = SDIFFile.read("B:/supercolider-git/supercollider/writtenData/test1.sdif");