Utils {
	*initTools {
		arg activateLimiter = false;
		// boot server
		Server.killAll;
		Server.local.options.numBuffers = 1024 * 16;
		Server.local.options.memSize = 8192 * 64;
		Server.local.boot;
		Server.local.waitForBoot(onComplete: {
			Server.local.makeWindow;
			Server.local.meter;
			Server.local.scope;
			FreqScopeWindow.new(width: 1536, height: 512, scopeColor: Color.blue, bgColor: Color.white);
			Server.local.plotTree;

			if(activateLimiter) {
				StageLimiter.activate;
			}
		} );
		//Server.local.quit;
		// server tools
	}

	*initProxy {
		arg server;
		var proxy;
		proxy = ProxySpace.push(server);
		//start tempo clock
		proxy.makeTempoClock;
		//give proxyspace a tempo
		proxy.clock.tempo = 2;
		^proxy;
	}

	*histogram {
		arg values, steps = 500;
		var histogram;
		histogram = values.histo(steps: steps).normalizeSum;
		^histogram;
	}
}