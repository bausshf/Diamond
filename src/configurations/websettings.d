module diamond.configurations.websettings;

version (WebServer) {
  version = WebServer_Or_WebService;
}
else version (WebService) {
  version = WebServer_Or_WebService;
}

version (WebServer_Or_WebService) {
  import vibe.d;

  package(diamond) {
    public WebSettings webSettings;
  }

  class WebSettings {
    protected:
    this() { }

    public:
    bool onBeforeRequest(HTTPServerRequest request, HTTPServerResponse response) {
      throw new Exception("Must override this ...");
    }

    void onAfterRequest(HTTPServerRequest request, HTTPServerResponse response) {
      throw new Exception("Must override this ...");
    }

    void onHttpError(HTTPServerRequest request, HTTPServerResponse response, HTTPServerErrorInfo error) {
      throw new Exception("Must override this ...");
    }


    static:
    void initialize(WebSettings settings) {
      webSettings = settings;
    }
  }
}
