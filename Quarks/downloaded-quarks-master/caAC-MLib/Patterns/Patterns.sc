/* Help Pattern subclasses.  Marinus Klaassen 2012	*/

PdefArray : Pattern {
	var <>patternClass, <>envir, <>key, <>numArgs, <>additional;
	*new { arg patternClass, envir, key, numArgs = 1, additional = nil;
		^super.newCopyArgs(patternClass,envir,key,numArgs, additional)
	}

	embedInStream { arg inval;
		var argStream = Pfunc({ Pdef(envir).get(key) ++ additional }).asStream, latestArgs,

		proxies = Array.fill(numArgs, { |i| Pfunc({ latestArgs[i] }).asStream }),
		stream = patternClass.new(*proxies).asStream;
		while {
			latestArgs = argStream.next(inval);
			latestArgs.notNil
		} {
			inval = stream.next(inval).yield;
		};
		^inval
	}
	storeArgs { ^[patternClass,envir,key,numArgs] }
}

PguiArray : Pattern {
	var <>patternClass, <>dict, <>key, <>numArgs, <>additional;
	*new { arg patternClass, dict, key, numArgs = 1, additional = nil;
		^super.newCopyArgs(patternClass,dict,key,numArgs, additional)
	}
	embedInStream { arg inval;
		var argStream = Pfunc({ dict.envir[key] ++ additional }).asStream, latestArgs,
		proxies = Array.fill(numArgs, { |i| Pfunc({ latestArgs[i] }).asStream }),

		stream = patternClass.new(*proxies).asStream;
		while {
			latestArgs = argStream.next(inval);
			latestArgs.notNil
		} {
			inval = stream.next(inval).yield;
		};
		^inval
	}
	storeArgs { ^[patternClass,dict,key,numArgs] }
}

/*
Pdef(\a).set(\amp,[0,0.125]);
Pdef(\a).get(\amp);
p = PpdefArray(Pbeta, \a,\amp,4, [4, 4])
q = p.asStream;
q.nextN(5);
Pdef(\a).set(\amp, [0,1.0])
q.nextN(1000).histo.plot;
*/

// PguiArray : Pattern {
// 	var <>patternClass, <>dict, <>key, <>numArgs, <>additional;
// 	*new { arg patternClass, dict, key, numArgs = 1, additional = nil;
// 		^super.newCopyArgs(patternClass,dict,key,numArgs, additional)
// 	}
// 	embedInStream { arg inval;
// 		var argStream = Pfunc({ dict.envir[key] ++ additional }).asStream, latestArgs,
// 		proxies = Array.fill(numArgs, { |i| Pfunc({ latestArgs[i] }).asStream }),
//
// 		stream = patternClass.new(*proxies).asStream;
// 		while {
// 			latestArgs = argStream.next(inval);
// 			latestArgs.notNil
// 		} {
// 			inval = stream.next(inval).yield;
// 		};
// 		^inval
// 	}
// 	storeArgs { ^[patternClass,dict,key,numArgs] }
// }

PenvirArray : Pattern {
	var <>patternClass, <>envir, <>key, <>numArgs, <>additional;
	*new { arg patternClass, envir, key, numArgs = 1, additional = nil;
		^super.newCopyArgs(patternClass,envir,key,numArgs, additional)
	}
	embedInStream { arg inval;
		var argStream = Pfunc({ envir.object[key] ++ additional }).asStream, latestArgs,
		proxies = Array.fill(numArgs, { |i| Pfunc({ latestArgs[i] }).asStream }),

		stream = patternClass.new(*proxies).asStream;
		while {
			latestArgs = argStream.next(inval);
			latestArgs.notNil
		} {
			inval = stream.next(inval).yield;
		};
		^inval
	}
	storeArgs { ^[patternClass,envir,key,numArgs] }
}

/*
g = EnvirGui.new(nil, 5); � � � � � � � � � � �
g.object_((freq: [20,100]));
a = PenvirArray2(Pwhite, g, \freq, �2)
b = a.asStream;
b.nextN(5);
// change freq;
b.nextN(1000).histo.plot;
*/

/*
Pbinc1: count 1 in 8 bit binary strings.
Experimenting with generating numberical relationships This generator sequences of numbers.
the numbers are generated by adding up the digits that are
equal to zero or one in a 8 bit binary string.
start count at 1. zero is filtered out.
*/

Pcount1 : Pattern {
	var <>offset, <>mul, <>length;

	*new { arg offset=0.0, mul=1.0, length=inf;
		^super.newCopyArgs(offset,mul,length)
	}

	storeArgs { ^[offset,mul,length] }

	embedInStream { arg inval;
		var	offsetStr	= offset.asStream,
		mulStr	= mul.asStream,
		offsetVal	= offsetStr.next(inval),
		mulVal 	= mulStr.next(inval);

		if (offsetVal.isNil or: { mulVal.isNil }) { ^inval };

		length.value(inval).do ({ |i|
			var n = 0; // initialize count to zero.

			offsetVal	= offsetStr.next(inval); mulVal = mulStr.next(inval);

			if (offsetVal.isNil or: { mulVal.isNil }) { ^inval };

			// restores inf argument i float data-type back to 8 bit int.
			if (length.class == Float, { i = asInt(i) });
			if (offsetVal.isNil or: { mulVal.isNil }) { ^inval };

			i = i + offsetStr.next(inval).asInt % 256 + 1;
			if( i == 0, { i = 1 }); // filter out zero.
			// count 1
			i.asBinaryString do: { |elem| if (elem.asString == "1", { n = n + 1; }) };
			// mul count and yield.
			n = n * mulStr.next(inval);
			inval = n.yield;
		});
		^inval;
	}
}

/*
a = Pbinc1(0,1,inf).asStream
a.nextN(20)
*/

// to discrete chance generators.
Pbernoulli : Pattern {
	var <>n, <>weight, <>length;
	*new { arg n=3, weight=0.5, length=inf;
		^super.newCopyArgs(n, weight, length)
	}
	storeArgs { ^[n, weight,length] }
	embedInStream { arg inval;
		var 	nStr = n.asStream,
		weightStr = weight.asStream,
		nVal,weightVal,return;
		length.value(inval).do({
			nVal = nStr.next(inval);
			weightVal = weightStr.next(inval);
			if(nVal.isNil or: { weightVal.isNil }) { ^inval };
			return = Mix.fill(nVal, { if (weightVal.coin) { 1 } { 0 } }) / nVal;

			inval = return.yield;
		});
		^inval;
	}
}
/*
// coin tossing with weight.
(
a = Pbinom(5,0.1,inf).asStream;
b = a.nextN(200);
b.plot;
b.histo(100,0,1.0).plot;
)
*/

Pbernoulli2 : Pattern {
	var <>n, <>weight, <>length;
	*new { arg n=3, weight=0.5, length=inf;
		^super.newCopyArgs(n, weight, length)
	}
	storeArgs { ^[n, weight,length] }
	embedInStream { arg inval;
		var nStr = n.asStream;
		var weightStr = weight.asStream;
		var nVal,weightVal,return;
		length.value(inval).do({
			nVal = nStr.next(inval);
			weightVal = weightStr.next(inval);
			if(nVal.isNil or: { weightVal.isNil }) { ^inval };
			return = Mix.fill(nVal, { if (weightVal.coin) { 1 } { 0 } }) / nVal * [-1,1].choose;
			inval = return.yield;
		});
		^inval;
	}
}
/*
// coin tossing with weight and positive and negative values..
(
a = Pbinom2(10,0.1,inf).asStream;
b = a.nextN(200);
b.plot;
b.histo(100,0,1.0).plot;
)

b = EnvirGui.new
b.object_((a: [0,1000]));
a = PESscale(b, \a, Pseg(Pwhite(0,1.0),0.1).asStream).asStream;
a.next
*/

PESscale : Pattern {
	var <>envir, <>key, <>shape;
	*new { arg patternClass, envir, key, numArgs = 1, additional = nil;
		^super.newCopyArgs(patternClass,envir,key,numArgs, additional)
	}
	embedInStream { arg inval;
		var 	argStream 	= Pfunc({ envir.envir[key] }).asStream, latestArgs,
		shapeStream 	= Pfunc({ shape.next }).asStream;

		while	{ argStream.next(inval).notNil && shapeStream.next(inval).notNil }
		{ inval = (shapeStream.next(inval).linlin(0,1.0,argStream.next(inval).at(0),argStream.next(inval).at(1))).yield;
		};
		^inval
	}
}

PdevLin : Pattern {
	var <>patternClass, <>avg, <>dev, <>additional;
	*new { arg patternClass, avg, dev, additional = nil;
		^super.newCopyArgs(patternClass,avg, dev, additional)
	}
	embedInStream { arg inval;
		var
		avgStr = avg.asStream,
		devStr = dev.asStream,
		argStream = Pfunc({
			var vg = avgStr.next, dv = devStr.next;
			var lo = avg + (dv * vg * 0.5);
			var hi = avg - (dv * vg * 0.5);
			[lo, hi] ++ additional }).asStream,
		latestArgs,

		proxies = Array.fill(2 + additional.size, { |i| Pfunc({ latestArgs[i] }).asStream }),

		stream = patternClass.new(*proxies).asStream;

		while {
			latestArgs = argStream.next(inval);
			latestArgs.notNil
		} {
			inval = stream.next(inval).yield;
		};
		^inval
	}
	storeArgs { ^[patternClass,avg,dev,additional] }
}

PdevExp : Pattern {
	var <>patternClass, <>avg, <>dev, <>numArgs, <>additional;
	*new { arg patternClass, avg = 0, dev = 0, numArgs = 2, additional = nil;
		^super.newCopyArgs(patternClass, avg, dev, numArgs, additional)
	}
	embedInStream { arg inval;
		var
		avgStr = avg.asStream,
		devStr = dev.asStream,
		argStream = Pfunc({
			var vg = avgStr.next, dv = devStr.next;
			var lo = 2 ** dv * vg;
			var hi = 2 ** dv.neg * vg;
			[lo, hi] ++ additional }).asStream,
		latestArgs,
		proxies = Array.fill(numArgs, { |i| Pfunc({ latestArgs[i] }).asStream }),

		stream = patternClass.new(*proxies).asStream;

		while {
			latestArgs = argStream.next(inval);
			latestArgs.notNil
		} {
			inval = stream.next(inval).yield;
		};
		^inval
	}
	storeArgs { ^[patternClass,avg,dev,numArgs,additional] }
}

Pdeviate : Pattern {
	var <>avg, <>dev;
	*new { arg avg = 0, dev = 0;
		^super.newCopyArgs(avg, dev)
	}
	embedInStream { arg inval;
		var lo,hi,a,b,
		avgStr = avg.asStream,
		devStr = dev.asStream;

		inf do: {
			a = avgStr.next;
			b = devStr.next;
			lo = b * 0.5 - a;
			hi = b * 0.5 + a;

			inval = [lo,hi].yield;
		};
		^inval
	}
	storeArgs { ^[avg,dev] }
}

Pdeviote : Pattern {
	var <>avg, <>dev;
	*new { arg avg = 0, dev = 0;
		^super.newCopyArgs(avg, dev)
	}
	embedInStream { arg inval;
		var lo,hi,a,b,
		avgStr = avg.asStream,
		devStr = dev.asStream;

		inf do: {
			a = avgStr.next;
			b = devStr.next;
			lo = a - (b * a * 0.5);
			hi = b * a * 0.5 + a;

			inval = [lo,hi].yield;
		};
		^inval
	}
	storeArgs { ^[avg,dev] }
}

