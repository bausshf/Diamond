# Note:
There's an issue with dub atm. going to fix it asap. It won't fetch versions properly for some reason.
I am not too familiar with dub, so I'm almost positive it's an issue at my end / done by my configurations.
It should be able to fetch master properly though.

# What is Diamond?
Diamond is a MVC / Template framework written in D, originally closed source for a private hobby project. It has now been rewamped to become a fully open-source project.

# What does Diamond depend on?
Diamond can be used stand-alone without depending on any third-party libraries, other than the standard library Phobos. It has 3 types of usage, websites and webservices, where it's used on-top of vibe.d and as a stand-alone mvc/template library.

# What is the dependency to vibe.d?
Diamond was originally written to be used in a hobby project as an alternative syntax to the "standard" diet templates. Thus it was originally build on-top vibe.d as a pure website template. It has now evolved to be able to run stand-alone however.

# What syntax does Diamond use?
Diamond is heavily inspired by the ASP.NET razor syntax, but still differs a lot from it.

# What advantages does Diamond have over Diet?
It let's you control the markup entirely, can be integrated with any-type of D code, not limited to vibe.d and can be used as  standard template library for any type of project such as email templates etc.

# How does Diamond work, does it parse the views on every request like eg. PHP?
No. Views are parsed once during compile-time and then compiled into D code that gets executed on run-time; keeping view generation to a minimum, while performance and speed is kept high.

# What are some main features of Diamond?
Rich and elegant template syntax, natively compiled, views are parsed at compile-time, cross-platform (Will be able to be used on every playform that can compile D -- in some cases vibe.d) and at last it let's you focus on writing the code you need, and not the code you need to get things working.

# Is it easy to use Diamond?
Diamond has been made in a way that it's very easy to use and integrate into projects. It also takes care of all background setup for vibe.d projects, letting you focus on just writing your websites / webservices logic, rather than a huge hassle of setup.

# Is there any syntax guide-lines?
View the wiki under "Comparison" as it compares the syntax with ASP.NET's razor syntax, as well shows the syntax for Diamond.

# Example (Error page that will be used on the Diamond site.)

	@[
	  layout:
		layout
	---
	  model:
		HTTPServerErrorInfo
	---
	  placeHolders:
		["title" : "Error - " ~ to!string(model.code)]
	]
	<div class="errors fadeIn">
	  <div class="errorBoxOuter">
		<div class="errorBoxInner">
		  <b>Message:</b> @=model.code;

		  @:if (model.message && model.message.length) {
			&nbsp;- @=model.message;
		  }
		</div>
	  </div>

	  @:if (model.code != 404 && model.code > 299 && model.exception) {
		<div class="errorBoxOuter spacing-top">
		  <div class="errorBoxInner">
			<b>Exception:</b> @=model.exception.toString()
			  .replace("\r", "")
			  .replace("\n", "<br>")
			  .replace(" at ", " at<br>")
			  .replace(" in ", " in<br>");
		  </div>
		</div>
	  }

	  <div class="errorBoxOuter spacing-top">
		<div class="errorBoxInner">
		  <b>Client-Address:</b> @=request.clientAddress;<br>
		  <b>Full-Url:</b> @=request.fullURL;<br>
		  <b>Host:</b> @=request.host;<br>
		  <b>Request-Time:</b> @=request.timeCreated;<br>
		  <b>Params:</b> @=request.params;<br>
		  <b>Query:</b> @=request.query;<br>
		  <b>Query-String:</b> @=request.queryString;<br>
		  <b>Form-Data:</b> @=request.form;<br>
		  <b>Json-Data:</b> @=request.json;<br>
		  <b>Content-Type:</b> @=request.contentType;<br>
		  <b>Method:</b> @=request.method;<br>
		  <b>Headers:</b> @=request.headers;
		</div>
	  </div>
	</div>


More coming soon ...
