


x' = s * (y - x)
y' = x * (r - z) - y
z' = x * y - b * z


// geht noch nicht
(
Ndef(\x, {
	var state, x, y, z, x1, y1, z1, clock;
	var
	si = 0.01,
	ri = 0.01,
	bi = 0.01,
	xi = 0.01,
	yi = 0,
	zi = 0;
	state = LocalIn.ar(4, [xi, yi, zi, 0]);
	#x, y, z, clock = state.poll;

	x1 = si * (y - x);
	y1 = x * (ri - z) - y;
	z1 = (x * y) - (bi * z);

	clock = clock + 1 % 64;
	state = if(clock <= 0, [x1, y1, z1, clock], [x, y, z, clock]);

	LocalOut.ar(state);
	[x1, y1, z1]
}).scope
)



