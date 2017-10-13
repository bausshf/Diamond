module diamond.controllers.mapattributes;

import vibe.d : HTTPMethod;

struct HttpDefault {}
struct HttpMandatory {}
struct HttpAction {
  HTTPMethod method;
  string action;
}
