s.options.device = "MME : Mikrofonarray (Realtek Audio)";
s.options.device = "ASIO";
s.options.sampleRate = 44100;
s.options.sampleRate = 48000;
s.reboot;
s.quit;
s.boot;

// die einfachste art
().play;

// die zweit einfachste art
{ SinOsc.ar(1000) * 0.1 }.play;

// Ndef
Ndef(\x, { SinOsc.ar(100) * 0.1 })
Ndef(\y, { SinOsc.ar(300) * 0.1 })

Ndef(\x).play
Ndef(\y).play
Ndef(\x).free
Ndef(\x).stop
Ndef(\y).stop

Ndef(\x, { Saw.ar(20) * 0.1 })
// Ndefs können Parameter haben
Ndef(\x, { |freq=20| Saw.ar(freq) * 0.1 })
Ndef(\x).fadeTime = 1;
Ndef(\x).set(\freq, 140)
Ndef(\x).xset(\freq, 7000)
// Ndefs sollen sich anpassen je nachdem wie viele Kanäle wir brauchen
Ndef(\x).reshaping = \elastic;
Ndef(\x, { Impulse.ar(20) * 0.1 ! 2}).play;

Ndef(\x, { SinOsc.ar(200) * 4 })
Ndef(\z, { SinOscFB.ar(600, 0.3) * 4 })
// Ndefs kann man von anderen Ndefs aus abspielen
Ndef(\y, {(Ndef(\x) ** (Ndef(\z))).tanh }).play
Ndef(\y, {(Ndef(\x) + (Ndef(\z))).tanh }).play

{ Line.ar(-2, 2).clip(-1, 1) }.plot(1);
{ Line.ar(-2, 2).tanh }.plot(1);


(
Ndef(\rythm, {
	var sig, mod;
	mod = LFPulse.kr(p[137, 139] / 100);
	sig = SinOscFB.ar(200, 0.5) * mod;
	sig
}).play;
)

1000.do{|item| if(item.isPrime){item.postln } };

p = List.new();
100.do{|item| if(item.isPrime){ p.add(item)} };
p[[p.size.rand, p.size.rand]]

25.do{|item| if(item.isPrime){ p.add(item)} };

(
Ndef(\rythm, {
	var sig, mod;
	mod = LFPulse.ar(p[[p.size.rand, p.size.rand]]);
	sig = SinOscFB.ar(p[[p.size.rand, p.size.rand]] * 100, 0.) * mod;
	sig
}).play;
)

(
Ndef(\rythm, {
	var sig, modA, modB, modC;
	modA = LFPulse.ar(p[[p.size.rand, p.size.rand]] / 8);
	modB = LFPulse.ar(p[[p.size.rand, p.size.rand]] / 8);
	modC = (LFPulse.ar(p[[p.size.rand, p.size.rand]] / 8, 0, 0.25) + 1).scope;
	sig = SinOscFB.ar(p[[p.size.rand, p.size.rand]] * 100 * modC, 1.2 * modB ) * modA;
	sig
}).play;
)


Ndef(\rythm).stop;

(
Ndef(\env, {
	var sig, env;
	env = Env.perc(0, 0.1).circle([0, 0.1]).ar;
	// mapping funktionen:
	// linlin
	// linexp
	// explin
	// expexp
	// lincurve
	// curvelin
	sig = LFTri.ar(env.linlin(0, 1, 50, 150)) * env;
	sig
}).play;
)

(
Ndef(\env, {
	var sig, env;
	env = Env.perc(0, 0.3).ar(0, Impulse.ar([2, 3]));
	sig = LFTri.ar(env.linexp(0, 1, 50, 150)) * env;
	sig
}).play;
)

(
Ndef(\env, {
	var sig, env;
	env = Env.perc(0, 0.3).ar(0, Impulse.ar([2, 3]));
	sig = LFTri.ar(env.lincurve(0, 1, 50, 1500, 12)) * env;
	(sig * 100).tanh
}).play();
)

(
Ndef(\env, {
	var sig, env;
	env = Env.perc(0, 0.3).ar(0, Impulse.ar(p[[p.size.rand, p.size.rand]] / 8));
	sig = LFTri.ar(env.lincurve(0, 1, 50, 1500, 12)) * env;
	(sig * 1000).fold(-100, 100).tanh
}).play();
)

(
// west coast
Ndef(\x, {
	var sig, env;
	env = Env.perc(0.3, 0.3).circle(0).ar;
	sig = (SinOsc.ar(60 * 4) * env.lincurve(0, 1, 0, 2, 6)).fold(-1, 1) * 0.3; }).play;
)

(
// east coast
Ndef(\x, {
	var sig, env;
	env = Env.perc(0.3, 0.3).circle(0).ar;
	sig = RLPF.ar(Saw.ar(60 * 4), env.lincurve(0, 1, 40, 4000, 6));
	sig * 0.3
}).play;
)













































// SynthDef
