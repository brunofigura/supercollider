fork{

	var numberOfTimesChosen, scenes, lastChoice, choose, same, playScene, a, z;

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

	// warten bis der Server fertig mit arbeiten ist:
	s.sync;

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
	})
};