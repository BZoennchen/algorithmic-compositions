(
~convolve = {arg a, b;
    var a_pad, b_pad, result, val;

    a_pad = Array.fill(b.size-1, 0) ++ a;
    b_pad = b.reverse ++ Array.fill(a.size-1, 0);

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


(
~cconvolve = {arg a, b;
	var func = {arg n;
		(a *.s (b.reverse.rotate).rotate(n)).sum;
	};
	func;
};
f = ~cconvolve.([1,2,3,4], [-1,3,-1,3]);
y = Array.fill(12, {arg i; f.(i);});
y
)

(
{
	var n, sig;
	n = 512;
	sig = LFPulse.ar(s.sampleRate/n);
    sig = Convolution.ar(sig, sig, 2*n) * n.reciprocal;
	sig
}.plot(512*5/s.sampleRate);
)


(
{
	var n, sig, kernel;
	n = 512;
	sig = LFSaw.ar(s.sampleRate/n);
	kernel = LFSaw.ar(s.sampleRate/n);
    sig = Convolution.ar(sig, kernel, 2*n) * n.reciprocal;
	sig
}.plot(512*5/s.sampleRate);
)