/*

(I) A recursive rewriting system

Note: we are testing with isArray, which is true for strings. This means that a string will count as a subarray. For working with words, use symbols.

*/


~matchAndReplace = { |list, matchFunc, offset = 0|
	var result, restList, arity, outSize;
	arity = matchFunc.def.argNames.size;
	restList = list[offset..offset+arity];
	result = matchFunc.valueArray(restList);

	if(result.notNil) {
		outSize = result.size;
		list.keep(offset) ++ result ++ list.drop(arity + offset)
	}
};

~matchAndReplaceN = { |list, matchFunc|
	var results = List.new;
	var arity = matchFunc.def.argNames.size;
	var numOffsets = (list.size - arity + 1);

	numOffsets.do { |i|
		var result = ~matchAndReplace.(list, matchFunc, i);
		if(result.notNil) { results.add(result) };
	};
	results
};

~matchAndReplaceDeep = { |list, matchFunc|
	var results = List.new;
	var arity = matchFunc.def.argNames.size;
	var numOffsets = (list.size - arity + 1);

	numOffsets.do { |i|
		var result = ~matchAndReplace.(list, matchFunc, i);
		if(result.notNil and: { results.includesEqual(result).not }) { results.add(result) };
		if(list[i].isArray) {
			~matchAndReplaceDeep.(list[i], matchFunc).do { |part|
				var result = list.copy.put(i, part);
				results.add(result)
			}
		};
	};
	results
};

// the path is a path of indices of offsets into subarrays, if they exist

~matchAndReplaceWithPath = { |list, matchFunc, path|
	var arity = matchFunc.def.argNames.size;
	var maxIndex = (list.size - arity);
	var index, part;

	path = path.asArray;
	index = path.first;
	path = path.drop(1);

	if(index.notNil) {
		index = index.min(maxIndex);
		if(list[index].isArray and: { path.notEmpty }) {
			part = ~matchAndReplaceWithPath.(list[index], matchFunc, path);
			list.copy.put(index, part)
		} {
			~matchAndReplace.(list, matchFunc, index);
		}
	}
};

// parsers

~parseString = { |string|
	var current, stack;
	x = string.as(Array);
	current = [];
	stack = [];
	x.do { |y|
		y.switch(
			$ , nil, // ignore nil
			$(, // one down
			{
				stack = stack.add(current);
				current = [];
			},
			$), { // one up
				current = stack.pop.add(current)
			},
			{
				current = current.add(y.asSymbol)
			}
		);
	};
	current
};

~parseArray = { |array|
	array.collect { |x|
		if(x.isArray) { "(" ++ ~parseArray.(x) ++ ")" } { x }
	}.join(" ")
};

// posting

~postAll = { |array|
	array.do { |x| x.postln };
	"";
};

