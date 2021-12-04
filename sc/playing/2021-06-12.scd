Utils.initTools(true);

(
SynthDef.new(\melo,{
    arg freq = 300;
    var sig;
    sig = SinOsc.ar(freq)!2 * 0.4;
    Out.ar(0, sig);
}).add;
)


Synth(\melo);

(
w = Window("My Analyzer", Rect(0, 0, 511, 300));
f = FreqScopeView(w, w.view.bounds);
w.onClose_({ f.kill }); // YOU MUST HAVE THIS
w.front;
)

(
var randomNumbers, histogram, minValue = -250, maxValue = 250, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { maxValue.sum3rand; });
histogram = randomNumbers.histo(numBins, minValue, maxValue);
histogram.plot("histogram for sum3rand " ++ minValue ++ " to " ++ maxValue);
)

(({rand(4.0)}!100000).sort).plot(discrete: true);
(({rand2(4.0)}!100000).sort).plot(discrete: true);
(({rrand(1.0, 5.0)}!100000).sort).plot(discrete: true);
(({linrand(4.0)}!100000).sort).plot(discrete: true);
(({bilinrand(4.0)}!100000).sort).plot(discrete: true);
(({sum3rand(4.0)}!100000).sort).plot(discrete: true);
(({exprand(4.0,0.02)}!10000).sort).plot(discrete: true);
(({gauss(4.0, 0.4)}!10000).sort).plot(discrete: true);


(
Utils.histogram( values: {rand(4.0)}!1000000, steps: 100 ).plot(name: "uniform");
Utils.histogram( values: {linrand(4.0)}!1000000, steps: 100 ).plot(name: "linear");
Utils.histogram( values: {bilinrand(4.0)}!1000000, steps: 100 ).plot(name: "bilinear");
Utils.histogram( values: {sum3rand(4.0)}!1000000, steps: 100 ).plot(name: "pseudo gauss");
Utils.histogram( values: {gauss(0.0, standardDeviation: 1.0)}!1000000, steps: 100 ).plot(name: "gauss");
Utils.histogram( values: {exprand(4.0, 0.5)}!1000000, steps: 100 ).plot(name: "exp");
)



[1,2,3].normalize;
[5, 6, 7, 6.5, 4.5, 3.5].plot("Some data")

{ 1.0.linrand }.dup(10000).histo(1000).plot(discrete: true);

(
var lo = 3.0, hi = 7.0;
hi.rand + lo;
)

coin(0.3)

(
{var freg = 5, sig, fregs;
fregs = freg * LFNoise2.ar({Rand(0.3, 1)}!3).bipolar(0.05);
sig = SinOsc.ar(fregs).sum + SinOsc.ar(freg);
[sig, SinOsc.ar(freg)]
}.plot(10, bounds: Rect(100, 100, 1000, 600))
)

(
SynthDef.new(\melo,{
    arg freq = 300, detune = 0.5;
    var sig, n = 10, freqsL, freqsR;
	freqsL = freq * LFNoise2.ar({Rand(0.08, 0.11)}!n).bipolar(detune).midiratio;
	freqsR = freq * LFNoise2.ar({Rand(0.08, 0.11)}!n).bipolar(detune).midiratio;
	freqsR.postln;
	sig = (SinOsc.ar(freq)!2) + [SinOsc.ar(freqsL).sum, SinOsc.ar(freqsR).sum];

	Out.ar(0, sig * 1.0/(n+1));
}).add;
)
Synth(\melo);



75.midicps
76.midicps
75.midicps * 2.pow(1/12)
abs(76.midicps - (75.midicps * 2.pow(1/12))) < 0.0001; // true

(
SynthDef.new(\melo,{
	arg freq = 200, atk = 0.002, sus = 0, rel = 1, detune = 0.015;
	var sig, env, sines, freqs;
	env = EnvGen.ar(Env(levels: [0,1,1,0], times: [atk,sus,rel], curve: [1,0,-6]), doneAction: Done.freeSelf);

	freqs = freq * LFNoise2.kr({Rand(0.08, 0.11)}!6).bipolar(detune).midiratio;
	sig = SinOsc.ar(freq: freq, mul: 0.4)!2;

	sines = freqs.collect({
		arg n;
		var tmp;
		tmp = SinOsc.ar(n);
		tmp = Pan2.ar(tmp, Rand(-0.9, 0.9));
		tmp = tmp.tanh;
		tmp;
	}).sum;

	sig = sig + sines;
	sig = sig * env;
	Out.ar(0, sig * 0.03);
}).add;
)
75.midicps

2.pow(1/12)

Synth(\melo, [freq: {rrand(250,500)}.value()]);

(
12.do {
	arg item, i;
	item.postln;
	i.postln;
}

-3.bipolor
)


({
	var sig, n;
	n = 6;
	sig = PinkNoise.ar(1.5)!2;
	sig = BPF.ar(sig, 150 + LFNoise1.kr({Rand(0.1,0.5)}!n).bipolar({Rand(50,150)}!6), 0.02, 1/0.02.sqrt);
	sig = sig * 5/n;
	sig;
}.play;
)

{LFNoise0.kr(0.5).bipolar(100)}.plot(10)
rrand(-5,5);

1/0.02.sqrt

 {Rand(250,500)}.value()