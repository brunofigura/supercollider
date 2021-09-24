// die play funktion in events benutzen
e = (play: {"hallo".scramble.postln})
e.play

e.at(\a).func



// List:
l = List(8);
a = Array(8);

(
l.add(100.rand);
a.add(100.rand);
l.postln;
a.postln;
)

l.do{ |item| item.postln };




(
SynthDef(\x, {|out, gate=1|
	var env, sig;
	env = Env.perc(0, 1).ar(2, gate);
	sig = SinOsc.ar(100) * env ! 2;
	Out.ar(out, sig * 0.1);

}).add;
)

a = Synth(\x)
a.set(\gate, 0)
a.isPlaying
().play;

/* https://hundredrabbits.itch.io/orca */
// Physical Modelling
(
SynthDef(\kPlus, { |out, freq=440, decay=2|
	var sig, env;
	env = Env.perc(0, 0.01).ar;
	sig = WhiteNoise.ar() * env;
	sig = CombC.ar(sig, 0.5, 1/freq, decay).tanh ! 2;
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(out, sig * 0.5);
}).add;
)

Synth(\kPlus, [\freq, 440, \decay, 10])

(
SynthDef(\kPlus, { |out, freq=440, decay=2|
	var sig, env;
	env = Env.perc(0, 0.01).ar;
	sig = LPF.ar(WhiteNoise.ar(), 2000) * env;
	sig = CombC.ar(sig, 0.5, 1/(freq * SinOsc.ar(4).range(0.99, 1.01)), decay).tanh ! 2;
	sig = sig + CombL.ar(sig, 0.2, SinOsc.ar(2).range(0.03, 0.031), 0);
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(out, sig * 0.5);
}).add;
)

Synth(\kPlus, [\freq, 440, \decay, 10])

(
Pdef(\kPlus, Pbind(
	\instrument, \kPlus,
	\scale, Scale.at(\minor),
	\octave, 3
	\degree, Pseq([0, 2, 4], inf),
	\decay, 2,
	\dur, 2
)).play;
)

Physical


(
{ var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  MembraneCircle.ar(excitation, tension, loss);
}.play;
)



(
{     var m0, m1, m2, m3, m4, d, k, t;
    k = MouseX.kr(0.5, 100, 1);
    d = MouseY.kr(0.0001, 0.01, 1);
    t = Dust.ar(2);
    m0 = Spring.ar(ToggleFF.ar(t), 1 * k, 0.01);
    m1 = Spring.ar(m0, 0.5 * k, d);
    m2 = Spring.ar(m0, 0.6 * k, d);
    m3 = Spring.ar([m1,m2], 0.4 * k, d);
    m4 = Spring.ar(m3 - m1 + m2, 0.1 * k, d);
    CombL.ar(t, 0.1, LinLin.ar(m4, -10, 10, 1/8000, 1/100), 12)

}.play;
)


(
SynthDef(\help_oteypianostring, { |out=0, freq=440,gate=1, amp=0.5,rho=1|
    var son = OteyPianoStrings.ar(freq, amp, rho:rho)*EnvGen.ar(Env.asr(0,1,0.1),gate,doneAction:2);
    Out.ar(out, Pan2.ar(son * 1, LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75)));
}).add;

SynthDef(\piano_soundboard,{
    var audio = In.ar([20, 21], 2);
    audio = OteySoundBoard.ar(audio);
    Out.ar(0,audio);
}).add
)

//start soundboard effect
Synth.tail(1,\piano_soundboard);


(
Pbind(
    \instrument, \help_oteypianostring,
    \delta, 1,
    \dur, 3,
    \degree, Pseq([1,3,5], inf),
    \out, 20,
).play;
)


(
Ndef(\x, {
	var sig;
	sig = WhiteNoise.ar(1) * Decay.ar(Impulse.ar(1), 0.6);
	sig = Ringz.ar(sig, MouseX.kr(100, 1000), 1) * 0.01;

}).play;
)

(
Ndef(\x, {
	var sig;
	sig = WhiteNoise.ar(1) * Decay.ar(Impulse.ar(1), 0.03);
	sig = DynKlank.ar(
		`[
			[120, 123, 136, 180, 190, 191, 200], // freq
			[1, 0.3, 0.7, 0.4, 1, 0.3, 0.6],
			[1, 1.7, 1.2, 0.3, 1, 0.2, 3]
		], sig, 1, MouseX.kr(0, 1000), MouseY.kr(0.1, 2)) * 0.04;
	sig.tanh
}).play;
)



(
var harmonics = ((7.2 ! 16).rand );
var amps = ((1.0 ! 16).rand );
Ndef(\x, {
	var sig, env, imp;
	env = Env.perc(0, 0.3).ar(0, Impulse.ar(3));
	sig = WhiteNoise.ar(1) * Decay.ar(Impulse.ar(1), 0.03);
	sig = DynKlang.ar(
		`[
			harmonics, // freq
			amps
		], LFNoise0.ar(3).range(50, 600),) * 0.04;
	sig.tanh * env ! 2;
}).play;
)


Ndef(\x).reshaping = \elastic


(
SynthDef(\kPlus, { |out, freq=440, decay=2|
	var sig, env;
	env = Env.perc(0, 0.01).ar;
	sig = LPF.ar(WhiteNoise.ar(), 2000) * env;
	sig = CombC.ar(sig, 0.5, 1/(freq * SinOsc.ar(4).range(0.99, 1.01)), decay).tanh ! 2;
	sig = sig + CombL.ar(sig, 0.2, SinOsc.ar(2).range(0.03, 0.031), 0);
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(out, sig * 0.5);
}).add;
)




