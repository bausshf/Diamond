module diamond.exceptions.viewexception;

version (WebService) {
  // N/A
}
else {
  version = Not_WebService;
}

version (Not_WebService) {
  /// Exception thrown upon encountering an error thrown by a view.
  class ViewException : Exception
  {
    private:
    /// The view name.
    string _viewName;
    /// The actual error thrown.
    Throwable _error;

    public:
    /**
    * Creates a new view exception.
    * Params:
    *   viewName =  The name of the view that threw the error.
    *   error =     The error. This can be both unrecoverable errors and recoverable errors, since they're treated the same.
    *   fn =        The file.
    *   ln =        The line.
    */
    this(string viewName, Throwable error, string fn = __FILE__, size_t ln = __LINE__) {
      _viewName = viewName;
      _error = error;

      super("...", fn, ln);
    }

    /**
    * Retrieves a string equivalent to the exception text.
    * Returns:
    *   A string equivalent to the exception text.
    */
    override string toString() {
      return "view: " ~ _viewName ~ "\r\n\r\n" ~ _error.toString();
    }
  }
}
