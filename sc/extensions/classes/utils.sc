Utils {
	*initTools {
		arg activateLimiter = false;
		var width = 400, menuSpacer = 45, meterWidth = 140;
		// boot server
		Server.killAll;
		Server.local.options.numBuffers = 1024 * 16;
		Server.local.options.memSize = 8192 * 64;
		Server.local.boot;
		Server.local.waitForBoot(onComplete: {
			var window, screenBounds, left, top, height;
			screenBounds = Window.availableBounds;

			left = screenBounds.width-width;
			top = screenBounds.height;
			height = 300;
			window = FreqScopeWindow(width: width, height: height, scopeColor: Color.blue, bgColor: Color.white).window;
			window.bounds = Rect(left: left, top: top, width: width, height: height);
			window.alwaysOnTop = true;

			top = top-menuSpacer-height;
			height = 300;
			window = Server.local.scope.window;
			window.bounds = Rect(left: left, top: 500, width: width, height: height);
			window.alwaysOnTop = true;

			top = top-menuSpacer-height;
			height = 100;
			window = Server.local.makeWindow.window;
			window.bounds = Rect(left: left, top: top, width: width, height: height);
			window.alwaysOnTop = true;

			top = top-menuSpacer-height;
			height = 225;
			window = Server.local.meter.window;
			window.bounds = Rect(left: left, top: top, width: meterWidth, height: height);
			window.alwaysOnTop = true;

			//top = top-menuSpacer-height;
			//height = 400;
			Server.local.plotTree;
			//w.bounds = Rect(left: left, top: top, width: width-meterWidth, height: height);
			//w.alwaysOnTop = true;

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