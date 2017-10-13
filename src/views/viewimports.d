module diamond.views.viewimports;

version (WebService) {
  // N/A
}
else {
  version = Not_WebService;
}

version (Not_WebService) {
  /// Generates the collection of views and imports their content
  mixin template ViewImports() {
    auto generateViewImports() {
      auto viewFormat = "aa[\"%s\"] = import(\"%s\");";
      auto viewsResult = "private @property auto viewInitCollection() { string[string] aa;";

      foreach (pageName,pageContent; views) {
        viewsResult ~= viewFormat.format(pageName,pageContent);
      }

      viewsResult ~= "return aa; }";

      return viewsResult;
    }

    mixin(generateViewImports);
  }
}
