LPCAnalyzer



(
d = Buffer.read(s, "/Volumes/ACE II/AUDIO/MONHEIM/TESTS/Text.wav");

e = Buffer.read(s, "/Users/marcusschmickler/Dropbox (Personal)/Musikinformatik-2017/2019 VM Sommer/23.04./Sprachfiles/MuT_Demovideo.wav");
)


Ndef(\sample1, { PlayBuf.ar(2, d, BufRateScale.kr(d), loop: 1) * 0.6 });
Ndef(\sample2, { PlayBuf.ar(2, e, BufRateScale.kr(d), loop: 1) * 0.4 });

Ndef(\sample1).play;
Ndef(\sample2).play;
Ndef(\sample2).stop;

Ndef(\sample1).stop;


(
Ndef(\x, {
	var in = Ndef.ar(\sample1);
	LPCAnalyzer.ar(in, Impulse.ar([100,150],0,0.2), 1024, 80,delta:0.99, windowtype:0, mul:5 )

}).play;
)

(
Ndef(\x, {
	var in = Ndef.ar(\sample1);
//	var amplitude= Amplitude.kr(source);
	var hasFreq= Pitch.kr(in);
	LPCAnalyzer.ar(in, Impulse.ar(hasFreq*1, 0, 0.3), 2056, 72, delta:0.99, windowtype:1, mul:5 )

}).play;
)


NdefMixer(s);



(
Ndef(\x, { |out|
	var in, freq, amplitude, sound;
	in = Ndef.ar(\sample1, 1);
//	amplitude= Amplitude.kr(source);
	freq= Pitch.kr(in);
	sound= LPCAnalyzer.ar(in, Impulse.ar([freq, freq*3 ], 0, 0.3), 1024, 70,delta:0.95, windowtype:0, mul:5 );
	Out.ar(out, sound);

}).play;
)


(
Ndef(\x, { |out|
	var in, freq, amplitude, sound;
	in = Ndef.ar(\sample1, 1);
//	amplitude= Amplitude.kr(source);
	freq= Pitch.kr(in);
	sound= LPCAnalyzer.ar(in, SinOscFB.ar([freq, freq+300],0, 0, 0.3), 1024, 70, delta:0.95, windowtype:0, mul:0.1);
	Out.ar(out, sound);

}).play;
)




(
Ndef(\y, {
	var in = Ndef.ar(\sample1);
	LPCAnalyzer.ar(in, WhiteNoise.ar, 1024, 70,delta:0.95, windowtype:1 , mul:0.1)

}).play;
)



Ndef(\y).stop;
Ndef(\x).stop;





(///////////////)



b= PlayBuf(s,"/Volumes/ACE II/DONAUESCHINGEN 18/SONGS/ARP RECS/Bounces/ARPSi_1.wav");

{LPCAnalyzer.ar(d,Impulse.ar(440,0,0.2), 256, 50)}.play

{LPCAnalyzer.ar(SoundIn.ar(0),Impulse.ar(440,0,0.2), 256, 50, windowtype:1)}.play

{LPCAnalyzer.ar(SoundIn.ar(14),Impulse.ar(440,0,0.2), 128,  MouseX.kr(1,128))}.play

{LPCAnalyzer.ar(SoundIn.ar(0),Impulse.ar(440,0,0.2), 1024,  MouseX.kr(1,128), windowtype:1)!8}.play


{LPCAnalyzer.ar(SoundIn.ar(14),0.1*WhiteNoise.ar, 256, MouseX.kr(1,256))}.play

//keep number of poles lower if pushing harder with bigger windows
{LPCAnalyzer.ar(SoundIn.ar(0),Impulse.ar(MouseY.kr(100,1000),0,0.2), 1024,  MouseX.kr(1,128),1,0.9999, 1)!8}.play

////////
(
{
var source,amplitude, freq, hasFreq;

source= SoundIn.ar(0);

//no need, fitted filter tracks amplitudes, essentially
//amplitude= Amplitude.kr(source);

#freq,hasFreq= Pitch.kr(source);

LPCAnalyzer.ar(source,if(hasFreq,Impulse.ar(freq),0.25*WhiteNoise.ar), 256,MouseX.kr(1,256), windowtype:1)!8

}.play
)


//singing with myself after three seconds
(
{
var source,amplitude, freq, hasFreq;

source= SoundIn.ar;

amplitude= Amplitude.kr(source);

LPCAnalyzer.ar(source,CombC.ar(source,3.0,3.0,10.0), 256,MouseX.kr(1,256)).dup(8)

}.play
)

(
{
var input,source;

input= Resonz.ar(Saw.ar(SinOsc.kr([0.1,0.11],500,600)),LFNoise1.kr(LFNoise1.kr(4,3.5,7),700,2500),LFNoise2.kr(0.5,0.3,0.4));

source= SoundIn.ar;

LPCAnalyzer.ar(input,source, 64,MouseX.kr(1,64), windowtype:1)

}.play
)


//test variable order
{LPCAnalyzer.ar(SoundIn.ar,Impulse.ar(MouseX.kr(10,1000,'exponential'),0,0.2), 256, 256,1,0.999)}.play

{LPCAnalyzer.ar(SoundIn.ar,Impulse.ar(MouseX.kr(10,1000,'exponential'),0,0.2), 256, 256,1,MouseY.kr(0.9,1.0).sqrt)}.play









//////////////////////////////////////

//residual test assumes windowtype 0)
(
{
var input,source;
var delaytime= 1024.0/SampleRate.ir;

input= SoundIn.ar(14);

source= Impulse.ar(delaytime.reciprocal);

(DelayN.ar(input,delaytime, delaytime)- LPCAnalyzer.ar(input,source,1024,MouseX.kr(1,256))).poll(10000)

}.play
)