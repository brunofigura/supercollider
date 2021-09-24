(
SynthDef(\slash, { |out|
	var env, freq, sig;
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.1, 0.5, 0.1]), doneAction: 2);
	freq = Line.kr(300, 600, 0.7);
	sig = SinOscFB.ar(freq, freq.linlin(600, 300, 0, 1.2), env) ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\backslash, { |out|
	var env, freq, sig;
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.1, 0.5, 0.1]), doneAction: 2);
	freq = Line.kr(600, 300, 0.7);
	sig = SinOscFB.ar(freq, freq.linlin(600, 300, 0, 1.2), env) ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\vertikal, { |out|
	var env, freq, sig;
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.1, 0.5, 0.1]), doneAction: 2);
	freq = Line.kr(300, 600, 0.01);
	sig = SinOscFB.ar(freq, freq.linlin(600, 300, 0, 1.2), env) ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\punkt, { |out|
	var env, sig, mod;
	env = EnvGen.ar(Env.perc(0.001, 0.1), doneAction: 2);
	mod = SinOscFB.ar([2000, 3012], env * 1.2);
	sig = SinOsc.ar(1200, mod * env * 3, env * 2).fold(-1, 1).tanh;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\punkt, { |out, freq=1200|
	var env, sig, mod;
	env = EnvGen.ar(Env.perc(0.001, 0.1), doneAction: 2);
	mod = SinOscFB.ar([2000, 3012], env * 1.2);
	sig = SinOsc.ar(freq, mod * env * 3, env * 2).fold(-1, 1).tanh;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\komma, { |out|
	var env, sig, freq;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.1, 0.001]), doneAction: 2);
	freq = Line.kr(600, 100, 0.1);
	sig = Pulse.ar(freq, SinOsc.kr([3, 3.3]).range(0.2, 0.7), env);
	Out.ar(out, sig * 0.1);
}).add;

SynthDef(\strich, {|out|
	var env, sig;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.1, 0.001]), doneAction: 2);
	sig = SinOscFB.ar(150, 0.6, env) ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\unterstrich, {|out|
	var env, sig;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.1, 0.001]), doneAction: 2);
	sig = SinOscFB.ar(50, 0.6, env * 2).tanh ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\klammerAuf, { |out|
	var sig, env, mod, freq;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.5, 0.001]), doneAction: 2);
	freq = Line.kr(0, 14, 0.5);
	mod = SinOsc.ar(freq);
	sig = SinOsc.ar(mod.range(400, 500)) * env ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\klammerZu, { |out|
	var sig, env, mod, freq;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.5, 0.001]), doneAction: 2);
	freq = Line.kr(14, 0, 0.5);
	mod = SinOsc.ar(freq);
	sig = SinOsc.ar(mod.range(400, 500)) * env ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\eckigAuf, { |out|
	var sig, env, mod, freq;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.3, 0.001]), doneAction: 2);
	freq = Line.kr(5, 40, 0.3);
	mod = LFPulse.ar(freq);
	sig = Pulse.ar(mod.range(400, 500)) * env ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\eckigZu, { |out|
	var sig, env, mod, freq;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.3, 0.001]), doneAction: 2);
	freq = Line.kr(40, 5, 0.3);
	mod = LFPulse.ar(freq);
	sig = Pulse.ar(mod.range(400, 300)) * env ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\geschweiftAuf, { |out|
	var sig, env, freq;
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.01, 0.3, 0.01]), doneAction: 2);
	freq = Line.kr(600, 900, 0.3);
	sig = Saw.ar(freq, env) ! 2;
	Out.ar(out, sig * 0.1)
}).add;

SynthDef(\geschweiftZu, { |out|
	var sig, env, freq;
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.01, 0.3, 0.01]), doneAction: 2);
	freq = Line.kr(900, 600, 0.3);
	sig = Saw.ar(freq, env) ! 2;
	Out.ar(out, sig * 0.1)
}).add;


SynthDef(\tilde, { |out|
	var sig, env, mod, freq;
	env = EnvGen.ar(Env([0,1,1,0], [0.001, 0.5, 0.001]), doneAction: 2);
	mod = SinOsc.ar(3);
	sig = SinOscFB.ar(mod.range(400, 450), 0.6) * env ! 2;
	Out.ar(out, sig * 0.1)
}).add;
)


(
~doc = Document.new("Sonderzeichenkammermusiksaal");
Document.current_(~doc);

~playString = { |string|
	switch(string,
		"/", { Synth(\slash) }, // "/"
		"\\", { Synth(\backslash) }, // "\",
		"|", { Synth(\vertikal) }, // "|"
		".", { Synth(\punkt) },  // "."
		",", { Synth(\komma) },  // ","
		"-", { Synth(\strich) }, // "-"
		":", { fork{ Synth(\punkt, [\freq, 1200]); 0.1.wait; Synth(\punkt, [\freq, 2000])} }, // ":"
		";", { fork{ Synth(\komma); 0.1.wait; Synth(\punkt, [\freq, 2000])} }, // ";"
		"_", { Synth(\unterstrich) }, // "_"
		"(", { Synth(\klammerAuf) }, // "("
		")", { Synth(\klammerZu) }, // ")"
		"[", { Synth(\eckigAuf) }, // "["
		"]", { Synth(\eckigZu)}, // "]"
		"{", { Synth(\geschweiftAuf) }, // "{"
		"}", { Synth(\geschweiftZu) }, // "}"
		"~", { Synth(\tilde)}, // "~"
	);
};

~doc.keyDownAction_{|doc, char, mod, uni, keycode, key|
	var string = char.asString;
	~playString.(string);
};
)

(
Tdef(\seq, {
	var i = 0;
	var num, string;
	loop {
		num = ~doc.string.size;
		string = ~doc.string[i % num].asString;
		~playString.(string);
		i = i+1;
		0.25.wait;
	}
}).play;
)

Tdef(\seq).stop