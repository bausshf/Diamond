module diamond.configurations;

public {
  version (WebServer) {
    import diamond.configurations.sitesettings;
  }
  else version (WebService) {
    import diamond.configurations.servicesettings;
  }

  import diamond.configurations.serversettings;
}
