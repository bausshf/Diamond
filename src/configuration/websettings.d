module diamond.configuration.websettings;

version (WebServer) {
  version = WebServer_Or_WebService;
}
else version (WebService) {
  version = WebServer_Or_WebService;
}

version (WebServer_Or_WebService) {
  package(diamond) {
    WebSettings webSettings;
  }

  class WebSettings {
    protected:
    this() { }

    bool onBeforeRequest(HTTPServerRequest request, HTTPServerResponse response) {
      throw new Exception("Must override this ...");
    }

    void onAfterRequest(HTTPServerRequest request, HTTPServerResponse response) {
      throw new Exception("Must override this ...");
    }

    void onHttpError(HTTPServerRequest request, HTTPServerResponse response, HTTPServerErrorInfo error) {
      throw new Exception("Must override this ...");
    }


    public:
    static:
    void initialize(WebSettings settings) {
      webSettings = settings;
    }
  }
}
