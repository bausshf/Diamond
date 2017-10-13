# Quick links

* Syntax Reference
  https://github.com/bausshf/Diamond/wiki/Syntax-Reference
* Comparison with ASP.NET Razor
  https://github.com/bausshf/Diamond/wiki/Comparison
* Guide to stand-alone
  https://github.com/bausshf/Diamond/wiki/Using-Diamond-:-Stand-alone
* Guide to webservices
  https://github.com/bausshf/Diamond/wiki/Using-Diamond-:-Webservice
* Guide to websites
  https://github.com/bausshf/Diamond/wiki/Using-Diamond-:-Website
* Guide to contributing
  https://github.com/bausshf/Diamond/wiki/Contributing
* Tutorial for controllers
  https://github.com/bausshf/Diamond/wiki/Controller-Tutorial
* Specialized view rendering
  https://github.com/bausshf/Diamond/wiki/Specialized-View-Rendering

# What is Diamond?
Diamond is a MVC / Template library written in Diamond. It was written originally as an alternative to the Diet templates in vibe.d, but now its functonality and capabilities are far beyond templating only.

# What does Diamond depend on?
Diamond can be used stand-alone without depending on any third-party libraries, other than the standard library Phobos. It has 3 types of usage, websites and webservices, where it's used on-top of vibe.d and as a stand-alone mvc/template library.

# What is the dependency to vibe.d?
Diamond was originally written to be used in a hobby project as an alternative syntax to the "standard" diet templates. Thus it was originally build on-top vibe.d as a pure website template. It has now evolved to be able to run stand-alone however.

# What syntax does Diamond use?
Diamond is heavily inspired by the ASP.NET razor syntax, but still differs a lot from it. You can read more about that in the wiki under Syntax Reference or the comparison with ASP.NET Razor

# What advantages does Diamond have over Diet?
It let's you control the markup entirely, can be integrated with any-type of D code, not limited to vibe.d and can be used as standard template library for any type of project such as email templates etc. It also allows for special rendering, easy controller implementations and management of request data, response etc.

# How does Diamond work, does it parse the views on every request like eg. PHP?
No. Views are parsed once during compile-time and then compiled into D code that gets executed on run-time; keeping view generation to a minimum, while performance and speed is kept high. The downside of this is that on every changes in code you'll need to recompile. However it's recommended to setup an environment that checks for changes and then simply recompiles when changes are found. On Windows this can be done with https://msdn.microsoft.com/en-us/library/aa365465(VS.85).aspx or if you don't mind .NET you can use https://msdn.microsoft.com/en-us/library/system.io.filesystemwatcher(v=vs.110).aspx (Not sure about \*nix systems as I have very little experience with those.)

# What are some main features of Diamond?
Rich and elegant template syntax, natively compiled, views are parsed at compile-time, cross-platform (Will be able to be used on every platform that can compile D -- in some cases vibe.d) and at last it let's you focus on writing the code you need, and not the code you need to get things working.

# Is it easy to use Diamond?
Diamond has been made in a way that it's very easy to use and integrate into projects. It also takes care of all background setup for vibe.d projects, letting you focus on just writing your websites / webservices logic, rather than a huge hassle of setup.

# Is there any syntax guide-lines?
View the wiki under "Comparison" as it compares the syntax with ASP.NET's razor syntax, as well shows the syntax for Diamond.

*Please view the wiki for more information.*

*Coming soon: Diamond website*
