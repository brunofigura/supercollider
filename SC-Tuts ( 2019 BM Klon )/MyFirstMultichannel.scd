// server options wie stelle ich meine Soundkarte ein?
s.options.sampleRate = 44100;
s.options.sampleRate = 48000;
s.reboot;
s.options.device = "Fireface 800 (6A)";
s.reboot;


// explizit Werte als Multichannel definieren
(
{
	SinOsc.ar(699) * LFPulse.kr([
		0.2, 0.3, 2, 0.1, 9, 4, 2, 0.5,
		12, 0.7, 2.1, 1, 7, 4
]) * 0.1 }.play;
)

2.0.rand;

(
{
	SinOsc.ar(699.rand) * LFPulse.kr([
		8.2, 6.3, 2.0, 7.1
].rand) * 0.1 }.play;
)

[1.0, 0.2, 0.6, 0.7].rand;

// Objekte zu Arrays Duplizieren
"a".dup(4);
"a" ! 4;

// .dup und rand mit Multichannel expansion
(600.dup(8).rand);
(
{
	SinOsc.ar((600.dup(8).rand)) * LFPulse.kr((1, 1.5 .. 4)) * 0.1 }.play;
)

// viele Arten das selbe zu sagen:
(
{
	SinOsc.ar((600.dup(8).rand), 0, LFPulse.kr((1, 1.5 .. 4)) * 0.1)}.play;
)

(
{
	SinOsc.ar((600.dup(8).rand), 0, LFPulse.kr((1, 1.5 .. 4)) ) * 0.1 }.play;
)

(
{
	SinOsc.ar((600.dup(8).rand), mul: LFPulse.kr((1, 1.5 .. 4)) ) * 0.1 }.play;
)

// bis zu etwas gezwungenen Beispielen:
(
{
	SinOsc.ar(
		mul: LFPulse.kr((1, 1.5 .. 4)) * 0.1,
		freq: (600.dup(8).rand),
		phase: 0,
		)
}.play;
)

(
{
	ar(
		SinOsc,
		mul: LFPulse.kr((1, 1.5 .. 4)) * 0.1,
		freq: (600.dup(8).rand),
		phase: 0,
		)
}.play;
)


// series: Sequenzielle Werte
(1, 2 .. 8);
1.series(2, 8);
(3.5, 2 .. 8);
(3.2, 3.5 .. 16);

(
{
	(SinOsc.ar(600.rand) * LFPulse.kr(0.1) * 0.7).postln;
}.play;
)

(
{
	(SinOsc.ar(600.rand) * LFPulse.kr(0.1) * 0.7).dup(8).postln;
}.play;
)

(
{
	SinOsc.ar(300 * (1, 2 .. 8), 0, 1/(1, 2 .. 8)).sum.dup(2) * 0.1;
}.play;
)

(
{
	SinOsc.ar(300 * (1, 2 .. 1320), 0, 1/(1, 2 .. 1320)).sum.dup(2) * 0.1;
}.play;
)

// Plot Beispiel für DC offset
{ [SinOsc.ar(4), SinOsc.ar(4, add: 1)] }.plot(1)


