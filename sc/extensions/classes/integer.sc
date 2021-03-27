+ SimpleNumber {
	tempodur {
		var tempo, beatdur;
		tempo = this;
		beatdur = 60 / tempo;
		^beatdur;
	}

	play {
		arg out=0;
		{
			var sig, env, amp;
			amp = 0.5;
			env = EnvGen.ar(Env.perc(0.001,0.2), doneAction: 2);
			sig = SinOsc.ar(this.midicps) * env * amp!2;
			Out.ar(out, sig);
		}.play;
	}
}