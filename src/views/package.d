module diamond.views;

version (WebServer) {
  /// Mixin template for applying views.
  mixin template applyViews(string[string] views) {
    import std.string : format;

    import vibe.d;

    import diamond.templates;
    import diamond.views.view;
    import diamond.controllers : Status;
    import diamond.exceptions : ViewException;

    import controllers;
    import models;

    import diamond.views.viewimports;
    import diamond.views.viewgeneration;
    import diamond.views.getview;

    mixin ViewImports;
    mixin ViewGeneration;
    mixin GetView;
  }
}
