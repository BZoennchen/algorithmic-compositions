s.boot;

(
b = Buffer.alloc(s,512,1,{|z|z.sine1Msg(1.0/[1,3,5,7,9,11,13,15,17])});
c = Buffer.read(s, "/pathtothesample");

fork{
    s.sync;
~sound = {
    var sig;
    var local;
	var f = [30,60,15]*Lag.kr(TChoose.kr(Impulse.kr(0.05),[0.75, 0.5, 1]), 8);
    sig = Mix(COsc.ar(b.bufnum,f + SinOsc.ar(f*25, 0, LFTri.kr(0.01).range(0, 10)), [0.1, 0.1001, 0.2], 0.2))*0.1;
	sig = LeakDC.ar(Ringz.ar(sig, TChoose.kr(Impulse.kr(0.1),[88, 97, 99, 100].midicps), LFTri.kr([0.05, 0.051]).range(0.2, 0.5)));
	sig = sig + Decimator.ar(sig, 48000*LFNoise0.kr(1).range(0.25, 1), TChoose.kr(Impulse.kr(4), [8, 12, 16, 24]), 0.4);
    sig = LPF.ar(sig, 3000*LFTri.kr(0.01).range(0.1, 1));
    sig = sig + (Splay.ar(Array.fill(4, {PlayBuf.ar(2, c, rrand(-0.8, 0.8), loop: 2)*0.01}), 0.5));
    sig = CombC.ar(sig, 1.0, [0.1, 0.2], LFTri.kr(0.05).range(5, 9));

    local = sig + LocalIn.ar(2);
    15.do({
            local = AllpassN.ar(local, 0.06, Rand(0.001, 0.06), 3)
          });
    LocalOut.ar(local*0.4);

    Out.ar(0, Limiter.ar(LPF.ar(local, 4000), 0.8)*EnvGen.kr(Env([0, 1, 1, 0],[3, 100, 10])));
}.play;
}
)

s.quit;

(
{
	var sig, local;
	var f = [30,60,15]*Lag.kr(TChoose.kr(Impulse.kr(0.05),[0.75, 0.5, 1]), 8);
	var vib = SinOsc.ar(f*25) * LFTri.kr(0.01).range(0, 20);
	sig = Mix(COsc.ar(b, f+vib, [0.1, 0.1001, 0.2], 0.2));
	sig = Ringz.ar(sig, TChoose.kr(Dust.kr([1.0,1.1]), [88, 97, 99, 100].midicps, LFTri.kr([0.05, 0.051]).range(0.2, 0.5)), 0.25);
	sig = LPF.ar(sig, f*40);

	// reverb
	local = sig + LocalIn.ar(2);

	15.do {
		local = AllpassN.ar(local, 0.06, Rand(0.001, 0.06), 3);
	};
	LocalOut.ar(local * 0.4);

	Out.ar(0, local);
}.play;
)