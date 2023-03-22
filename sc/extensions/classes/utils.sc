Utils {
	*initTools {
		arg activateLimiter=true, gui=true, width=500;
		var menuSpacer=45, meterWidth=140, scopeWidth=400, d;
		var s = Server.local;

		Window.closeAll;
		Buffer.freeAll;
		ServerTree.removeAll;
		ServerQuit.removeAll;
		Tdef.removeAll;

		s.options.numBuffers = 1024 * 16;
		s.options.memSize = 8192 * 128;
		Server.local.waitForBoot(onComplete: {

			// Dictionary, load SynthDefs, load Snippets, free all nodes

			if(gui) {
				var window, screenBounds, left, top, height;
				screenBounds = Window.availableBounds;

				left = screenBounds.width-width;
				top = screenBounds.height;
				height = 200;
				window = FreqScopeWindow(width: width, height: height, scopeColor: Color.blue).window;
				window.bounds = Rect(left: left, top: top, width: width, height: height);

				top = top-menuSpacer-height;
				height = 300;
				window = Server.local.scope.window;
				window.bounds = Rect(left: left, top: 500, width: width, height: height);

				top = top-menuSpacer-height;
				height = 100;
				window = Server.local.makeWindow.window;
				window.bounds = Rect(left: left, top: top, height: height);

				top = top-(menuSpacer*2.6)-height;
				height = 225;
				window = Server.local.meter.window;
				window.bounds = Rect(left: left, top: top, width: meterWidth, height: height);

				Server.local.plotTree;
			};

			if(activateLimiter) {
				StageLimiter.activate;
			};
		});
	}

	*loadSetup {
		("../../Setup.scd").resolveRelative.load;
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