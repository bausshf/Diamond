module diamond.views.view;

version (WebServer) {
  import std.string : format, strip;
  import std.array : join, replace, split, array;
  import std.conv : to;
  import std.algorithm : filter;

  import vibe.d : HTTPServerRequest, HTTPServerResponse;

  /**
  * Wrapper around a view.
  */
  class View {
    private:
    /// The request.
    HTTPServerRequest _request;
    /// The response.
    HTTPServerResponse _response;
    /// The name.
    string _name;
    /// The route.
    immutable(string[]) _route;
    /// The place-holders.
    string[string] _placeHolders;
    /// The routes
    string[] _result;

    protected:
    /**
    * Creates a new view.
    * Params:
    *   request =   The request of the view.
    *   response =  The response of the view.
    *   name =      The name of the view.
    *   route =     The route of the view.
    */
    this(HTTPServerRequest request, HTTPServerResponse response, string name, string[] route) {
      _request = request;
      _response = response;
      _name = name;
      _route = cast(immutable)route;

      _placeHolders["doctype"] = "<!DOCTYPE html>";
      _placeHolders["defaultRoute"] = _route[0];
    }

    public:
    final {
      @property {
        /// Gets the request.
        auto request() { return _request; }
        /// Gets the response.
        auto response() { return _response; }
        /// Gets the http method.
        auto method() { return _request.method; }
        /// Gets the name.
        auto name() { return _name; }
        /// Sets the name.
        void name(string name) {
          _name = name;
        }
        /// Gets the route.
        auto route() { return _route; }
        /// Gets the place-holders.
        ref auto placeHolders() { return _placeHolders; }
        /// Gets a boolean determining whether the view is using the default route or not. This is equivalent to route[0].
        auto isDefaultRoute() { return _route.length == 1; }
        /// Gets the action of the view. This is equivalent to route[1].
        auto action() { return _route.length >= 2 ? _route[1] : null; }
        /// Gets the action parameters of the view. This is equivalent to route[2 .. $].
        auto params() { return _route.length >= 3 ? _route[2 .. $] : null; }
        /**
        * Gets the root-path.
        * Note: Calling this property might be expensive, so caching the value is recommended.
        */
        auto rootPath() {
          // This makes sure that it's not retrieving the page's route, but the requests.
          // It's useful in terms of a view redirecting to another view internally.
          // Since the redirected view will have the route of the redirection and not the request.
          scope auto path = request.path == "/" ? "default" : request.path[1 .. $];
        	scope auto route = path.split("/").filter!(p => p && p.length && p.strip().length).array;

          if (!route || route.length <= 1) {
            return "..";
          }

          auto rootPathValue = "";
          foreach (i; 0 .. route.length) {
            rootPathValue ~= (i == (route.length - 1) ? ".." : "../");
          }
          return rootPathValue;
        }
      }

      /**
      * Prepares the view with its generated html by replacing place-holders.
      * Params:
      *   layout =  The layout associated with the view.
      * Returns:
      *   A string equivalent to the final html result.
      */
      auto prepare(string layout = null)  {
        auto result = _result.join("");

        if (layout) {
          auto layoutView = view(layout);

          if (layoutView) {
            layoutView.name = name;
            auto layoutResult = layoutView.generate();

            if ("head" in _placeHolders) {
              layoutResult = layoutResult.replace("@<head>", _placeHolders["head"]);
            }

            result = layoutResult.replace("@<view>", result);
          }
        }

        foreach (key,value; _placeHolders) {
          result = result.replace(format("@<%s>", key), value);
        }

        auto rootPathValue = rootPath; // Caching the root-path value
        return result.replace("@..", rootPathValue);
      }

      /**
      * Appends data to the view's html.
      * This will append data to the current position.
      * Generally this is not necessary, because of the template attributes such as @=.
      * Params:
      *   data =  The data to append.
      */
      void append(T)(T data)  {
        _result ~= to!string(data);
      }

      /**
      * Appends html escaped data to the view's html.
      * This will append data to the current position.
      * Generally this is not necessary, because of the template attributes such as @().
      * Params:
      *   data =  The data to escape.
      */
      void escape(T)(T data) {
        auto toEscape = to!string(data);
        string result = "";

        foreach (c; toEscape) {
        	switch (c) {
        		case '<': {
        			result ~= "&lt;";
        			break;
        		}

        		case '>': {
        			result ~= "&gt;";
        			break;
        		}

        		case '"': {
        			result ~= "&quot;";
        			break;
        		}

        		case '\'': {
        			result ~= "&#39";
        			break;
        		}

        		case '&': {
        			result ~= "&amp;";
        			break;
        		}

        		case ' ': {
        			result ~= "&nbsp;";
        			break;
        		}

        		default: {
        			if (c < ' ') {
        				result ~= format("&#%d;", c);
        			}
        			else {
        				result ~= to!string(c);
        			}
        		}
        	}
        }

        append(result);
      }

      /**
      * Retrieves a view by name.
      * This wraps around getView.
      * Params:
      *   name =        The name of the view to retrieve.
      *   checkRoute =  Boolean determining whether the name should be checked upon default routes.
      * Returns:
      *   The view.
      */
      auto view(string name, bool checkRoute = false) {
        import diamondapp : getView; // To retrieve views ...

        return getView(this.request, this.response, [name], checkRoute);
      }

      /**
      * Retrieves the generated html of a view.
      * This should generally only be used to render partial views into another view.
      * Params:
      *   name =  The name of the view to generate the html of.
      * Returns:
      *   A string qeuivalent to the generated html.
      */
      string retrieve(string name) {
        return view(name).generate();
      }

      /**
      * Will render another view into this one.
      * Params:
      *   name =  The name of the view to render.
      */
      void render(string name) {
        append(retrieve(name));
      }
    }

    /**
    * Generates the html of the view.
    * This is override by each view implementation.
    * Returns:
    *   A string equivalent to the generated html.
    */
    string generate() {
      return prepare();
    }
  }
}
