// für fragen: raffael.seyfried@rsh-duesseldorf.de

// Expander
(
Ndef(\exp, {
	var sig, env, imp;
	imp = Impulse.ar(1);
	env = Env.perc(0, 0.3).ar(0, imp);
	sig = SinOsc.ar(500) * env ! 2;
}).play;
)

(
Ndef(\exp, {
	var sig, env, imp;
	imp = Impulse.ar(1);
	env = Env.perc(0, 0.3).ar(0, imp);
	sig = SinOsc.ar(500) * env ! 2;
	sig = Compander.ar(sig, sig, -3.dbamp, 3, 1, 0.001, 0.1);
}).play;
)

(
Ndef(\comp, {
	var sig, env, imp;
	imp = Impulse.ar(1);
	env = Env.perc(0, 0.3).ar(0, imp);
	sig = SinOsc.ar(500) * env ! 2;
	sig = Compander.ar(sig, sig, -12.dbamp, 1, 1/8, 0.01, 0.1);
}).play;
)

// Message senden sobald die Amplitude eine gewisse Zeit unter einem bestimmten Wert liegt
// Zutaten:
SendReply
Amplitude

(
Ndef(\amp, {
	var in, amp, trig;
	trig = Impulse.ar(2);
	in = SoundIn.ar(0);
	amp = Amplitude.ar(in);
	SendReply.ar(trig, '/amp', amp);
	K2A.ar(0);
}).play;
)

(
var timeDelta, startTime, running;
timeDelta = 0;
running = false;
OSCdef(\ampListener, {|msg, time|
	var thresh, amp;
	thresh = 0.004;
	amp = msg[3];
	if(amp < thresh){
		if(running){
			timeDelta = time - startTime;
		}{
			running = true;
			startTime = time;
		};
	}{
		timeDelta = 0;
		running = false;
	};
	if(timeDelta > 2){

	};
	//[msg, time].postln;
}, '/amp')
)

OSCFunc.trace(false, true)
// SENSOR
(
OSCdef(\sensor, {|msg|
	msg.postln;
}, '/dancer1/sens2');
)

n = NetAddr.localAddr;

(
f = File("test.scd".resolveRelative, "w");
f.write("[");
OSCdef(\sensor, {|msg, time|
	msg.postln;
	f.write("[" + time.asString ++"," + msg.asCompileString ++ "],\n");
}, '/test');
)

n.sendMsg('/test', "test123");

f.write("]"); f.close;

"[1, 2, 3]".interpret
\a.asCompileString

(
Tdef(\read, {

}).play;
)

(
var numberOfTimesChosen, scenes, lastChoice, choose, same, playScene, a, z;

numberOfTimesChosen = Array.new(4);

a =	(scene: "A", numberOfTimesChosen: 0);
z =	(scene: "Z", numberOfTimesChosen: 0);

scenes = [
	(scene: "X1", numberOfTimesChosen: 0),
	(scene: "X2", numberOfTimesChosen: 0),
	(scene: "X3", numberOfTimesChosen: 0),
	(scene: "X4", numberOfTimesChosen: 0),
];

playScene = {|x|
	x.scence.do{|item, i|
		item.p(i.asSymbol).play;
	};
};

Tdef(\choose, {
	var currentChoice;
	// Szene A als erstes Abspielen:
	playScene.(a);
	inf.do{
		same = true;
		// hier wählen wir zufällig eine Szene aus bis wir eine auswählen die anders ist als die letzte
		while({ same }, {
			currentChoice = scenes.choose;
			// wir testen ob es schon eine lastChoice gibt, wenn nicht heißt das, dass wir gerade die erste "Entscheidung" treffen. Somit ist same falso, denn es gibt keine lastChoice
			if(lastChoice.notNil){
				same = (currentChoice.scene == lastChoice.scene).postln;
			}{
				same = false;
			};
		});
		lastChoice = currentChoice;
		currentChoice.numberOfTimesChosen = currentChoice.numberOfTimesChosen + 1;
		if(currentChoice.numberOfTimesChosen <=  2){
			playScene.(currentChoice);
			currentChoice.scene.postln;
		}{
			playScene.(z);
			Tdef(\choose).stop;
		};
		1.wait;
	};
}).play;
)

// SynthDefs nach Zahlen benennen
(
SynthDef(\0, {|out, freq, amp|
	var sig, env;
	env = Env.perc(0, 0.3).ar(2);
	sig = SinOscFB.ar(freq, 0) * env ! 2;
	Out.ar(out, sig * amp)
}).add;

SynthDef(\1, {|out, freq, amp|
	var sig, env;
	env = Env.perc(0, 0.3).ar(2);
	sig = SinOscFB.ar(freq, 1.2) * env ! 2;
	Out.ar(out, sig * amp)
}).add;

SynthDef(\2, {|out, freq, amp|
	var sig, env;
	env = Env.perc(0, 0.3).ar(2);
	sig = Saw.ar([freq, freq+5]).mean * env ! 2;
	Out.ar(out, sig * amp)
}).add;

SynthDef(\3, {|out, freq, amp|
	var sig, env;
	env = Env.perc(0, 0.3).ar(2);
	sig = Pulse.ar(freq) * env ! 2;
	Out.ar(out, sig * amp)
}).add;

SynthDef(\4, {|out, freq, amp|
	var sig, env;
	env = Env.perc(0, 0.3).ar(2);
	sig = LFTri.ar(freq) * env ! 2;
	Out.ar(out, sig * amp)
}).add;
)
(
~midi = [
	Pseq([0, 1, 2]),
	Pseq([3, 4, 5]),
	Pseq([4, -1, 22]),
	Pseq([7, 1, 9]),
	Pseq([-12, 29, 12]),
];
)
(
~midi.do{|item, i|
	var p;
	//p = item.p(i.asSymbol)
	p = Pbind(\instrument, i.asSymbol, \degree, item, \dur, 0.5).play;
};
)


20.collect{ |i|
	OSCFunc(, "/parentPfad/" ++ i )
};

smooth

1000.collect{
	100.0.rand;
}.plot

[0.1, 0.3, 0.7, 0.4].mean
freeAll





