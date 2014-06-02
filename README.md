# 18F API Standards

This document captures 18F's view of API best practices and standards. We aim to incorporate as many of them as possible in our work.

APIs, like other web applications, will vary greatly in implementation and design, depending on the situation and the goal the application is solving.

This document is meant to provide a mix of:

* High level design guidance, that individual APIs will interpret to meet their needs.
* Low level web practices, that just about every modern HTTP API should use.


### API Endpoints

An "endpoint" is a combination of two things:

* The verb (e.g. `GET` or `POST`)
* The URL path (e.g. `/posts`)

And you can pass information to an endpoint in either of two ways:

* The URL query string (e.g. `?year=2014`)
* HTTP headers (e.g. `X-Api-Key: my-key`)

When people say "RESTful" nowadays, they really mean designing simple, intuitive endpoints that represent unique functions in the API.

Generally speaking:

* **Avoid single-endpoint APIs.** Don't jam multiple operations into the same endpoint with the same HTTP verb.
* **Prioritize simplicity.** It should be easy to guess what an endpoint does by looking at the URL and HTTP verb, without needing to see a query string.
* Endpoint URLs should advertise resources, and **avoid verbs**.

Some examples of these principles in action:

* [OpenFDA example query](http://open.fda.gov/api/reference/#example-query)
* [Sunlight Congress API methods](https://sunlightlabs.github.io/congress/#using-the-api)
* [FBOpen API documentation](http://docs.fbopen.apiary.io/)

## Responses

When using

* No values in keys
* No internal-specific names (e.g. "node" and "taxonomy term")
* Metadata should only contain direct properties of the response set, not properties of the members of the response set

### Good examples

No values in keys:

    "tags": [
      {"id": "125", "name": "Environment"},
      {"id": "834", "name": "Water Quality"}
    ],


### Bad examples

Values in keys:

    "tags": [
      {"125": "Environment"},
      {"834": "Water Quality"}
    ],


## Error handling

Error responses should include a common HTTP status code, message for the developer, message for the end-user (when appropriate), internal error code (corresponding to some specific internally determined ID), links where developers can find more info. For example:

    {
      "status" : 400,
      "developerMessage" : "Verbose, plain language description of the problem. Provide developers
       suggestions about how to solve their problems here",
      "userMessage" : "This is a message that can be passed along to end-users, if needed.",
      "errorCode" : "444444",
      "moreInfo" : "http://example.gov/developer/path/to/help/for/444444,
       http://drupal.org/node/444444",
    }

Use three simple, common response codes indicating (1) success, (2) failure due to client-side problem, (3) failure due to server-side problem:
* 200 - OK
* 400 - Bad Request
* 500 - Internal Server Error


## Versions

* Never release an API without a version number.
* Versions should be integers, not decimal numbers, prefixed with ‘v’. For example:
    * Good: v1, v2, v3
    * Bad: v-1.1, v1.2, 1.3
* Maintain APIs at least one version back.


## Record limits

* If no limit is specified, return results with a default limit.
* To get records 51 through 75 do this:
    * http://example.gov/magazines?limit=25&offset=50
    * offset=50 means, ‘skip the first 50 records’
    * limit=25 means, ‘return a maximum of 25 records’

Information about record limits and total available count should also be included in the response. Example:

    {
        "metadata": {
            "resultset": {
                "count": 227,
                "offset": 25,
                "limit": 25
            }
        },
        "results": []
    }

## Request & Response Examples

### API Resources

  - [GET /magazines](#get-magazines)
  - [GET /magazines/[id]](#get-magazinesid)
  - [POST /magazines/[id]/articles](#post-magazinesidarticles)

### GET /magazines

Example: http://example.gov/api/v1/magazines.json

Response body:

    {
        "metadata": {
            "resultset": {
                "count": 123,
                "offset": 0,
                "limit": 10
            }
        },
        "results": [
            {
                "id": "1234",
                "type": "magazine",
                "title": "Public Water Systems",
                "tags": [
                    {"id": "125", "name": "Environment"},
                    {"id": "834", "name": "Water Quality"}
                ],
                "created": "1231621302"
            },
            {
                "id": 2351,
                "type": "magazine",
                "title": "Public Schools",
                "tags": [
                    {"id": "125", "name": "Elementary"},
                    {"id": "834", "name": "Charter Schools"}
                ],
                "created": "126251302"
            }
            {
                "id": 2351,
                "type": "magazine",
                "title": "Public Schools",
                "tags": [
                    {"id": "125", "name": "Pre-school"},
                ],
                "created": "126251302"
            }
        ]
    }

### GET /magazines/[id]

Example: http://example.gov/api/v1/magazines/[id].json

Response body:

    {
        "id": "1234",
        "type": "magazine",
        "title": "Public Water Systems",
        "tags": [
            {"id": "125", "name": "Environment"},
            {"id": "834", "name": "Water Quality"}
        ],
        "created": "1231621302"
    }



### POST /magazines/[id]/articles

Example: Create – POST  http://example.gov/api/v1/magazines/[id]/articles

Request body:

    [
        {
            "title": "Raising Revenue",
            "author_first_name": "Jane",
            "author_last_name": "Smith",
            "author_email": "jane.smith@example.gov",
            "year": "2012",
            "month": "August",
            "day": "18",
            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ante ut augue scelerisque ornare. Aliquam tempus rhoncus quam vel luctus. Sed scelerisque fermentum fringilla. Suspendisse tincidunt nisl a metus feugiat vitae vestibulum enim vulputate. Quisque vehicula dictum elit, vitae cursus libero auctor sed. Vestibulum fermentum elementum nunc. Proin aliquam erat in turpis vehicula sit amet tristique lorem blandit. Nam augue est, bibendum et ultrices non, interdum in est. Quisque gravida orci lobortis... "
        }
    ]


## Always use SSL/HTTPS

Any new API should use and require encryption (SSL).

* **Security**: The contents of the request are encrypted across the Internet.
* **Authenticity**: A stronger guarantee that you're communicating with the real API.
* **Privacy**: Enhanced privacy for apps and users using the API. HTTP headers and query string parameters (among other things) will be encrypted.
* **Compatibility**: Broader client-side compatibility. For CORS requests to the API to work on HTTPS websites -- to not be blocked as mixed content -- those requests must be over HTTPS.

SSL should be configured using modern best practices, including ciphers that syupport [forward secrecy](http://en.wikipedia.org/wiki/Forward_secrecy), and [HTTP Strict Transport Security](http://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security). **This is not exhaustive**: use [SSL Labs](ssllabs.com/ssltest/analyze.html) to evaluate an API's SSL configuration.

For an existing API that runs over plain HTTP, the first step is to add SSL support, and update the documentation to declare it the default, use it in examples, etc.

Then, evaluate the viability of disabling or redirecting plain HTTP requests. See [GSA/api.data.gov#34](https://github.com/GSA/api.data.gov/issues/34) for a discussion of some of the issues involved with transitioning from HTTP->HTTPS.

## CORS

For clients to be able to use your API from inside web browsers, the API must [enable CORS](http://enable-cors.org/).

For the simplest and most common use case, where the entire API should be accessible from inside the browser, enablign CORS is as simple as including this HTTP header in all responses:

```
Access-Control-Allow-Origin: *
```

It's supported by [every modern browser](http://enable-cors.org/client.html), and will Just Work in many JavaScript clients, like [jQuery](https://jquery.com/).

**What about JSONP?**

JSONP is [not secure or performant](https://gist.github.com/tmcw/6244497). If you must support IE8 or IE9, use Microsoft's [XDomainRequest](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx?Redirected=true) object instead of JSONP. There are [libraries](https://github.com/mapbox/corslite) to help with this.
