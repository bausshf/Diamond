module diamond.service;

version (WebService) {
  import vibe.d : HTTPServerRequest, HTTPServerResponse, HTTPStatusException, HTTPStatus;

  import diamondapp : serverSettings, getControllerAction;

  import diamond.controllers;

  void handleServiceListen(HTTPServerRequest request, HTTPServerResponse response, string[] route) {
    if (route.length < 2) {
      throw new HTTPStatusException(HTTPStatus.badRequest);
    }

    auto controllerAction = getControllerAction(route[0]);

    if (!controllerAction) {
      throw new HTTPStatusException(HTTPStatus.NotFound);
    }

    auto status = controllerAction(request, response, route).handle();

    if (status == Status.notFound) {
      throw new HTTPStatusException(HTTPStatus.NotFound);
    }
    else if (status != Status.end) {
      foreach (headerKey,headerValue; serverSettings.defaultHeaders) {
        response.headers[headerKey] = headerValue;
      }
    }
  }
}
