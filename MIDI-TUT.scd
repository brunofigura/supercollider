MIDIClient.init;		//finding MIDI-Devices

MIDIIn.connectAll;		//connects SC with found Devices
(
MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;				//args expected for noteOn, see MIDIFunc
	[vel, nn, chan, src].postln;		//printing args but naming them diffrently
	{
		var sig, env;
		sig = SinOscFB.ar(nn.midicps, 0.8) ! 2;
		env = EnvGen.kr(Env.perc, doneAction:2);
		sig = sig * env * vel.linexp(1,127,0.01,0.3);	//vel127 = very loud!
	}.play;
});
)

//1 USB Cable transmits 16 unique MIDIChannels --> 0-15

//-----------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------//

// more Flexible Version with Synthdef

(
SynthDef.new(\synth, {
	arg freq = 440, amp= 0.3;
	var sig, env;
		sig = SinOscFB.ar(freq, 0.8) ! 2;
		env = EnvGen.kr(Env.perc, doneAction:2);
		sig = sig * env * amp;	//vel127 = very loud!
		Out.ar(0, sig);
}).add;
)

MIDIClient.init;		//finding MIDI-Devices

MIDIIn.connectAll;		//connects SC with found Devices
(
MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;				//args expected for noteOn, see MIDIFunc
	[vel, nn, chan, src].postln;		//printing args but naming them diffrently
	Synth.new(\synth, [\freq, nn.midicps, \amp, vel.linexp(1,127,0.01,0.6)]);
});
)

//-----------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------//
//----------------------now with ADSR instead of Perc--------------------------------------//
//-----------------------------------------------------------------------------------------//

(
SynthDef.new(\synth, {
	arg freq = 440, amp = 0.3, gate = 0;
	var sig, env;
		sig = SinOscFB.ar(freq, 0.8) ! 2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;	//vel127 = very loud!
		Out.ar(0, sig);
}).add;
)

MIDIClient.init;		//finding MIDI-Devices

MIDIIn.connectAll;		//connects SC with found Devices
(
MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;				//args expected for noteOn, see MIDIFunc
	[vel, nn, chan, src].postln;		//printing args but naming them diffrently
	~notes[nn] = Synth.new(\synth, [\freq, nn.midicps, \amp, vel.linexp(1,127,0.01,0.3), \gate, 1]);
});
)

(
MIDIdef.noteOff(\noteOff, {
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);			//refers to synth with specific note and sets gate = 0
	~notes[nn] = nil;					//removes synth from array for space
});
)

x = Synth.new(\synth, [\gate, 1]);		//problem for each note x is overwritten
x.set(\gate, 0);						//so you cant set gate 0 on previous notes

~notes = Array.newClear(128)

//-----------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------//
//----------------------now with PitchBend-------------------------------------------------//
//-----------------------------------------------------------------------------------------//

//just add a new MIDIdef to existing stack

(
SynthDef.new(\synth, {
	arg freq = 440, amp = 0.3, gate = 0, bend = 0; //bend in semitones
	var sig, env;
		sig = SinOscFB.ar(freq * bend.midiratio, 0.8) ! 2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;	//vel127 = very loud!
		Out.ar(0, sig);
}).add;
)

MIDIClient.init;		//finding MIDI-Devices

MIDIIn.connectAll;		//connects SC with found Devices

~notes = Array.newClear(128)
(
MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;				//args expected for noteOn, see MIDIFunc
	[vel, nn, chan, src].postln;		//printing args but naming them diffrently
	~notes[nn] = Synth.new(\synth, [
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.01,0.3),
			\gate, 1,
			\bend, ~bend.linlin(0,16383,-2,-2) ,		//so initial bend values are aknowledged---DOESNT WORK PROEPERLY
		]
	);
});
)

(
MIDIdef.noteOff(\noteOff, {
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);			//refers to synth with specific note and sets gate = 0
	~notes[nn] = nil;					//removes synth from array for space
});
)

~bend = 8192;		//global because Synths use bends globally in reality and 8192 is starting value

(
MIDIdef.bend(\bend, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0, 16383,-2, 2))}; //do for iterating over every existing synth
}, chan:0);					// to be sure it only responds to channel 1
)


//-----------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------//
//----------------------NEXT TO MIDIdef.cc-------------------------------------------------//
//-----------------------------------------------------------------------------------------//

(
SynthDef.new(\synth, {
	arg freq = 440, amp = 0.3, gate = 0, bend = 0, feedback = 0; //bend in semitones
	var sig, env;
		sig = SinOscFB.ar(freq * bend.midiratio, feedback) ! 2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;	//vel127 = very loud!
		Out.ar(0, sig);
}).add;
)

MIDIClient.init;		//finding MIDI-Devices

MIDIIn.connectAll;		//connects SC with found Devices

~notes = Array.newClear(128)
(
MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;				//args expected for noteOn, see MIDIFunc
	[vel, nn, chan, src].postln;		//printing args but naming them diffrently
	~notes[nn] = Synth.new(\synth, [
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.01,0.3),
			\gate, 1,
			\bend, ~bend.linlin(0,16383,-2,-2) ,		//so initial bend values are aknowledged---DOESNT WORK PROEPERLY
			\feedback, ~feedback.linlin(0, 127, 0, 1.5),// so initial feedback value starts not everytime at 0
		]
	);
});
)

(
MIDIdef.noteOff(\noteOff, {
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);			//refers to synth with specific note and sets gate = 0
	~notes[nn] = nil;					//removes synth from array for space
});
)

~bend = 8192;		//global because Synths use bends globally in reality and 8192 is starting value

(
MIDIdef.bend(\bend, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0, 16383,-2, 2))}; //do for iterating over every existing synth
}, chan:0);					// to be sure it only responds to channel 1
)

~feedback = 0;

(
MIDIdef.cc(\feedback, {
	arg val, chan, src;
	[val, chan, src].postln;
	~feedback = val;
	~notes.do{arg synth; synth.set(\feedback, val.linlin(0, 127, 0, 1.5))};
}, ccNum:70, chan:0);
)

