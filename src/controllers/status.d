module diamond.controllers.status;

/// Enumeration of controller statuses.
enum Status {
    /// Indicates the controller action was executed successfully.
    success,
    /// Indicates the controller action wasn't found.
    notFound,
    /**
    * Indicates the response should end after executing the actions.
    * This is useful if you respond with a different type of data than html such as json etc.
    */
    end
}
