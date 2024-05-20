s.boot;

(
SynthDef(\drone_saws, {
    var sig, env, n = 8;

	var harms = Array.series(n, 1, 1) *.s [1.0, 1.01];
	var amps = (harms ** \exp.kr(0.4)).normalizeSum;
	var noise = {LFNoise2.kr(8).bipolar(\detune.kr(0.1)).midiratio}!harms.size;
	var vibrato = SinOsc.kr({LFNoise1.kr(1).range(0.1, Rand(0.5,1.0))}!harms.size).range(0.5, 0.9);
	var rq = {LFNoise1.kr(2).range(0.05, 0.4)}!(2*n);
	var trig = Dust.ar(15);

	sig = Saw.ar(\freq.kr(75) * harms * noise);
	sig = RLPF.ar(sig,
		freq: \freq.kr(75) * harms,
		rq: rq).tanh;
	sig = sig + (sig * Env.perc(0.01, 0.02).ar(gate: trig));
	sig = sig * amps;
	sig = Splay.ar(sig);

    env = EnvGen.kr(Env(
        levels: [0, 1, 1, 0],
        times: [\atk.kr(6.0), \sus.kr(4.0), \rel.kr(6.0)]), doneAction: Done.freeSelf);

	sig = Balance2.ar(sig[0], sig[1], pos: LFNoise1.kr(0.2).bipolar(0.85));
    sig = sig * env * \amp.kr(1.0);
    Out.ar(0, sig);
}).add;
)
Synth(\drone_saws, [\freq: 120, \amp: 1.0, \exp: 0.2]);

([1,2,3,4] ** 0.4).normalizeSum

{WhiteNoise.ar * Dust.kr(10).lag(0.4)}.play