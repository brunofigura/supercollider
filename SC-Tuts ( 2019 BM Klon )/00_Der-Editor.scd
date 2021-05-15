// Das Verhalten des Editors:
// Die Oberfläche der SuperCollider IDE besteht aus 3 Teilen:
// 1. Editor Window:
//	  * Hier wird das Programm geschrieben. Das Funktioniert ausschließlich über
// 		Texteingabe (anders als bei Pure Data oder Max/Msp).
//	  * Der Cursor zeigt die Aktuelle Position der Eingabe an.
//    * Wichtig ist dabei vor allem in welcher Zeile sich der Cursor befindet,
//      dass zeigt an welche Zeile Code ausgeführt wird wenn man [cmd + enter]
//      ([ctrl + enter] für Windows und Linux) drückt.
//    * Man kann mehrere Zeilen auswählen und ausführen.
//    * da SuperCollider eine LiveCoding umgebung ist kann man den Code direkt im
//      im Editor ausführen ohne ihn in einem Seperaten schritt zu Compilieren (das
//      compilieren passiert automatisch im Hintergrund).
// 2. Das Post Window:
//    * Hier gibt das Programm für den Benutzer informationen zurück
//      im Gegensatz zu GUI basierten Programmen ist das die Stelle in der fast das
//      ganze Feedback für den Benutzer ankommt.
//    * Das heisst Rückgabewerte vom Programm kommen hier an genau wie Fehlermeldungen
//      oder informationen zu Hardware Problemen.
//    * Es dauert meistens einige Zeit bis man alles Versteht was hier passiert. Es ist
//      aber wichtig, dass man zumindest lernt hier Fehler, Warnungen und Rückgabewerte zu
//      identifizieren.
// 3. Der Help Browser:
//    * Hier kann man sich Hilfe zu verschiedenen Teilen von SuperCollider holen
//      der Help Browser wird mit [cmd + d] auf dem Mac und [ctrl + d] auf Linux und Windows
//      aufgerufen
//    * Wenn man im Editor eine Klasse (z.B. "SinOsc") oder eine Methode (z.B. ".value")
//      auswählt und dann den Shortcut für den Help Browser drück wird man direkt zum Artikel
//      für das ausgewählte Element weitergeleitet.
//    * Im Help Browser findet man auch weitere Tutorials und Guides für Einsteiger
//      und Fortgeschrittene.

// Ein paar grundlegende Begriffe:
// Klasse und Objekt:
// 		Die nicht ganz saubere Erklärung:
// 		Klassen sind Blaupausen für Objekte. Sie haben einen Namen und enthalten informationen
// 		so genannte "Methoden" das einzige was man mit ihnen machen kann ist Objekte daraus
//		herzustellen (im Fachsprech zu instanzieren).
// 		Sie sind eine abstrakte Representation von all den Dingen die in SuperCollider
//		existieren.

//		Ein Objekt ist die konkrete instanz einer Klasse. Im gegensatz zu einer Klasse
//		kann man mit einem Objekt wirklich etwas machen.

// Funktion:
// 		Eine Funktion ist das was in einem Program etwas "tut". Eine Funktion nimmt im
// 		allgemeinen einen oder mehrere Inputs (Argumente) und gibt einen wert als Output
//		zurück (rückgabewert oder return value)

// Methode:
// 		Eine Methode ist eine Funktion die Teil einer Klasse ist. Einfacher ausgedrückt ist
//		eine Methode das was wir mit einem Objekt machen können. Sie immer über ein
//		Objekt dieser Klasse aufgerufen. In SuperCollider haben wir die ganze Zeit mit
//		Methoden zutun

// Just in Time compilation oder REPL
3
3+3
"hallo kurs".postln;

// die Methode ".postln" ist euer freund. Sie ist Teil von fast allen Klassen in SuperCollider
// und gibt euch im Post Window immer hilfreiche informationen zurück.

// Bevor man in SuperCollider Sound generieren kann muss man den "Synthese-Server" Booten,
// d.H. man muss die Soundengine starten.
// Das macht man mit [cmd + b] auf Mac und [ctrl + b] auf Linux und Windows
// Außerdem kann man den Server booten indem man in Editor den folgenden Code ausführt
s.boot;

// um zu testen ob der Sound funktioniert kann man den folgenden Code ausführen,
// zu hören sein sollte ein unverzerter klavierähnlicher Ton:
().play;