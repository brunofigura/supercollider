/*

Hier stehen nur ein paar Notizen zum Versuch Audio über Jitsi oder Mumble zu streamen. Bitte ignorieren.

https://jitsi.org/blog/features-update-april-2020/

Browsers behave differently depending on your platform with regards to this feature. On Windows you are able to share the entire system audio, but on Linux and macOS just that of the tab you’re sharing.

*/

/*

http://existential.audio/blackhole/

*/

(
s.options.outDevice = "Aggregate ( Intern/ BlackH)"; // <== Blackhole plugin aggregate device
s.options.inDevice = "Aggregate ( Intern/ BlackH)"; // <== Blackhole plugin aggregate device
s.options.numOutputBusChannels = 18;
s.options.numInputBusChannels = 18;
s.reboot;
)

s.tree = { Ndef(\bruno, { SoundIn.ar([0, 1]) }).play }; // ffeedback, nur mit kopfhörern benutzen!
// reset to normal:
s.tree = nil

(
SynthDef(\testton, {|amp = 0.3|
	var sig, trig, env;
	trig = LFPulse.ar(1);
	env = Env.perc(0.02, 0.5).ar(0, trig);
	sig = SinOsc.ar(440) * env;
	sig = sig * amp;

	Out.ar([0, 3], sig);


}).add;)
Synth(\testton);

ServerOptions.devices;



(
Ndef(\x, {
	var freq = 400;
	SinOsc.ar(freq) * 0.1
}).playN([0, 2]);
)
