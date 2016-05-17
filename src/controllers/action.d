module diamond.controllers.action;

import diamond.controllers.status;

/// Wrapper for a controller action
class Action {
    private:
    /// The associated delegate.
    Status delegate() _delegate;

    /// The associated function pointer.
    Status function() _functionPointer;

    public:
    /**
    *   Creates a new controler action.
    *   Params:
    *       d = The delegate.
    */
    this(Status delegate() d) {
        _delegate = d;
    }

    /**
    *   Creates a new controler action.
    *   Params:
    *       f = The function pointer..
    */
    this(Status function() f) {
        _functionPointer = f;
    }

    /**
    *   Operator overload for using the wrapper as a call.
    *   Returns:
    *       The status of the call.
    */
    Status opCall() {
        if (_delegate) {
          return _delegate();
        }
        else if (_functionPointer) {
          return _functionPointer();
        }

        return Status.notFound;
    }
}

version (WebService) {
  import diamond.controllers.controller;
  import vibe.d;
  /// Wrapper for a controller's generate action
  class GenerateControllerAction {
      private:
      /// The associated delegate.
      Controller delegate(HTTPServerRequest,HTTPServerResponse,string[]) _delegate;

      /// The associated function pointer.
      Controller function(HTTPServerRequest,HTTPServerResponse,string[]) _functionPointer;

      public:
      /**
      *   Creates a new generate controler action.
      *   Params:
      *       d = The delegate.
      */
      this(Controller delegate(HTTPServerRequest,HTTPServerResponse,string[]) d) {
          _delegate = d;
      }

      /**
      *   Creates a new generate controler action.
      *   Params:
      *       f = The function pointer..
      */
      this(Controller function(HTTPServerRequest,HTTPServerResponse,string[]) f) {
          _functionPointer = f;
      }

      /**
      *   Operator overload for using the wrapper as a call.
      *   Params:
      *     request =   The request
      *     response =  The response
      *     route =     The route
      *   Returns:
      *     The controller.
      */
      Controller opCall(HTTPServerRequest request, HTTPServerResponse response, string[] route) {
          if (_delegate) {
            return _delegate(request, response, route);
          }
          else if (_functionPointer) {
            return _functionPointer(request, response, route);
          }

          return null;
      }
  }
}
