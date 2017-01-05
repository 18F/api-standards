<span style="color:red"> **WORKING DRAFT - These documents are a working draft and are not official GSA Policy** </span>

# GSA API Standards

This document captures **GSA's recommended best practices and standards for Application Programming Interfaces (APIs)**. We encourage GSA development groups to used these standards when developing APIs.

## About These Standards

These standards are forked from the [18F API Standards](https://github.com/18F/api-standards). They are also influenced by several other sources, including the [White House API Standards](https://github.com/WhiteHouse/api-standards), [API Evangelist](https://apievangelist.com), and [Spencer Schneidenbach](https://medium.com/@schneidenbach/restful-api-best-practices-and-common-pitfalls-7a83ba3763b5#.5acs6a8tj).

### The Standards are a roadmap not a roadblock

This document is intended to streamline the process for GSA organizations to publish new APIs by providing practical and pragmatic advice. It is not intended to make this process more difficult.


### They default to RESTful
These standards assume the APIs will be generally "RESTful". However, many of the standards are equally appropriate for other types of web service. Specific recommendations are provided for SOAP web services.

### They don't look under the covers
Because APIs may be developed with multiple technologies, these standards avoid details internal to the development of the application or unique to a development platform. They focus on the "externals" such as user experience and interfaces.

## Overall Considerations

### Design for common use cases

For APIs that syndicate data, consider several common client use cases:

* **Bulk data.** Clients often wish to establish their own copy of the API's dataset in its entirety. For example, someone might like to build their own search engine on top of the dataset, using different parameters and technology than the "official" API allows. If the API can't easily act as a bulk data provider, provide a separate mechanism for acquiring the backing dataset in bulk, such as posting the full dataset on [data.gov](https://www.data.gov/).
* **Staying up to date.** Especially for large datasets, clients may want to keep their dataset up to date without downloading the data set after every change. If this is a use case for the API, prioritize it in the design.
* **Driving expensive actions.** What would happen if a client wanted to automatically send text messages to thousands of people or light up the side of a skyscraper every time a new record appears? Consider whether the API's records will always be in a reliable unchanging order, and whether they tend to appear in clumps or in a steady stream. Generally speaking, consider the "entropy" an API client would experience.

### Using one's own API

The #1 best way to understand and address the weaknesses in an API's design and implementation is to use it in a production system.

Whenever feasible, design an API in parallel with an accompanying integration of that API.

A few methods to accomplish this include:
* Identifying an internal GSA organization to use your API while also publishing it publicly.
* Creating a web page with a search feature that uses the API.
* Modifying existing web pages or web applications to use the API instead of direct access to the database.

## Developers Are Your End Users
Consider developers who will be using your APIs. Their path to using your API will include discovery and inital investigation, sample API calls, development and testing, deployment and production usage. Consider each of these functions in your documentation, support, and change notification process. Consider performing formal [API Usability Testing](### Default to REST
These standards assuming the APIs will be generally "Restful". However, recommendations are also provided for SOAP web services.
) to understand the developer experience in using your API.

### Add Your API To The GSA API Directory
A directory of GSA public APIs is available at [open.gsa.gov/developer](open.gsa.gov/developer/). You can add your API to this directory by posting an issue or pull request in the [GitHub repository](https://github.com/GSA/open.gsa.gov).

### Provide Documentation
The developer's entry point to your API will likely be the documentation that you provide. GSA has developed an [API Documentation Template](https://github.com/GSA/api-documentation-template) which can easily be re-used for your API.

At a minimum, API documentation should provide:
* An overview of the contents of the API and the data sources.
* Production URLs for accessing the API.
* Required parameters and defaults.
* A description of the data that is returned.
* A description of the error codes that are returned, and their meaning.

Additional nice-to-haves include:
* Explanation of key management and a sample key.
* Description of update frequency.
* Interactive documentation to demonstrate sample calls.
* Sample client code for consuming the API in common languages.

### Point of contact

Have an obvious mechanism for clients to report issues and ask questions about the API.

When using GitHub for an API's code, use the associated issue tracker. In addition, publish an email address for direct, non-public inquiries.

### Avoid an API "Ghost Town" by responding to issues and questions
Developers can immediately sniff out a stale and unsupported API by old issues never answered and contact emails that no longer work.

It is critical to respond to issues posted or queries submitted by developers. This demonstrates that the API can be counted on for production usage. If an immediate fix (or even a developer to investigate) is not readily available, respond anyway. Developers will be glad to know when you'll be able to take a look.

### Notifications of updates

Have a simple mechanism for clients to follow changes to the API.

Common ways to do this include a mailing list, or a [dedicated developer blog](https://developer.github.com/changes/) with an RSS feed.

### Decommission Unsupported APIs

If an API can no longer be supported, consider decommissioning the API and removing the documentation. If the API will remain available for historical purposes without support, update the documentation to reflect this.

### Avoid Breaking Changes

*TodDo: flesh this out*

## Design considerations

### API Endpoints
*Todo: give specific recommendations on URL*

An "endpoint" is a combination of two things:

* The verb (e.g. `GET` or `POST`)
* The URL path (e.g. `/articles`)

Information can be passed to an endpoint in either of two ways:

* The URL query string (e.g. `?year=2014`)
* HTTP headers (e.g. `X-Api-Key: my-key`)

When people say "RESTful" nowadays, they really mean designing simple, intuitive endpoints that represent unique functions in the API.

Generally speaking:

* **Avoid single-endpoint APIs.** Don't jam multiple operations into the same endpoint with the same HTTP verb.
* **Prioritize simplicity.** It should be easy to guess what an endpoint does by looking at the URL and HTTP verb, without needing to see a query string.
* Endpoint URLs should advertise resources, and **avoid verbs**.

Some examples of these principles in action:

* [FBOpen API documentation](https://18f.github.io/fbopen/)
* [OpenFDA example query](https://open.fda.gov/api/reference/#example-query)
* [Sunlight Congress API methods](https://sunlightlabs.github.io/congress/#using-the-api)

### Taxonomy 
If the API is intended to share data across the GSA enteprise or beyond, consider referencing the GSA Taxonomy. Contact GSA's Chief Data Officer for more information.

### Versioning
The recommended method of versioning APIs is to include a version number in the URL path. For example "/v1". 

### Use JSON

[JSON](https://en.wikipedia.org/wiki/JSON) is an excellent, widely supported transport format, suitable for many web APIs.

Supporting JSON and only JSON is a practical default for APIs, and generally reduces complexity for both the API provider and consumer.

General JSON guidelines:

* Responses should be **a JSON object** (not an array). Using an array to return results limits the ability to include metadata about results, and limits the API's ability to add additional top-level keys in the future.
* **Don't use unpredictable keys**. Parsing a JSON response where keys are unpredictable (e.g. derived from data) is difficult, and adds friction for clients.
* **Use consistent case for keys**. Whether you use `under_score` or `CamelCase` for your API keys, make sure you are consistent.

### Use a consistent date format

And specifically, [use ISO 8601](https://xkcd.com/1179/), in UTC.

For just dates, that looks like `2013-02-27`. For full times, that's of the form `2013-02-27T10:00:00Z`.

This date format is used all over the web, and puts each field in consistent order -- from least granular to most granular.


### API Keys

These standards do not take a position on whether or not to use API keys.

But _if_ keys are used to manage and authenticate API access, the API should allow some sort of unauthenticated access, without keys.

This allows newcomers to use and experiment with the API in demo environments and with simple `curl`/`wget`/etc. requests.

Consider whether one of your product goals is to allow a certain level of normal production use of the API without enforcing advanced registration by clients.

*TODO: recommend api.data.gov with GSA specific intructions*


### Error handling

Handle all errors (including otherwise uncaught exceptions) and return a data structure in the same format as the rest of the API.

For example, a JSON API might provide the following when an uncaught exception occurs:

```json
{
  "message": "Description of the error.",
  "exception": "[detailed stacktrace]"
}
```

HTTP responses with error details should use a `4XX` status code to indicate a client-side failure (such as invalid authorization, or an invalid parameter), and a `5XX` status code to indicate server-side failure (such as an uncaught exception).


### Pagination

If pagination is required to navigate datasets, use the method that makes the most sense for the API's data.

#### Parameters

Common patterns:

* `page` and `per_page`. Intuitive for many use cases. Links to "page 2" may not always contain the same data.
* `offset` and `limit`. This standard comes from the SQL database world, and is a good option when you need stable permalinks to result sets.
* `since` and `limit`. Get everything "since" some ID or timestamp. Useful when it's a priority to let clients efficiently stay "in sync" with data. Generally requires result set order to be very stable.

#### Metadata

Include enough metadata so that clients can calculate how much data there is, and how and whether to fetch the next set of results.

Example of how that might be implemented:

```json
{
  "results": [ ... actual results ... ],
  "pagination": {
    "count": 2340,
    "page": 4,
    "per_page": 20
  }
}
```

### Always use HTTPS

Any new API should use and require [HTTPS encryption](https://en.wikipedia.org/wiki/HTTP_Secure) (using TLS/SSL). HTTPS provides:

* **Security**. The contents of the request are encrypted across the Internet.
* **Authenticity**. A stronger guarantee that a client is communicating with the real API.
* **Privacy**. Enhanced privacy for apps and users using the API. HTTP headers and query string parameters (among other things) will be encrypted.
* **Compatibility**. Broader client-side compatibility. For CORS requests to the API to work on HTTPS websites -- to not be blocked as mixed content -- those requests must be over HTTPS.

HTTPS should be configured using modern best practices, including ciphers that support [forward secrecy](https://en.wikipedia.org/wiki/Forward_secrecy), and [HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security). **This is not exhaustive**: use tools like [SSL Labs](https://www.ssllabs.com/ssltest/analyze.html) to evaluate an API's HTTPS configuration.

For an existing API that runs over plain HTTP, the first step is to add HTTPS support, and update the documentation to declare it the default, use it in examples, etc.

Then, evaluate the viability of disabling or redirecting plain HTTP requests. See [GSA/api.data.gov#34](https://github.com/18F/api.data.gov/issues/34) for a discussion of some of the issues involved with transitioning from HTTP->HTTPS.

#### Server Name Indication

If you can, use [Server Name Indication](https://en.wikipedia.org/wiki/Server_Name_Indication) (SNI) to serve HTTPS requests.

SNI is an extension to TLS, [first proposed in 2003](http://tools.ietf.org/html/rfc3546), that allows SSL certificates for multiple domains to be served from a single IP address.

Using one IP address to host multiple HTTPS-enabled domains can significantly lower costs and complexity in server hosting and administration. This is especially true as IPv4 addresses become more rare and costly. SNI is a Good Idea, and it is widely supported.

However, some clients and networks still do not properly support SNI. As of this writing, that includes:

* Internet Explorer 8 and below on Windows XP
* Android 2.3 (Gingerbread) and below.
* All versions of Python 2.x (a version of Python 2.x with SNI [is planned](http://legacy.python.org/dev/peps/pep-0466/)).
* Some enterprise network environments have been configured in some custom way that disables or interferes with SNI support. One identified network where this is the case: the White House.

When implementing SSL support for an API, evaluate whether SNI support makes sense for the audience it serves.

### Use UTF-8

Just [use UTF-8](http://utf8everywhere.org).

Expect accented characters or "smart quotes" in API output, even if they're not expected.

An API should tell clients to expect UTF-8 by including a charset notation in the `Content-Type` header for responses.

An API that returns JSON should use:

```
Content-Type: application/json; charset=utf-8
```

### CORS

For clients to be able to use an API from inside web browsers, the API must [enable CORS](http://enable-cors.org).

For the simplest and most common use case, where the entire API should be accessible from inside the browser, enabling CORS is as simple as including this HTTP header in all responses:

```
Access-Control-Allow-Origin: *
```

It's supported by [every modern browser](http://enable-cors.org/client.html), and will Just Work in many JavaScript clients, like [jQuery](https://jquery.com).

For more advanced configuration, see the [W3C spec](http://www.w3.org/TR/cors/) or [Mozilla's guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS).

**What about JSONP?**

JSONP is [not secure or performant](https://gist.github.com/tmcw/6244497). If IE8 or IE9 must be supported, use Microsoft's [XDomainRequest](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx?Redirected=true) object instead of JSONP. There are [libraries](https://github.com/mapbox/corslite) to help with this.

###SOAP Web Services
*Todo: best practices for SOAP web services*

##Future Topics
Several additional API related topics continue to emerge and will be considered for future API standards.

That list includes:
* Microservices
* Hypermedia and HATEOAS


## Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.

