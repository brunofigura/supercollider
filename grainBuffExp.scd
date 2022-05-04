//path to audio
p = Platform.resourceDir +/+ "sounds/pianoImprov.wav";

//audio buffer
b = Buffer.read(s, p);


BufGrain.ar(Dust.ar(1.3), 0.3, b, 1, rrand(0.0, 1.0), 2, 1, 0);.

rrand(0,1)

//events angucken dafür 