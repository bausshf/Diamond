module diamond.views.viewgeneration;

version (WebService) {
  // N/A
}
else {
  version = Not_WebService;
}

version (Not_WebService) {
  /// Generates all the views into classes.
  mixin template ViewGeneration() {
    auto generateViews() {
      auto routableViewsMixin = "private enum routableViews = [";
      bool hasRoutes = false;

      version (WebServer) {
        enum pageClassFormat = q{
          final class view_%s : View {
            public:
            %s

            this(HTTPServerRequest request, HTTPServerResponse response, string name,
              string[] route = null) {
              super(request, response, name, route);

              %s
            }

            %s

            override string generate() {
              import std.array;
              import std.string;
              import std.algorithm;
              import std.conv : to;
              import vibe.d;

              try {
                %s
                %s

                %s
              }
              catch (HTTPStatusException statusException) {
                throw statusException;
              }
              catch (Throwable t) {
                throw new ViewException("%s", t);
              }
            }
          }
        };
      }
      else {
        enum pageClassFormat = q{
          final class view_%s : View {
            public:
            %s

            this(string name) {
              super(name);

              %s
            }

            %s

            override string generate() {
              import std.array;
              import std.string;
              import std.algorithm;
              import std.conv : to;

              try {
                %s
                %s

                %s
              }
              catch (Throwable t) {
                throw new ViewException("%s", t);
              }
            }
          }
        };
      }


      enum placeHolderFormat = q{
        foreach (key,value; %s) {
          placeHolders[key] = value;
        }
      };

      enum appendFormat = q{
        append(%s);
      };

      enum escapedFormat = q{
        escape(%s);
      };

      enum endFormat = "return prepare();";

      enum endLayoutFormat = `return prepare("%s");`;

      string viewMixin = "";

      foreach (pageName,pageContent; viewInitCollection) {
        string pageGenerateModel = "";
        string pageMixinPlaceHolders = "";
        string pageMixin = "";
        string pageMembers = "";
        string pageConstructor = "";
        string pageController = "";
        string pageLayout = null;

        auto pageParts = parseTemplate(pageContent);

        foreach (part; pageParts) {
          if (!part.content || !part.content.strip().length) {
            continue;
          }

          switch (part.contentMode) {
            case ContentMode.appendContent: {
              switch (part.name) {
                case "expressionValue": {
                  pageMixin ~= appendFormat.format(part.content);
                  break;
                }

                case "escapedValue": {
                  pageMixin ~= escapedFormat.format("`" ~ part.content ~ "`");
                  break;
                }

                case "expressionEscaped": {
                  pageMixin ~= escapedFormat.format(part.content);
                  break;
                }

                default: {
                  pageMixin ~= appendFormat.format("`" ~ part.content ~ "`");
                  break;
                }
              }

              break;
            }

            case ContentMode.mixinContent: {
              pageMixin ~= part.content;
              break;
            }

            case ContentMode.metaContent: {
              string[string] data;
              foreach (entry; part.content.replace("\r", "").split("---")) {
                if (entry && entry.length) {
                  auto keyIndex = entry.indexOf(':');
                  auto key = entry[0 .. keyIndex].strip().replace("\n", "");
                  data[key] = entry[keyIndex + 1 .. $];
                }
              }

              foreach (key, value; data) {
                switch (key) {
                  case "placeHolders": {
                    pageMixinPlaceHolders = placeHolderFormat.format(value);
                    break;
                  }

                  version (WebServer) {
                    case "route": {
                      auto stripped = value.strip().replace("\n", "");
                      routableViewsMixin ~= format("\"%s\" : \"%s\",", stripped, pageName);
                      hasRoutes = true;
                      break;
                    }
                  }

                  case "model": {
                    if (value && value.length) {
                      pageGenerateModel = format(q{
                        string generate(%s newModel) {
                          model = newModel;

                          return generate();
                        }
                      }, value);

                      pageMembers ~= value ~ " model;\r\n";
                    }

                    break;
                  }

                  version (WebServer) {
                    case "controller": {
                      if (value && value.length) {
                        pageController = q{
                          auto controllerResult = controller.handle();

                          if (controllerResult == Status.notFound) {
                            throw new HTTPStatusException(HTTPStatus.NotFound);
                          }
                          else if (controllerResult == Status.end) {
                            return null;
                          }
                        };

                        pageMembers ~= format("%s!view_%s controller;\r\n", value, pageName);
                        pageConstructor ~= format("controller = new %s!view_%s(this);\r\n", value, pageName);
                      }

                      break;
                    }
                  }

                  case "layout": {
                    if (value && value.length) {
                      pageLayout = value.strip().replace("\n", "");
                    }
                    break;
                  }

                  default: break;
                }
              }

              break;
            }

            default: break;
          }
        }

        pageMixin ~= pageLayout ? format(endLayoutFormat, pageLayout) : endFormat;
        viewMixin ~= pageClassFormat.format(
          pageName, pageMembers,
          pageConstructor, pageGenerateModel,
          pageController, pageMixinPlaceHolders,
          pageMixin, pageName
        );
      }

      if (hasRoutes) {
        routableViewsMixin.length -= 1;
      }

      routableViewsMixin ~= "];";
      viewMixin ~= routableViewsMixin;

      return viewMixin;
    }

    mixin(generateViews);
  }
}
