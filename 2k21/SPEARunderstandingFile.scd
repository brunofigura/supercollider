// create dictonary
d = ();
d["foo"] = 1;
d["foo"];
// returns nil and not 1!
// b/c identity (id_?) of string is something different than on a symbol
d[\bar] = 2;
d[\bar]
// returns 2
d.id_(4);
d[\id];
//adds a new key 'id' with value 4



~sdifFile = SDIFFile.read("B:/supercolider-git/supercollider/spear data/trump_whatIsGoingOn.sdif");

~sdifFile.frames[1].time;
~sdifFile.frames[4].time;

~sdifFile.frames[1].matrices[0].array;
/*
sieht so aus [id, freq, amp, phase]

*/

~spearFile = SPEARPartials.newFrom(~sdifFile);

~spearFile.maxNumFrames;

~spearFile.array[0];						//shows array filled with SPEARPartial
