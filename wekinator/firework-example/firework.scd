s.boot;

(
SynthDef(\fireworks,{
    var sig;
    sig = Dust.ar([\densityleft.kr(3), \densityright.kr(3)-0.5]);
	sig = Ringz.ar(
		sig,
		freq: \freq.kr(300),
		decaytime: \decaytime.kr(0.1)) * \amp.kr(0.55);
    sig = FreeVerb.ar(sig, 0.6, 0.9, 0.8);
    sig = LPF.ar(in: sig, freq: \cutofffreq.kr(21000));
    Out.ar(0, sig);
}).add;
)


~fireworks = Synth(\fireworks);
~fireworks.set(\amp, 1);
~fireworks.set(\densityleft, 10);
~fireworks.set(\freq, 400);
~fireworks.set(\decaytime, 0.3);
~fireworks.free();


(
OSCdef(
    \getCoords,
    {
        arg val;
        ~fireworks.set(\densityleft, val[1].linlin(0, 1, 0.1, 20));
        ~fireworks.set(\densityright, val[2].linlin(0, 1, 0.1, 20));
        ~fireworks.set(\freq, val[3].linlin(0, 1, 100, 700));
        ~fireworks.set(\amp, val[4].linlin(0, 1, 0, 2));
        ~fireworks.set(\decaytime, val[5].linlin(0, 1.0, 0.01, 1.0));
        ~fireworks.set(\cutofffreq, val[6].linlin(0, 1, 200, 20000));
    },
    '/wek/outputs',
    recvPort: 7448
);
)