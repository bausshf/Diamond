module diamondapp;

version (WebServer) {
  version = WebServer_Or_WebService;
}
else version (WebService) {
  version = WebServer_Or_WebService;
}

version (WebServer_Or_WebService) {
  import std.string : format, strip;
  import std.array : split, join, array;
  import std.algorithm : filter;

  import vibe.d;

  import diamond.configurations;

  version (WebServer) {
      import diamond.views;
  }

  import web;

  private enum webBuildJson = import("web-build.json");

  version (WebServer) {
    /// Compile-time json deserialization of web-build.json
    private enum buildInformation = deserializeJson!SiteSettings(webBuildJson);

    /// Compile-time hack for buildInformation.views to work with applyViews
    private enum string[string] views = buildInformation.views;

    // This applies all views and parses them.
    mixin applyViews!(views);

    /// Static file handler
    private __gshared HTTPServerRequestDelegateS _staticFiles;
  }
  else version (WebService) {
      /// Compile-time json deserialization of web-build.json
      private enum buildInformation = deserializeJson!ServiceSettings(webBuildJson);

      import diamond.controllers;

    	/// Compile-time hack for buildInformation.controllers to work with GenerateControllers
    	private enum string[] controllerInitializers = buildInformation.controllers;

    	// This applies all controllers and parses them.
    	mixin GenerateControllers!(controllerInitializers);
  }

  private __gshared ServerSettings _serverSettings;
  @property ServerSettings serverSettings() {
    return _serverSettings;
  }

  shared static this() {
    import std.file : readText;
    _serverSettings = deserializeJson!ServerSettings(readText("web-runtime.json"));

    onApplicationStart();

    // server
    auto settings = new HTTPServerSettings;
    settings.port = serverSettings.port;
    settings.bindAddresses = serverSettings.bindAddresses;
    settings.errorPageHandler = (HTTPServerRequest request, HTTPServerResponse response, HTTPServerErrorInfo error) {
        onHttpError(request, response, error);
    };

    version (WebServer) {
      _staticFiles = serveStaticFiles(buildInformation.staticFileRoute);
    }

    listenHTTP(settings, &handleListen);

    version (WebServer) {
      enum appTypeName = "Web-server";
    }
    else version (WebService) {
      enum appTypeName = "Web-service";
    }

    logInfo(format("%s: %s has been started ...", appTypeName, buildInformation.name));
  }

  private void handleListen(HTTPServerRequest request, HTTPServerResponse response) {
    if (!onBeforeRequest(request, response)) {
      return;
    }

    version (WebServer) {
      scope auto path = request.path == "/" ? buildInformation.homeRoute : request.path[1 .. $];
    }
    else version (WebService) {
      scope auto path = request.path[1 .. $];
    }

    scope auto route = path.split("/").filter!(p => p && p.length && p.strip().length).array;

    version (WebServer) {
      import diamond.server;

      if (route[0] == buildInformation.staticFileRoute) {
          request.path = "/" ~ route[1 .. $].join("/");
          _staticFiles(request, response);
          return;
      }

      handleServerListen(request, response, route);
      onAfterRequest(request, response);
    }
    else version (WebService) {
      import diamond.service;

      handleServiceListen(request, response, route);
      onAfterRequest(request, response);
    }
  }
}
