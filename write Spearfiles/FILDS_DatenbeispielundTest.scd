//bsp von Julian. Eigenes Verständniss:
//

e = [1, 2, 3, 4, 5, 6, 7, 8]
e.clump(3);
c = e.clump(3).reverse;
c = e.clump(3).reverse;
b = c.collect(_.reverse).flatten;
b.clump(5);

//gleiche wie vorhin nur als eine Funktion
f = { |a, n| a.clump(n).collect({arg i; i.reverse}).flatten };
f.([1,2,3]);
f.(f.([1, 2, 3, 4, 5, 6, 7, 8], 3), 5)

//-> "strukturbewahrend" nachschlagen und theorie prüfen, was ist strukturbewahrend. Die Funktion??

g = f.(_,3) <> f.(_,5);
g.([1, 2, 3, 4, 5, 6, 7, 8]);
g.([1, 2, 3, 4, 5, 6, 7, 8, 100, 1000]);


{ 1.0.rand.round(0.1) }.dup(10)


//wie könnte man ein chunk von frames in der Zeit spiegel= rückwärts anordnen-> beispiel fall mit Array das Zeitpunkte beinhaltet

t = [ 0.4, 1.3, 1.5, 1.7, 2.6, 3.4, 3.8, 4.7, 4.9, 5.5 ];
([t.first] ++ t.differentiate.drop(1).reverse).integrate

d = { |x| x.differentiate.drop(1) };
i = { |x, z| ([z] ++ x).integrate };

i.(d.(t), t[0]) // identity
i.(d.(t).reverse, t[0]) // reverse
i.(d.(t).scramble, t[0]) // scramble
i.(d.(t) / 2, t[0]) // ??
//t wäre der Daten Chunk


//Fragen: was macht der Punkt genau, was macht der unterstrich genau
//geht das, das auch reverse zu nennen als methode oder wie weiß SC welches reverse gemeint ist.
//schaut es auf die Art der Objektes?!?

//definition Chunk:
//ursprünglich eingeführt als erklärung des Kurzzeitgedachtnisses vom Menschen ( 7 + / - 2 Sachen kann man sich gut merken)
//in der Informatik Chunking:Ein Datenblock (lehnübersetzt aus dem englischen data block) ist eine begrenzte, fallweise festgelegte Anzahl von Bits oder Bytes, die als Transporteinheit behandelt wird. Historisch bedingt wurde und wird dafür, auf hardwarenaher Ebene der Festplatten und Disketten, auch oft der Begriff Sektor verwendet. Der Blockaufbau und die Blockelemente entsprechen den betreffenden Kommunikationsprotokollen.

//Liste an Transformationen:
/*
Rückwärts -> frames rückwärts anordnen
mischen -> frames zufällig anordnen
teilen -> frames teilen Zeit und oder Frequenzebene
	alles als eine Transformation? Oder ein zeitliches Teilen und ein Freq Abhängiges Teilen
chunk -> x Anzahl an Frames "auswählen"/herausschneiden
slice -> datei in gleichgroße Chunks aufteilen ( wie methode .clump)
sortieren -> frames nach kriterium x sortieren. Zeit, HeaderInfo oder Daten-Abhängig
*/






//~~~~~~~~~~~~~~~~~~~~~~~~~~THEORIE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
/*
Versuch Kategorie-Theorie mit einem Beispiel in SC zu erklären:
*/