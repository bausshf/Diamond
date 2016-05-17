module diamond.configurations.servicesettings;

version (WebService) {
  struct ServiceSettings {
    /// The name of the web site / web server.
    string name;
    /// Collection of all controllers
    string[] controllers;
  }
}
