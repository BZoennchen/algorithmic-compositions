// oscillators: band-limited (antialiasing)
SinOsc, Saw, Pulse, Blip

// oscillators: non-band-limited
// (optimal for low freq, will alias at high freqs)
LFSaw, LFPulse, LFTri, VarSaw

// noise generators
WhiteNoise, PinkNoise, LFNoise0, LFNoise1

// filters: lo/hi pass (R=resonant), lo/hi shelf, band pass/reject
LPF, HPF, RLPF, RHPF, BLowShelf, BHiShelf, BPF, BRF
(see also BEQSuite)

// triggers
Impulse, Dust, Trig

// envelopes
Line, XLine, EnvGen

// sample playback
PlayBuf, BufRd

// delays
DelayN, DelayL, DelayC, // no feedback
CombN, CombL, CombC // with feedback

// stereo panners/balancers
Pan2, Balance2