



a = "100.rand"
a.interpret



a = { 100.rand };


a.value

1 ! 56
a ! 56
a ! 100.rand

// keine nebeneffekte (side effects)
(
b = 0;
a = { b + 1 };
)


a.value
a.value
a.value
a.value

// nebeneffekte
(
b = 0;
a = { b = b + 1 };
)

a.value
a.value
a.value
a.value

a ! 4
a ! 4

a.value; a.value; a.value; a.value
4.do { a.value.postln };

//////////////////////////////////////

(
b = {
	{ 100.rand }
}
)

b.value
b.value.value

a = b.value;
a.value;
a.value;
a.value;

(
b = {
	var zzz = 100.rand;
	{ zzz }
}
)
a = b.value;
a.value;
a.value;
a.value;



// closure
(
b = {
	var zzz = 100.rand;
	{ zzz = zzz + 1 }
}
)
a = b.value;
a.value;
a.value;
a.value;

c = b.value;
c.value;
c.value;
c.value;
a.value;
a.value;

e = b ! 8;
e.collect { |x| x.value };
e.collect { |x| x.value };
e.collect { |x| x.value };
e.collect { |x| x.value };
e.collect { |x| x.value };




