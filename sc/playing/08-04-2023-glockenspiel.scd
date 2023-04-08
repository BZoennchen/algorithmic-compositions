s.boot;

(
SynthDef(\glockenspiel, {
    var sig, env, env2, fundamental, partials;

    env = EnvGen.ar(Env(
        levels: [0, 1, 0.4, 0],
        times: [\atk.kr(0.01), \dec.kr(0.5), \rel.kr(1.5)],
        curve: -4));
    env2 = EnvGen.ar(Env(
        levels: [0, 0.25, 0.125, 0],
        times: [\atk.kr(0.01), \dec.kr(0.5)*0.25, \rel.kr(1.5)*0.4],
        curve: -6));

    fundamental = SinOsc.ar(\freq.kr(440)!2);
	partials = Saw.ar(([12, 24]).midiratio * \freq.kr(440));
    sig = fundamental * env;
    sig = sig + (partials * env2);
    sig = sig * 0.1 * \amp.kr(1.0);
    sig = sig.sum;
    sig = Pan2.ar(sig, \pan.kr(0));
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(\out.kr(0), sig);
}).add;
)

(
var tempo = TempoClock(1);                  // our tempo
var n = 5;                                  // number of "instruments"
var n_bars = 6;                             // number of bars
var bars = Array.fill(n, 0);                // current bar of instruments
var degrees = Array.fill(n_bars, nil);      // bars (melody pitch parts)
var durs = Array.fill(degrees.size, nil);   // bars (melody duration parts)
var octaves = Array.rand(n, 5, 7);          // octave of instrument
~amp = 0.3;
// define the melody parts
degrees[0] = [2, 2, 2, 2];
durs[0] = [0.25, 0.25, 0.5, 0.5];

degrees[1] = [0, 0];
durs[1] = [0.5, 0.5];

degrees[2] = [6, 6, 7, 7];
durs[2] = 0.25!4;

degrees[3] = [-6, -4, -6];
durs[3] = [0.25, 0.25, 0.5];

degrees[4] = [3];
durs[4] = [1.0];

degrees[5] = [1];
durs[5] = [1.0];


fork {
n.do { |j|
	{
		var i = 0;
			240.do {
			var mel = bars[j];
			(
				instrument: \glockenspiel,
				scale: Scale.minor,
				octave: octaves[j],
				pan: {rrand(-0.5, 0.5)},
				degree: degrees.wrapAt(mel).wrapAt(i).trace,
				amp: ~amp,
			).play;

			durs.wrapAt(mel).wrapAt(i).wait;
			i = i + 1;

			if(rand(1.0) > 0.85, {
				bars[j] = bars[j] + 1;
			});
		};
	}.fork(tempo, quant: 0.25);
	rrand(2.0, 8.0).wait;
};
};

fork {
	var n = 20;
	var i = 0;
	var envTempo = Env([1.0, 1.10, 1.0, 0.8], [1,1,1]).asSignal(100).asArray;
	var envAmp = Env([0.3, 0.7, 0.3], [1,1]).asSignal(100).asArray;

	loop {
		if(1.0.rand > 0.9,{
			i = i + 1;
			tempo.tempo = envTempo.clipAt(i);
			~amp = envAmp.clipAt(i);
		});
		0.25.wait;
	}
};
)









