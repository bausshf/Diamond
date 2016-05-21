module diamond.views;

version (WebService) {
  // N/A
}
else {
  version = Not_WebService;
}

version (Not_WebService) {
  /// Mixin template for applying views.
  mixin template applyViews(string[string] views) {
    import std.string : format;

    version (WebServer) {
      import vibe.d;
    }

    import diamond.templates;
    import diamond.views.view;

    import diamond.exceptions : ViewException;

    version (WebServer) {
      import diamond.controllers : Status;

      import controllers;
    }

    import models;

    import diamond.views.viewimports;
    import diamond.views.viewgeneration;
    import diamond.views.getview;

    mixin ViewImports;
    mixin ViewGeneration;
    mixin GetView;
  }
}
