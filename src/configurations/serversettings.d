module diamond.configurations.serversettings;

struct ServerSettings {
  /// The addresses to bind
  string[] bindAddresses;
  /// The port to bind
  ushort port;
  /// Collection of default headers
  string[string] defaultHeaders;
}
