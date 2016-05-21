module diamond.configurations.sitesettings;

version (WebService) {
  // N/A
}
else {
  version = Not_WebService;
}

version (Not_WebService) {
  struct SiteSettings {
    version (WebServer) {
      /// The name of the web site / web server.
      string name;
    }
    
    /// Collection of all views
    string[string] views;

    version (WebServer) {
      /// The home route
      string homeRoute;
      /// The static file route
      string staticFileRoute;
    }
  }
}
