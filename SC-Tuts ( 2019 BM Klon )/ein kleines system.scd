

// environments und events (sind alles dictionaries)


// die funktion unter "play" wird ausgeführt,
// wenn im event .play aufgerufen wird
(play: { "halllo".scramble.postln }).play


// man kann interne werte verwenden
a = (play: { ~was.scramble.postln }, was: "hallo ereignis!");
a.play

// … und auch verändern
b = a.copy;
b.use { ~was = "hallo wolke" };

a.play
b.play

// lexical scope


(
var x = 1.0;
f = {
	x.rand
};
)

(
var x = 1000.0;
g = {
	x.rand
};
)


g.value
f.value

(
{
	var x = -1;
	f.value;
}.value
)


x = 9;
f = { x = x + 1 };

f.value



// dynamic scope

a = Environment.new;

a.use {
	~x = 9;
	~y = ~x + 1;

}


f = { ~x = ~x + ~y };

a.use { f.value };
a

a.use(f)
a



a = Environment.new;

a.use {
	~x = 9;
	~y = ~x + 1;
	~play = { ~x = ~x + ~y };
}

a.use { ~play.value };

b = a.copy;

a.use { ~play.value };

b

a




// ein kleines algorithmisches system

(
var x, p;
x = (
	a: (was:"guten tag"),
	x1: (was: "....|.."),
	x2: (was: "-----|--"),
	x3: (was: "xyz"),
	x4: (was: "abc"),
	z: (was: "ende schoen gute fein")
);

p = (play: { ~was.postln });

f = { |namen|
	namen.do { |name|
		var e = x[name];
		e.parent = p;
		e.play;
	}
};
)


// alternative

(
var x, p;
x = (
	a: (play: { "guten tag".postln }),
	x1: (play: { "....|..".postln }),
	x2: (play: { "-----|--".postln }),
	x3: (play: { "xyz".postln }),
	x4: (play: { "abc".postln }),
	z: (play: { "ende schoen gute fein".postln })
);

f = { |namen|
	namen.do { |name| x[name].play }
};
)





f.( [\a, \x1, \z]);

a = [\x1, \x2, \x3, \x4];


[\x1, \x2, \x3, \x4].scramble

[\a, [\x1, \x2, \x3, \x4].scramble, \z].flat

[\a] ++ [\x1, \x2, \x3, \x4].scramble ++ [\z]

Pseq([\a, Pshuf([\x1, \x2, \x3, \x4]), \z]).asStream.all








(
var x;
x = (
	a: (was:"guten tag"),
	x1: (was: "....|.."),
	x2: (was: "-----|--"),
	x3: (was: "xyz"),
	x4: (was: "abc"),
	z: (was: "ende schoen gute fein")
);

p = (play: { ~was.do { |char| (note: char.post.ascii % 35).play; 0.8.wait; } });

f = { |namen|
	fork {
		namen.do { |name|
			var e = x[name];
			e.parent = p;
			e.play;
		}
	}
};
)

f.( [\a, \x1, \z])

p = (play: { ~was.do { |char| (note: char.ascii % 35).play; 0.1.wait; } });





