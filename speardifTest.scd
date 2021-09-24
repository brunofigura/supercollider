a = SDIFFile.read("C:/Users/bruno/AppData/Local/SuperCollider/Extensions/Classes/sdiffile/data/Sdiftest1(EI).sdif")


a.frames[0].matrices[0]
(
b = List.new();
for (1, (a.frames.size- 1), {arg i;
	b.add(a.frames[i].matrices[0].array)
})
b
)
c = "data/Sdiftest1(EI).sdif".resolveRelative
Platform.systemExtensionDir;

(
	var listMatrices;
	a = SDIFFile.read("C:/Users/bruno/AppData/Local/SuperCollider/Extensions/Classes/sdiffile/data/Sdiftest1(EI).sdif");

	a.frames.do {|i|
		listMatrices.add(i.matrices);
	};
	listMatrices;
)

