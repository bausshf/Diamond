module diamond.controllers.controller;

version (WebServer) {
  version = WebServer_Or_WebService;
}
else version (WebService) {
  version = WebServer_Or_WebService;
}

version (WebServer_Or_WebService) {
  import vibe.d;

  import diamond.controllers.action;
  import diamond.controllers.status;
  import diamond.controllers.basecontroller;
}

// WebServer's will have a view associated with the controller, the view then contains information about the request etc.
version (WebServer) {
  /// Wrapper around a controller.
  class Controller(TView) : BaseController {
    private:
    /// The view associatedi with the controller.
    TView _view;

    protected:
    /**
    * Creates a new controller.
    * Params:
    *   view =  The view associated with the controller.
    */
    this(TView view) {
      super();

      _view = view;
    }

    public:
    final:
    @property {
      /// Gets the view.
      TView view() { return _view; }
    }

    /**
    * Generates a json response.
    * Params:
    *   jsonObject =  The object to serialize as json.
    * Returns:
    *   A status of Status.end
    */
    Status json(T)(T jsonObject) {
      return jsonString(jsonObject.serializeToJsonString());
    }

    /**
    * Generates a json response from a json string.
    * Params:
    *   s =  The json string.
    * Returns:
    *   A status of Status.end
    */
    Status jsonString(string s) {
      _view.response.headers["Content-Type"] = "text/json; charset=UTF-8";
      _view.response.bodyWriter.write(s);
      return Status.end;
    }

    /**
    * Redirects the response to a specific url.
    * Params:
    *   url =     The url to redirect to.
    *   status =  The status of the redirection. (Default is HTTPStatus.Found)
    * Returns:
    *   The status required for the redirection to work properly. (Status.end)
    */
    Status redirectTo(string url, HTTPStatus status = HTTPStatus.Found) {
      _view.response.redirect(url, status);

      return Status.end;
    }

    /**
    * Handles the view's current controller action.
    * Returns:
    *     The status of the controller action.
    */
    Status handle() {
      if (_view.isDefaultRoute) {
        if (_mandatoryAction) {
          auto mandatoryResult = _mandatoryAction();

          if (mandatoryResult != Status.success) {
            return mandatoryResult;
          }
        }

        if (_defaultAction) {
          return _defaultAction();
        }

        return Status.success;
      }

      ActionEntry methodEntries = _actions.get(_view.method, null);

      if (!methodEntries) {
          return Status.notFound;
      }

      auto action = methodEntries.get(_view.action, null);

      if (!action) {
        return Status.notFound;
      }

      if (_mandatoryAction) {
        auto mandatoryResult = _mandatoryAction();

        if (mandatoryResult != Status.success) {
          return mandatoryResult;
        }
      }

      return action();
    }
  }
}
// A webservice will not have a view associated with it, thus all information such as the request etc. is available within the controller
else version (WebService) {
  /// Wrapper around a controller.
  class Controller : BaseController {
    private:
    /// The request.
    HTTPServerRequest _request;
    /// The response.
    HTTPServerResponse _response;
    /// The route.
    immutable(string[]) _route;

    protected:
    /**
    * Creates a new controller.
    * Params:
    *   request =   The request of the controller.
    *   response =  The response of the controller.
    *   route =     The route of the controller.
    */
    this(HTTPServerRequest request, HTTPServerResponse response, string[] route) {
      super();

      _request = request;
      _response = response;
      _route = cast(immutable)route;
    }

    public:
    final:
    @property {
        /// Gets the request.
        auto request() { return _request; }
        /// Gets the response.
        auto response() { return _response; }
        /// Gets the http method.
        auto method() { return _request.method; }
        /// Gets the route.
        auto route() { return _route; }
        /// Gets the action of the controller. This is equivalent to route[1].
        auto action() { return _route.length >= 2 ? _route[1] : null; }
        /// Gets the action parameters of the controller. This is equivalent to route[2 .. $].
        auto params() { return _route.length >= 3 ? _route[2 .. $] : null; }
      }

    /**
    * Generates a json response.
    * Params:
    *   jsonObject =  The object to serialize as json.
    * Returns:
    *   A status of Status.end
    */
    Status json(T)(T jsonObject) {
      return jsonString(jsonObject.serializeToJsonString());
    }

    /**
    * Generates a json response from a json string.
    * Params:
    *   s =  The json string.
    * Returns:
    *   A status of Status.end
    */
    Status jsonString(string s) {
      response.headers["Content-Type"] = "text/json; charset=UTF-8";
      response.bodyWriter.write(s);
      return Status.end;
    }

    /**
    * Redirects the response to a specific url.
    * Params:
    *   url =     The url to redirect to.
    *   status =  The status of the redirection. (Default is HTTPStatus.Found)
    * Returns:
    *   The status required for the redirection to work properly. (Status.end)
    */
    Status redirectTo(string url, HTTPStatus status = HTTPStatus.Found) {
      response.redirect(url, status);

      return Status.end;
    }

    /**
    * Handles the view's current controller action.
    * Returns:
    *     The status of the controller action.
    */
    Status handle() {
      ActionEntry methodEntries = _actions.get(method, null);

      if (!methodEntries) {
          return Status.notFound;
      }

      auto action = methodEntries.get(action, null);

      if (!action) {
        return Status.notFound;
      }

      if (_mandatoryAction) {
        auto mandatoryResult = _mandatoryAction();

        if (mandatoryResult != Status.success) {
          return mandatoryResult;
        }
      }

      return action();
    }
  }

  /// Mixin template for generating the controllers.
  mixin template GenerateControllers(string[] controllerInitializers) {
	   import controllers;

     /// Generates the controller collection.
	  auto generateControllerCollection() {
		  enum generateFormat = q{
		      controllerCollection["%s"] = new GenerateControllerAction((request, response, route) {
			       return new %sController(request, response, route);
		      });
		  };

		  auto str = "";
		  foreach (controller; controllerInitializers) {
			   str ~= format(generateFormat, controller, controller);
		  }

		  return str;
	  }

    /// The controller collection.
    GenerateControllerAction[string] controllerCollection;

    /// Gets a controller by its name
    GenerateControllerAction getControllerAction(string name) {
      if (!controllerCollection || !controllerCollection.length) {
        mixin(generateControllerCollection);
      }

		  return controllerCollection.get(name, null);
	 }
  }
}
