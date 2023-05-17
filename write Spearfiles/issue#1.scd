//was ist dieses Padding -> welches Format / Datentyp hat es

f = File.open("B:/supercolider-git/supercollider/spear data/trump.sdif", "rb");
f.getLine(4);
f.seek(4, 0);
f.getInt32();
f.seek(8,0);
f.getInt32();
f.seek(12, 0);
f.getChar();
f.close;