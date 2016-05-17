module diamond.configurations;

public {
  version (WebServer) {
    import diamond.configurations.sitesettings;
    import diamond.configurations.websettings;
  }
  else version (WebService) {
    import diamond.configurations.servicesettings;
    import diamond.configurations.websettings;
  }

  import diamond.configurations.serversettings;
}
