
// commutativity
AB = BA

// associativity
(AB)C = A(BC)

/*
we need:

- the difference in the formulas must result in a difference in sound
- equality means a possible musical movement, in both directions
- so ironically, the sound representation must not be associative
-- alternatively, the parentheses must themselves "have a sound"

- the juxtaposition between two letters must have sonic correspondence:
-- each letter alone
-- two letters together

A musical piece may contain several formulas that change independently.

- perhaps: each letter is a sound plus a sound modification.
like "an A flat that accumulates what comes after it"

Need to think carefully about non-associativity.
We need operators (like combinators)

+2 *2 +3
(+2 *2) +3
+2 (*2 +3)






*/


loadRelative("/Library/Algebra-sonification-functions/algebra-sonification-functions.scd");




~parseString.("1 + (2 * 3)")

~parseString.(~parseArray.([1, '+', [2, '*', 3 ]]));
~parseArray.(~parseString.("1 + (2 * 3)"));



~matchAndReplace.([1, 0, 1, 0], { |a, b| if([a, b] == [1, 0]) { [8, a, 4] } }, 0);
~matchAndReplaceN.([1, 0, 0, 0, 1, 0], { |a, b| if([a, b] == [1, 0]) { [8, a, 4] } });
~matchAndReplaceDeep.([1, 0, 0, 0, 1, 0], { |a, b| if([a, b] == [1, 0]) { [8, a, 4] } });


~matchAndReplaceDeep.([1, 2, 3, 4], { |a, b| [b, a] });
~matchAndReplaceDeep.([1, [2, 3], 4], { |a, b| [b, a] });

~matchAndReplaceWithPath.([1, 2, 3, 4], { |a, b| [b, a] }, [0]);
~matchAndReplaceWithPath.([1, 2, 3, 4], { |a, b| [b, a] }, [1]);

~matchAndReplaceWithPath.([1, [2, 3, 4], 5], { |a, b| [b, a] }, [0, 0]);

~matchAndReplaceWithPath.([1, [2, 3, 4], 5], { |a, b| [b, a] }, [1, 0]);
~matchAndReplaceWithPath.([1, [2, 3, 4], 5], { |a, b| [b, a] }, [1, 1]);

~matchAndReplaceWithPath.([1, [2, 3, 4], 5], { |a, b|  [b, a] }, [2]);

// replace a pattern
(
x = ~matchAndReplaceDeep.(
	[1, 0, [0, [1, 0], 1, 0], 0, 0, 1, 0],
	{ |a, b|
		if([a, b] == [1, 0]) { [56] }
	}
);
~postAll.(x);
)

// replace by some calculation
(
x = ~matchAndReplaceDeep.(
	[ 2, 1, [ 1, [ 2, 1 ], 2, 1 ], 1, 1, 2, 1 ],
	{ |a, b|
		[a + b].squared
	}
);
~postAll.(x);
)

// replace randomly (here we don't get all combinations)
(
x = ~matchAndReplaceDeep.(
[ 2, 1, [ 1, [ 2, 1 ], 2, 1 ], 1, 1, 2, 1 ],
	{ |a, b|
		[[a, a, b], [b, b, a], [a], [b]].choose
	}
);
~postAll.(x);
)


// commutativity
(
x = ~matchAndReplaceDeep.(
	[ 0, 1, [ 2, [ 3, 4 ], 5, 6 ], 7, 8, 9, 10 ].postln,
	{ |a, b| [b, a] }
);
~postAll.(x);
)


// n-ary assiociativity
// ab(cde)fg = a(bcd)efg = abc(def)g


(
x = ~matchAndReplaceDeep.(
	[ 0, 1, [ 2, [ 3, 4 ], 5, 6 ], 7, 8, 9, 10 ].postln,
	{ |a, b|
		if(a.isArray) {
			[a.first, a.drop(1).add(b)]
		} {
			if(b.isArray) {
				[[a] ++ b.drop(-1), b.last]
			}
		}
	}
);
~postAll.(x);
)


// drop array.
(
x = ~matchAndReplaceDeep.(
	[ 0, 1, [ 2, [ 3, 4 ], 5, 6 ], 7, 8, 9, 10 ].postln,
	{ |a, b|
		if(a.isArray) {
			a ++ [b]
		} {
			if(b.isArray) {
				[a] ++ b
			}
		}
	}
);
~postAll.(x);
)

// wrap in array.
(
x = ~matchAndReplaceDeep.(
	[ 0, 1, 2, 3, 4, [5, 6, 7], 8, 9, 10 ].postln,
	{ |a, b|
		if(a.isArray) {
			[a ++ [b]]
		} {
			if(b.isArray) {
				[[a] ++ b]
			} {
				[[a, b]]
			}
		}
	}
);
~postAll.(x);
)

// idempotent law
(
x = ~matchAndReplaceDeep.(
	[ 0, 1, [ 2, [ 3, 3, 4 ], [5, 6], [5, 6] ], 7, 8, 8, 9, 10 ].postln,
	{ |a, b|
		if(a == b) { [a] }
	}
);
~postAll.(x);
)



/*

using oprators

*/



// commutativity only for an operator
(
x = ~matchAndReplaceDeep.(
	[1, 0, '*', [0, [1, 0], 1, 0], 0, 0, 1,  '*', 0],
	{ |a, o, b| if(o ==  '*') { [b, o, a] } }
);
~postAll.(x);
)

// less awful, using the parser
(
x = ~matchAndReplaceDeep.(
	~parseString.("1 * 3 10 (7 8) * 9"),
	{ |a, o, b| if(o ==  '*') { [b, o, a] } }
);
~postAll.(x.collect(~parseArray));
)


// distributive law
// forwards
(
x = ~matchAndReplaceDeep.(
	[2, '*', [2, 3, 4], 5, '*', [6, 7]].postln,
	{ |a, o, b|
		if(o == '*') {
			if(b.isArray) {
				b.collect { |x| [a, '*', x] }
			} {
				if(a.isArray) {
					a.collect { |x| [x, '*', b] }
				} {

				}
			}
		}
	}
);
~postAll.(x);
~postAll.(x.collect(~parseArray));
)


// backwards (explicit, assuming all is split in factors, and not commutative)
// only pairwise, but can be iterated

(
x = ~matchAndReplaceDeep.(
	[ [ 2, '*', 2 ], [ 2, '*', 3 ], [ 2, '*', 4 ], 5, '*', 6 ].postln,
	{ |a, b|
		if(a.isArray and: { b.isArray }) {
			if(a[1] == '*' and: { b[1] == '*' } and: { a[0] == b[0] }) {
				[[a[0], '*', a.drop(2) ++ b.drop(2)]]
			}
		}
	}
);
~postAll.(x);
~postAll.(x.collect(~parseArray));
)


/*

Sound examples

*/




(
Ndef(\x, {
	var structure, variants;
	var notes, current, freq;

	structure = [0, 7, 0, [6, [4, 3]], 2];
	variants = ~matchAndReplaceDeep.(structure, { |a, b| [b, a] });
	variants = variants.collect { |x|
		var notes = x.flat;
		IEnvGen.kr(Env(notes, 1/notes.size, \step), LFSaw.kr(1).range(0, 1));
	};
	current = Select.kr(MouseX.kr(0, variants.size -1), variants);
	freq = current.midiratio * 200;
	SinOsc.ar(freq) * 0.1
}).play
)


(
Ndef(\x, {
	var structure, variants;
	var notes,  freq;

	structure = [0, 13, 7, 0, [6, [4, 3]], 2, 8, 9];
	variants = ~matchAndReplaceDeep.(structure, { |a, b| [b, a] });
	variants = variants.collect { |x|
		var notes = x.flat;
		IEnvGen.kr(Env(notes, 1/notes.size, \step), LFSaw.kr(1).range(0, 1));
	};
	freq = variants.midiratio * 200;
	Splay.ar(SinOsc.ar(freq)) * 0.1
}).play
)

(
Ndef(\x, {
	var structure, variants, signals;
	var notes,  freq;

	structure = [0, 13, 7, 0, [6, [4, 3]], 2, 8, 9];
	variants = ~matchAndReplaceDeep.(structure, { |a, b| [b, a] });
	variants = variants.collect { |x|
		var notes = x.flat;
		IEnvGen.kr(Env(notes, 1/notes.size, \step), LFSaw.kr(1).range(0, 1));
	};
	freq = variants.midiratio * 200;
	signals = [];
	freq.doAdjacentPairs { |f1, f2|
		signals = signals.add(
			SinOsc.ar([f1, f2])
		)
	};
	SelectX.ar(MouseX.kr(0, signals.size -1), signals) * 0.1
}).play
)


(
Ndef(\x, {
	var structure, variants;
	var notes,  freq, trig;
	trig = Impulse.kr(8);

	structure = [0, 13, 7, 0, [6, [4, 3]], 2, 8, 9];
	variants = ~matchAndReplaceDeep.(structure, { |a, b| [b, a] });
	variants = variants.collect { |x, i|
		var notes, contour, freq;
		notes = x.flat;
		contour = IEnvGen.kr(Env(notes, 1, \step), Stepper.kr(trig, 0, 0, notes.size-1));
		freq = contour.midiratio * 220;
		SinOsc.ar(freq) * Decay2.kr(trig);
	};

	SelectX.ar(LFTri.kr(0.4/variants.size).range(0, variants.size-1).poll, variants, 1) * 0.1
}).play
)






a = ~matchAndReplaceDeep.(a, { |a, b| [b, a] }).choose;
Pbind(\note, Pseq(a.flat), \dur, 0.1).play;
a = ~matchAndReplaceDeep.(a, { |a, b| [b, a] }).choose;


(
Plazy({
	var a, seq;
	a = [0, 13, 7, 0, [6, [4, 3]], 2, 8, 9];
	{
		a = ~matchAndReplaceDeep.(a, { |a, b| [b, a] }).choose;
		a.postln;
		Pbind(\note, Pseq(a.flat), \dur, 0.1)
	}
}.value).loop.play;
)



(
Pdef(\commute,
	Plazy({
		var a, f;
		a = [0, 13, 7, 1, [6, [4, 3]], 2, 8, [9, 2, [4, 6], 6]];
		f = { |val, dur = 1, seq|
			if(val.isArray) {
				val.do { |x| f.(x, dur/2, seq) }
			} {
				seq.add((note: val, dur: dur))
			};
			seq
		};
		{
			a = ~matchAndReplaceDeep.(a, { |a, b| [b, a] }).choose;
			a.postln;
			Pseq(f.(a, 0.5, List.new));
		}
}.value));
)

(
Ppar([
	Pbind(\ctranspose, 0, \pan, -1, \amp, 0.3) <> Pdef(\commute),
	Pbind(\ctranspose, 7, \pan, 1) <> Pdef(\commute)
]).loop.play;
)





