module diamond.server;

version (WebServer) {
  import vibe.d : HTTPServerRequest, HTTPServerResponse, HTTPStatusException, HTTPStatus;

  import diamondapp : serverSettings, getView;

  void handleServerListen(HTTPServerRequest request, HTTPServerResponse response, string[] route) {
    auto page = getView(request, response, route, true);

    if (!page) {
      throw new HTTPStatusException(HTTPStatus.NotFound);
    }
    else {
      foreach (headerKey,headerValue; serverSettings.defaultHeaders) {
        response.headers[headerKey] = headerValue;
      }

      auto pageResult = page.generate();

      if (pageResult && pageResult.length) {
        response.bodyWriter.write(pageResult);
      }
    }
  }
}
