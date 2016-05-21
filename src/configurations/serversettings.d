module diamond.configurations.serversettings;

version (WebServer) {
  version = WebServer_Or_WebService;
}
else version (WebService) {
  version = WebServer_Or_WebService;
}

version (WebServer_Or_WebService) {
  struct ServerSettings {
    /// The addresses to bind
    string[] bindAddresses;
    /// The port to bind
    ushort port;
    /// Collection of default headers
    string[string] defaultHeaders;
  }
}
