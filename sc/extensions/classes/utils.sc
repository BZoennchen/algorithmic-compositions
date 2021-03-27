Utils {
	*initTools {
		// boot server
		Server.killAll;
		Server.local.boot;
		Server.local.quit;

		// server tools
		Server.local.makeWindow;
		Server.local.meter;
		Server.local.scope;
		FreqScope.new;
		Server.local.plotTree;
	}

	*initSynths {
		SynthDescLib.global.read;
	}
}