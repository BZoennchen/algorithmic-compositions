(
b = Buffer.alloc(s, 2048**); // allocate FFT buffer
b.bufnum; // note the buffer number
)

(
{
  var in, chain;
    in = WhiteNoise.ar(0.8);
    chain = FFT(LocalBuf(2048), in); // encode to frequency domain
    chain = PV_RandComb(chain, 0.95, Impulse.kr(0.4)); // process
    IFFT(chain) // decode to time domain
}.play;
)

s.boot;


(
{
    var in, chain, b, active, g_amp = 14.0;
	b = LocalBuf(2048);
	active = Array.fill(200, {if(1.0.rand > 0.97, 1, 0)});
    in = PinkNoise.ar();
    chain = FFT(b, in);

	chain = chain.pvcollect(b.numFrames, {|mag, phase, bin, index|
		var factor = index.linexp(b.numFrames, 0, 0.3, 1.0);
		var amp = Pulse.kr(rrand(3, 20), rrand(0.1, 0.8)).range(0, 0.9) * factor;
		[mag*amp*active.wrapAt(index)*g_amp, phase]
	});

	Pan2.ar(IFFT(chain))
}.play;
)

(
a = [1,2,3,4,5,6,7];
10.collect { |index|
	a.foldAt(index)
};
)

b.reboot;
linlin(0, 2048, 0.1, 1.0)



1.0.rand