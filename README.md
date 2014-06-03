# 18F API Standards

This document captures 18F's view of API best practices and standards. We aim to incorporate as many of them as possible in our work.

APIs, like other web applications, will vary greatly in implementation and design, depending on the situation and the goal the application is solving.

This document is meant to provide a mix of:

* High level design guidance, that individual APIs will interpret to meet their needs.
* Low level web practices, that just about every modern HTTP API should use.

### Design for common use cases

For APIs that syndicate data, consider several common client use cases:

* **Bulk data.** Clients often wish to establish their own copy of the API's dataset in its entirety. For example, someone might like to build their own search engine on top of the dataset, using different parameters and technology than the "official" API allows. If the API can't easily act as a bulk data provider, provide a separate mechanism for acquiring the backing dataset in bulk.
* **Staying up to date.** Especially for large datasets, clients may want to keep "in sync" with a dataset without having to re-download everything. If this is a use case for the API, prioritize this in the design.
* **Driving expensive actions.** (AKA: the [IFTTT](https://ifttt.com) test.) Consider what would happen if someone wanted to fire off automatic text messages to thousands of people, or light up the side of a skyscraper, every time a new record appears. Will the API's records always be in a reliable, unchanging order? Do records tend to appear in clumps, or in a steady stream? Generally speaking, consider the "entropy" an API client would experience.

### Using one's own API

The #1 best way to understand and address the weaknesses in an API's design and implementation is to use it in a production system.

Whenever feasible, design an API in parallel with an accompanying integration of that API.

### API Endpoints

An "endpoint" is a combination of two things:

* The verb (e.g. `GET` or `POST`)
* The URL path (e.g. `/posts`)

Information can be passed to an endpoint in either of two ways:

* The URL query string (e.g. `?year=2014`)
* HTTP headers (e.g. `X-Api-Key: my-key`)

When people say "RESTful" nowadays, they really mean designing simple, intuitive endpoints that represent unique functions in the API.

Generally speaking:

* **Avoid single-endpoint APIs.** Don't jam multiple operations into the same endpoint with the same HTTP verb.
* **Prioritize simplicity.** It should be easy to guess what an endpoint does by looking at the URL and HTTP verb, without needing to see a query string.
* Endpoint URLs should advertise resources, and **avoid verbs**.

Some examples of these principles in action:

* [FBOpen API documentation](http://docs.fbopen.apiary.io)
* [OpenFDA example query](http://open.fda.gov/api/reference/#example-query)
* [Sunlight Congress API methods](https://sunlightlabs.github.io/congress/#using-the-api)

### Just use JSON

[JSON](https://en.wikipedia.org/wiki/JSON) is an excellent, extremely widely supported transport format, suitable for many web APIs.

Supporting JSON and only JSON is a practical default for APIs, and generally reduces complexity both for the API provider and consumer.

General JSON guidelines:

* Responses should be **a JSON object** (not an array). Using an array to return results limits the ability to include metadata about results, and limits the API's ability to add additional top-level keys in the future.
* **Don't use unpredictable keys**. Parsing a JSON response where keys are unpredictable (e.g. derived from data) is difficult, and adds friction for clients.
* **Use `under_score` case for keys**. Different languages use different case conventions. JSON uses `under_score`, not `camelCase`.

### Error handling

Handle all errors (including otherwise uncaught exceptions) and return a data structure in the same format as the rest of the API.

For example, a JSON API might provide the following when an uncaught exception occurs:

```json
{
  "status" : 500,
  "message": "Description of the error.",
  "exception": "[detailed stacktrace]"
}
```

HTTP responses with error details should use a `4XX` status code to indicate a client-side failure (such as invalid authorization, or an invalid parameter), and a `5XX` status code to indicate server-side failure (such as an uncaught exception).


### Versioning

[TBD pending discussion in [#5](https://github.com/18F/api-standards/issues/5)].


### Pagination

If pagination is required to navigate datasets, use the method that makes the most sense for the API's data.

Common patterns:

* `page` and `per_page`. Intuitive for many use cases. Links to "page 2" may not always contain the same data.
* `offset` and `limit`. Less intuitive, but possibly useful if they produce stable permalinks to result sets, and if that's a priority.
* `since` and `limit`. Get everything "since" some ID or timestamp. Useful when letting clients efficiently stay "in sync" with data is a priority. Generally requires resultset order to be very stable.

In paginated responses, include enough metadata so that clients can calculate how many pages of data there are, and how and whether to fetch the next page.

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

### Always use SSL/HTTPS

Any new API should use and require encryption (SSL). SSL provides:

* **Security**. The contents of the request are encrypted across the Internet.
* **Authenticity**. A stronger guarantee that a client is communicating with the real API.
* **Privacy**. Enhanced privacy for apps and users using the API. HTTP headers and query string parameters (among other things) will be encrypted.
* **Compatibility**. Broader client-side compatibility. For CORS requests to the API to work on HTTPS websites -- to not be blocked as mixed content -- those requests must be over HTTPS.

SSL should be configured using modern best practices, including ciphers that support [forward secrecy](http://en.wikipedia.org/wiki/Forward_secrecy), and [HTTP Strict Transport Security](http://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security). **This is not exhaustive**: use tools like [SSL Labs](ssllabs.com/ssltest/analyze.html) to evaluate an API's SSL configuration.

For an existing API that runs over plain HTTP, the first step is to add SSL support, and update the documentation to declare it the default, use it in examples, etc.

Then, evaluate the viability of disabling or redirecting plain HTTP requests. See [GSA/api.data.gov#34](https://github.com/GSA/api.data.gov/issues/34) for a discussion of some of the issues involved with transitioning from HTTP->HTTPS.

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

For the simplest and most common use case, where the entire API should be accessible from inside the browser, enablign CORS is as simple as including this HTTP header in all responses:

```
Access-Control-Allow-Origin: *
```

It's supported by [every modern browser](http://enable-cors.org/client.html), and will Just Work in many JavaScript clients, like [jQuery](https://jquery.com).

**What about JSONP?**

JSONP is [not secure or performant](https://gist.github.com/tmcw/6244497). If IE8 or UE9 must be supported, use Microsoft's [XDomainRequest](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx?Redirected=true) object instead of JSONP. There are [libraries](https://github.com/mapbox/corslite) to help with this.
