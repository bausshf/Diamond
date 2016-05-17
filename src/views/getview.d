module diamond.views.getview;

version (WebServer) {
  /// Generates the getView function.
  mixin template GetView() {
    auto generateGetView() {
      string getViewMixin = "
        View getView(HTTPServerRequest request, HTTPServerResponse response, string[] route, bool checkRoute) {
          auto pageName = routableViews.get(route[0], checkRoute ? null : route[0]);

          if (!pageName) {
            return null;
          }

          switch (pageName) {
      ";

      foreach (pageName,pageContent; viewInitCollection) {
        getViewMixin ~= format(q{
          case "%s": {
            return new view_%s(request, response, "%s", route);
          }
        }, pageName, pageName, pageName);
      }

      getViewMixin ~= "
            default: return null; // 404 ...
          }
        }
      ";

      return getViewMixin;
    }

    mixin(generateGetView);
  }
}
