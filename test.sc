//Klassen
/*
f = {|a, b|
	a + b
};

f.value(4, 5);
*/
 // Testklasse.d = 10; ich kann d von aussen ändern
// Testklasse.c.value; ich kann c von aussen nur sehen
(
Test {
	//Klasseneigenschaften
	classvar <c=4, >d=5;				//< = setter  ; > = getter

	*initClass{
		c = 6
		d = 7
	}

	*f {|a, b|
	a + b;
	}

	*g{
		c + d;
	}
}
)
Test.f(4, 5);