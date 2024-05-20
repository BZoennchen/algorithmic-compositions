(
~dft = {arg y, k;
	var m = y.size, result = 0;
	for(0, m-1, {
		arg n;
		result = result + (y[n] * exp(Complex(0,-1) * 2 * pi / m * n * k));
	});
	result;
};
)

y = [8, 4, 8, 0];

c = Array.fill(4, {arg i; i}).collect({arg i; ~dft.(y, i)});


(
~idft = {arg y, k;
	var m = y.size, result = 0;
	for(0, m-1, {
		arg n;
		n.postln;
		result = result + (y[n] * exp(Complex(0,1) * 2 * pi / m * n * k));
	});
	result / m;
};
)

~iy = Array.fill(4, {arg i; i}).collect({arg i; ~idft.(c, i)});