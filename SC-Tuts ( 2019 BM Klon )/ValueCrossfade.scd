[0, 1, 2, 3].wchoose([a, a, b, b]);
~weights = [0.5, 0];

(
Tdef(\x, {
	var weights, crossfade;
	weights = [];
	crossfade = 0;
	while{
		crossfade < 1
	}{
		weights = crossfade.linlin(0, 1, [0.5, 0], [0, 0.5]);
		crossfade = crossfade + 0.01;
		~weights = weights;
		0.1.wait;
	};
});
)


(
Tdef(\y, {
	loop{
		[0, 1, 2, 3].wchoose(~weights.stutter(2).normalizeSum.postln);
		0.1.wait;
	};
}).play;
)

Tdef(\y).stop;
Tdef(\x).play;

~crossfade = {|amt, arr|
	amt.linlin(0, 1, arr, arr.reverse);
};
