a = {2 + 2 } + { 2 * 3};

a.value
f = {|x| x * 2 };
f.(2);

g = {|x| x ** 2

};
g = { arg x; x ** 2 };
g.(f.(2));

q = {[1,2,4] * g.(f.(2.rand))};
q.value

f.value(2)
f.(2)
value(f, 2)



// Scope:
x = 1;
x = x + 5

x

(
x = x * 2
)

f = { |x| x };
f = { var x; x };
f.()
f = {|x| x = x + 5};
f.(2)

(
var x;
x
)

var x = 2;
x = 2;





