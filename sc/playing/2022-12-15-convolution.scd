


(
~convolve = {arg a, b;
	var a_pad, b_pad, result, val;

	a_pad = Array.fill(b.size-1, 0) ++ a;
	b_pad = b.rotate ++ Array.fill(a.size-1, 0);

	result = [];
	for(0, a.size+b.size-2, {
		val = (a_pad * b_pad).sum;
		result = result ++ [val];
		b_pad = b_pad.rotate(1);
	});
	result;
};
)

~convolve.([1,2,3,4], [-1,3,-1,3]);
