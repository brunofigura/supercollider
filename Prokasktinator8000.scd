/*
- synthdef der ton erzeugt
- synthdef der soundinput mic hat und analysiert wird
- server kommunikation
- eine art timer
*/

// Server zeugs
//ugen -sendreply um antwort von server zu bekommen
SendReply



//such unter analysis ugens!
//man bräuchte OSCdef

//SynthDef sound i = mic

(
Ndef(\guard, {
	var input, sig;
	input = SoundIn.ar(0);
	sig = DelayL.ar(input, 0.3, 0.3);
}).play;
)


