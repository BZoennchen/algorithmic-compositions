s.boot;
(
// harmonic swimming
play({
	var fundamental, partials, out, offset;
	fundamental = 150;
	partials = 20;
	out = 0.0;
	offset = Line.kr(start: 0, end: -0.02, dur: 25);
	partials.do({
		arg i; var noise;
		noise = LFNoise1.kr(freq: 6 + [4.0.rand2, 4.0.rand2], mul: 0.05, add: offset);
		out = FSinOsc.ar(freq: fundamental * (i+1), iphase: 0, mul: max(0, noise), add: out)
	});
out
})
)

({
Mix.fill(15,{
	var freq, env, sig;
	freq = exprand(100, 3000);
	env = EnvGen.kr(Env.perc(0, (freq**(-0.7))*100), Dust.kr(1/5));
	sig = SinOsc.ar(freq * LFNoise1.kr(1/6, 0.4, 1)) * env;
	sig = Pan2.ar(sig, LFNoise1.kr(1/8));
})*0.3
}.play )

(
{([
    SinOsc.ar(400, mul: 1) + SinOsc.ar(1200, mul: 1/3) + SinOsc.ar(2000, mul: 1/5) +
    SinOsc.ar(2800, mul: 1/7) + SinOsc.ar(3600, mul: 1/9) + SinOsc.ar(4400, mul: 1/11),
    SinOsc.ar(800, mul: 1/2) + SinOsc.ar(1600, mul: 1/4) + SinOsc.ar(2400, mul: 1/6) +
    SinOsc.ar(3200, mul: 1/8) + SinOsc.ar(4000, mul: 1/10) + SinOsc.ar(4800, mul: 1/12)]
)*0.1
}.scope
)

(
Ndef(\sine_sum, {
    var sig, amp, odd, even, env;
	amp = 0.1;
	odd = Array.series(6, 1, 2);
	even = odd + 1;
	env = EnvGen.ar(Env.perc(attackTime: {Rand(0.001, 1.03)}!6, releaseTime: {Rand(1.0, 1.3)}!6, curve: {Rand(-6, -2)}!6));
	sig = [
		Mix.ar(SinOsc.ar(freq: odd * \freq.kr(400), mul: 1/odd * env)),
		Mix.ar(SinOsc.ar(freq: even * \freq.kr(400), mul: 1/even * env))
	];
	sig*0.1;
}).play;
)
Utils.initTools
Array.series(6, 1, 2)

sum(Array.series(6, 1, 2)+1)

(
{Mix.ar(
   SinOsc.ar(
[72, 135, 173, 239, 267, 306, 355, 473, 512, 572, 626],
0, //phase
[0.25, 0.11, 0.12, 0.04, 0.1, 0.15, 0.05, 0.01, 0.03, 0.02, 0.12]
   ))}.scope(1)
)

exprand(100, 1000)
(
Ndef(\inharmonics, {
    var sig, inharmonics, env, partials = 20;
	env = EnvGen.ar(Env.perc(
		attackTime: 0,
		releaseTime: {Rand(0.2, 2.0)}!partials,
		level: {Rand(0, 1.0)}!partials,
		curve: -4));

	inharmonics = Array.fill(partials, {exprand(150, 4000)});
	sig = SinOsc.ar(inharmonics) * partials.reciprocal * env;
	sig = Splay.ar(sig);
	sig;
}).play;
)

{WhiteNoise.ar(0.1)}.play

(
Ndef(\white_noise, {
    var sig;
	sig = (Mix.fill(1000, {SinOsc.ar(rrand(1.0, 20000))})*0.001)!2;
	sig
}).play;
)

(
{
var signal, filter, cutoff, resonance;
signal = PinkNoise.ar(mul: 0.7);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);
RHPF.ar(signal, cutoff, resonance)}.scope(1) )

(
(
Ndef(\breeze, {
    var sig, cut, res;
    sig = PinkNoise.ar() * 0.7;
	cut = LFNoise2.kr(1).range(600, 1200);
	res = LFNoise2.kr(1).range(0.001, 1.0);
    sig = RLPF.ar(sig, cut, res);
	sig = Pan2.ar(sig, LFNoise2.ar(0.5).range(-0.5, 0.5));
}).play;
)
)

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;

burstEnv = Env.perc(0, burstLength);
noiseBurst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1)));

freqSpecs = `[
		{rrand(100, 1200)}.dup(totalHarm),
		{rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.01),
		{rrand(2.0, 4.0)}.dup(totalHarm)];

Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.8) }.scope(1)
)

(
Ndef(\bell_additive, {
    var sig, inharmonics, env, partials = 10;
    env = EnvGen.ar(Env.perc(
        attackTime: 0,
        releaseTime: {rrand(1.0, 3.0)}!partials,
        level: {rrand(0.3, 1.0)}!partials),
	gate: Impulse.kr(1)
	);

    inharmonics = Array.fill(partials, {rrand(100, 1200)});
    sig = SinOsc.ar(inharmonics) * partials.reciprocal * env;
    sig = Splay.ar(sig);
    sig;
}).play;
)

(
Ndef(\bell_physical, {
    var chime, freqSpecs, sig, sigBurst, totalHarm = 10;
	var envBurst, burstLength = 0.0001;

	envBurst = EnvGen.kr(Env.perc(attackTime: 0, releaseTime: burstLength), gate: Impulse.kr(1));
	sigBurst = PinkNoise.ar() * envBurst;

	freqSpecs = `[
		{rrand(100, 1200)}.dup(totalHarm),                         // freqs
		{rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.01), // amps
		{rrand(2.0, 4.0)}.dup(totalHarm)];                         // ring times

	sig = Klank.ar(freqSpecs, sigBurst) * totalHarm.reciprocal;
	sig;
}).play;
)

(
{
var signal, filter, cutoff, resonance;
signal = PinkNoise.ar(mul: 0.7); cutoff = MouseX.kr(40, 10000, 1); resonance = MouseY.kr(0.01, 2.0);
RLPF.ar(signal, cutoff, resonance)}.scope(1) )

(
{
var signal, filter, cutoff, resonance;
signal = PinkNoise.ar(mul: 0.7); cutoff = MouseX.kr(40, 10000, 1); resonance = MouseY.kr(0.01, 2.0);
BPF.ar(signal, cutoff, resonance)}.scope(1) )


Array.fill(16, {100 + 200.rand()}).size.reciprocal;
Mix.fill(4, {SinOsc.ar(rrand(1.0, 20000))})*0.001
SinOsc.ar(rrand(1.0, 20000))!2