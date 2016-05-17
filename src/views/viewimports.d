module diamond.views.viewimports;

version (WebServer) {
  /// Generates the collection of views and imports their content
  mixin template ViewImports() {
    auto generateViewImports() {
      auto viewFormat = "\"%s\" : import(\"%s\"),";
      auto viewsResult = "private enum viewInitCollection = [";

      foreach (pageName,pageContent; views) {
        viewsResult ~= viewFormat.format(pageName,pageContent);
      }

      viewsResult.length -= 1;
      viewsResult ~= "];";

      return viewsResult;
    }

    mixin(generateViewImports);
  }
}
