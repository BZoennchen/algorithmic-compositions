// randomness

x = [1,2,3,4,5,6];
x.scramble;
x.reverse;
x = x.mirror2;
x = x.rotate(2);
x.choose;
x.sort;

x + 2;

// collect, do, select, reject, any
x.collect{arg e; e * 2}
x.select{arg e; e % 2 == 0}
x.do{arg e; e.postln };

4.do{arg e; (e + "hi").postln}