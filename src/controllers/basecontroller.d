module diamond.controllers.basecontroller;

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

  class BaseController {
    protected:
    /// Alias for the action entry.
    alias ActionEntry = Action[string];
    /// Alias for the method entry.
    alias MethodEntry = ActionEntry[HTTPMethod];

    /// Collection of actions.
    MethodEntry _actions;
    /// The default action for the controller.
    Action _defaultAction;
    /// The mandatory action for the controller.
    Action _mandatoryAction;

    /// Creates a new base controller.
    this() {

    }

    /**
    * Maps an action to a http method by a name.
    * Params:
    *     method =    The http method.
    *     action =    The action name.
    *     fun =       The controller action associated with the mapping.
    */
    void mapAction(HTTPMethod method, string action, Action fun) {
      _actions[method][action] = fun;
    }

    /**
    * Maps an action to a http method by a name.
    * Params:
    *     method =    The http method.
    *     action =    The action name.
    *     d =       The controller action associated with the mapping.
    */
    void mapAction(HTTPMethod method, string action, Status delegate() d) {
      _actions[method][action] = new Action(d);
    }

    /**
    * Maps an action to a http method by a name.
    * Params:
    *     method =    The http method.
    *     action =    The action name.
    *     f =       The controller action associated with the mapping.
    */
    void mapAction(HTTPMethod method, string action, Status function() f) {
      _actions[method][action] = new Action(f);
    }

    /**
    * Maps a default action for the controller.
    * Params:
    *     fun =       The controller action associated with the mapping.
    */
    void mapDefault(Action fun) {
      _defaultAction = fun;
    }

    /**
    * Maps a default action for the controller.
    * Params:
    *     d =       The controller action associated with the mapping.
    */
    void mapDefault(Status delegate() d) {
      _defaultAction = new Action(d);
    }

    /**
    * Maps a default action for the controller.
    * Params:
    *     f =       The controller action associated with the mapping.
    */
    void mapDefault(Status function() f) {
      _defaultAction = new Action(f);
    }

    // ...
    /**
    * Maps a mandatory action for the controller.
    * Params:
    *     fun =       The controller action associated with the mapping.
    */
    void mapMandatory(Action fun) {
      _mandatoryAction = fun;
    }

    /**
    * Maps a mandatory action for the controller.
    * Params:
    *     d =       The controller action associated with the mapping.
    */
    void mapMandatory(Status delegate() d) {
      _mandatoryAction = new Action(d);
    }

    /**
    * Maps a mandatory action for the controller.
    * Params:
    *     f =       The controller action associated with the mapping.
    */
    void mapMandatory(Status function() f) {
      _mandatoryAction = new Action(f);
    }
  }
}
