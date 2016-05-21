module diamond.configurations.sitesettings;

version (WebServer) {
  struct SiteSettings {
    /// The name of the web site / web server.
    string name;
    /// Collection of all views
    string[string] views;
    /// The home route
    string homeRoute;
    /// The static file route
    string staticFileRoute;
  }
}
