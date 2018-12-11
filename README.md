# GSA API Standards

This document captures **GSA's recommended best practices, conventions, and standards for Application Programming Interfaces (APIs)**. Projects should start by implementing the [Mandatory Items](#mandatory-items) and [Mandatory For New APIs](#mandatory-for-new-apis). After addressing those, review [Other Considerations](#other-considerations) for additional advice.


# Index
[About These Standards](#about-these-standards)  
[Mandatory Items](#mandatory-items)  
[Mandatory For New APIs](#mandatory-for-new-apis)  
[Other Considerations](#other-considerations)  
[SOAP Web Services](#soap-web-services)  
[Future Topics](#future-topics)  


## About These Standards

These standards are forked from the [18F API Standards](https://github.com/18F/api-standards). They are also influenced by several other sources, including the [White House API Standards](https://github.com/WhiteHouse/api-standards) and best practices from the private sector.

### The standards are a roadmap not a roadblock

These standards are intended to streamline the process for GSA organizations to publish new APIs by providing practical and pragmatic advice. We believe these standards will benefit GSA API development and provide consistency. 


### They primarily focus on RESTful APIs
Most of the content in these standards relates to "RESTful" APIs. However, many of the standards are equally appropriate for other types of web service. 

A few specific recommendations are provided for [SOAP web services](#soap-web-services), and we encourage the GSA community to share more recommendations.

### They don't look under the covers
Because APIs may be developed with multiple technologies, these standards avoid details internal to the development of the application or unique to a development platform. They generally focus on the "externals" that will be exposed to users.

### For public and non-public APIs
These standards will be useful for both public and non-public APIs. However, initially the mandatory items will be mandatory only for the public APIs.

For the purposes of these standards, we use the following definitions:
  * **Non Public APIs** - Available only to GSA applications and users.
  * **Public APIs** - Available to non-GSA applications and users. Examples include the general public, other agencies, or private companies.


## Mandatory Items

These are mandatory for existing and new APIs.

### 1. Always Use HTTPS
All APIs should require and use [HTTPS encryption](https://en.wikipedia.org/wiki/HTTP_Secure) (using TLS/SSL). APIs should not allow HTTP connections.

### 2. Add Your API To The GSA API Directory
A directory of GSA public APIs is available at [open.gsa.gov/api](https://open.gsa.gov/api/). Add your API to this directory by posting an issue or pull request in the [GitHub repository](https://github.com/GSA/open-gsa-redesign). 

### 3. Use The api.data.gov Service

The [api.data.gov service](https://api.data.gov/about/) is an API management service for federal agencies. GSA APIs should use the `api.gsa.gov` base domain with this service.  By having the `api.gsa.gov` base URL as a proxy to developers, this also makes it easier to update and maintain the API in the future since you can update the underlying system and URLs without exposing it to the public.  In some cases, other specific base domains can be established with this service for GSA APIs.

#### Implementing With Your API
Initially, this service can be added as a new version of the URL, and then existing users can be transitioned to the new URL. For help setting this up, contact the api.data.gov team at <api.data.gov@gsa.gov>.

#### Additional Benefits
The api.gsa.gov service also provides:
* API key management
* rate limiting (throttling)
* gathering usage statistics (analytics)

Keys managed by api.data.gov can be re-used with other APIs hosted by this service, which reduces complexity for users. This service also allows the use of a DEMO_KEY for unauthenticated access, without keys, which reduces the "Time To First Hello World" for developers using your API.

### 4. Provide Support For Versioning
All APIs must support versioning. The recommended method of versioning REST APIs is to include a major version number in the URL path. For example "/v1/". An example of this method can be found at: https://gsa.github.io/sam_api/sam/versioning.html.

#### Major and Minor Versions
Major versions (e.g. v1, v2) should be reserved for breaking changes and major releases. Minor versions (eg. 1.1, 2.3) are not required, but can provide additional information about the API. If used, they should not be in the URL, but should be in the HTTP Headers. 

#### Breaking Changes (backwards-incompatible) 
Any changes made to a specific version of your API should not break your contract with existing users. If you need to make a change that will break that contract, create a new major version. 

Examples of Breaking Changes for REST APIs:
- Removing an HTTP method
- Removing or renaming a field in the request or response message
- Removing or renaming a query parameter
- Changing the URL or URL format

Examples of Breaking Changes for SOAP web services:
- Removing an operation
- Renaming an operation
- Changing the parameters (in data type or order) of an operation
- Changing the structure of a complex data type.

#### Non-Breaking Changes (backwards-compatible)
It is not necessary to increment the major API version for non-breaking changes. Non-breaking changes can be reflected in a minor version, if used.

Examples of Non-Breaking Changes for REST APIs:
- Adding an HTTP method
- Adding a field to a request message
- Adding a field to a response message
- Adding a value to an enum
- Adding a query parameter

Examples of Non-Breaking Changes for SOAP web services:
- Adding a new WSDL operation to an existing WSDL document.
- Adding a new XML schema type within a WSDL document that are not contained within previously existing types


#### Support for Previous Versions
Leave at least one previous major version intact. And communicate to existing users to understand when previous versions will be decommissioned.

#### Prototype or Alpha Versions
Use "/v0/" to represent an API that is in prototype or alpha phase and is likely to change frequently without warning.

### 5. Provide Public Documentation
The developer's entry point to your API will likely be the documentation that you provide. GSA has developed an [API Documentation Template](https://github.com/GSA/api-documentation-template) which can be re-used for your API. 

Your API documentation should provide:
* An overview of the contents of the API and the data sources.
* Public APIs should provide production URLs for accessing the API. (Non-public APIs would exclude this.)
* Required parameters and defaults.
* A description of the data that is returned.
* A description of the error codes that are returned, and their meaning.

Additional nice-to-haves include:
* Explanation of key management and a sample key.
* Description of update frequency.
* Interactive documentation to demonstrate sample calls.
* Sample client code for consuming the API in common languages.

### 6. Provide A Feedback Mechanism That Is Clear and Monitored

Have an obvious mechanism for clients to report issues and ask questions about the API. It is critical to respond to issues posted or queries submitted by developers. This demonstrates that the API can be counted on for production usage. If an immediate fix (or even a developer to investigate) is not readily available, respond anyway. Developers will be glad to know when you'll be able to take a look.

When using GitHub for an API's code or documentation, use the associated issue tracker. In addition, publish an email address for direct, non-public inquiries.

If you don't have a support channel specific to your API, you can use the issue tracker at [GSA-APIs](https://github.com/GSA/GSA-APIs/issues). Be sure your support team subscribes to issues there.

### 7. Provide An OpenAPI Specification File
The API documentation should provide a clear link to the [API's OpenAPI Specification file](https://github.com/OAI/OpenAPI-Specification). This specification was formerly known as the Swagger specification. This specification file can be used by development or testing tools accessing your API. 

Using Version 2.0 or later of the specification is recommended. Information about versions can be found here: [OpenAPI Specification Revision History](https://swagger.io/specification/#revisionHistory).

## Mandatory For New APIs

In addition to the mandatory items above, new APIs must also implement these.

### 8. Follow The Standard API Endpoint Design
An "endpoint" is a combination of two things:

* The verb (e.g. `GET` , `POST`, `PUT`, `PATCH`, `DELETE`)
* The URL path (e.g. `/articles`)

The URL path should follow this pattern for a collection of items:
`(base domain)/{business_function}/{application_name}/{major version}/{plural_noun}`

An example would be:
`https://api.gsa.gov/financial_management/sample_app/v1/vendors`

The URL path for an individual item in this collection would default to:
`(base domain)/{business_function}/{application_name}/{major version}/{plural_noun}/{identifier}`

An example would be:
`https://api.gsa.gov/financial_management/sample_app/v1/vendors/123`


## Other Considerations

### Design for common use cases

For APIs that syndicate data, consider several common client use cases:

* **Bulk data.** Clients often wish to establish their own copy of the API's dataset in its entirety. For example, someone might like to build their own search engine on top of the dataset, using different parameters and technology than the "official" API allows. If the API can't easily act as a bulk data provider, provide a separate mechanism for acquiring the backing dataset in bulk, such as posting the full dataset on [data.gov](https://www.data.gov/).
* **Staying up to date.** Especially for large datasets, clients may want to keep their dataset up to date without downloading the data set after every change. If this is a use case for the API, prioritize it in the design.
* **Driving expensive actions.** What would happen if a client wanted to automatically send text messages to thousands of people or light up the side of a skyscraper every time a new record appears? Consider whether the API's records will always be in a reliable unchanging order, and whether they tend to appear in clumps or in a steady stream. Generally speaking, consider the "entropy" an API client would experience.

### Using one's own API

The best way to understand and address the weaknesses in an API's design and implementation is to use it in a production system.

Whenever feasible, design an API in parallel with an accompanying integration of that API.

A few methods to accomplish this include:
* Identifying an internal GSA organization to use your API while also publishing it publicly.
* Creating a web page with a search feature that uses the API.
* Modifying existing web pages or web applications to use the API instead of direct access to the database.

### Developers Are Your End Users
Consider developers who will be using your APIs. Their path to using your API will include discovery and initial investigation, sample API calls, development and testing, deployment and production usage. Consider each of these functions in your documentation, support, and change notification process. Consider performing formal API Usability Testing to understand the developer experience in using your API. More information about this type of testing is available here: [API Usability Testing](https://pages.18f.gov/API-Usability-Testing/).

### Notifications of updates

Have a simple mechanism for clients to follow changes to the API.

Common ways to do this include a mailing list or a persistent issue in the GitHub repository that users can subscribe to. For example: [Notification Thread: Updates to GSA APIs](https://github.com/GSA/GSA-APIs/issues/46)

### Decommission unsupported APIs

If an API can no longer be supported, consider decommissioning the API and removing the documentation. If the API will remain available for historical purposes without support, update the documentation to reflect this.

### Use JSON

[JSON](https://en.wikipedia.org/wiki/JSON) is an excellent, widely supported transport format, suitable for many web APIs.

Supporting JSON and only JSON is a practical default for APIs, and generally reduces complexity for both the API provider and consumer.

General JSON guidelines:

* Responses should be **a JSON object** (not an array). Using an array to return results limits the ability to include metadata about results, and limits the API's ability to add additional top-level keys in the future. If multiple results are returned, they can be included as an Array in the JSON object.
* **Don't use unpredictable keys**. Parsing a JSON response where keys are unpredictable (e.g. derived from data) is difficult, and adds friction for clients.
* **Use consistent case for keys**. Whether you use `under_score` or `CamelCase` for your API keys, make sure you are consistent.

### Use a consistent date format

And specifically, [use ISO 8601](https://xkcd.com/1179/), in UTC.

For just dates, that looks like `2013-02-27`. For full times, that's of the form `2013-02-27T10:00:00Z`.

This date format is used all over the web, and puts each field in consistent order -- from least granular to most granular.

### Error handling

Handle all errors (including otherwise uncaught exceptions) and return a data structure in the same format as the rest of the API.

For example, a JSON API might provide the following when an uncaught exception occurs:

```json
{
  "message": "Description of the error.",
  "exception": "Description of the error"
}
```

HTTP responses with error details should use a `4XX` status code to indicate a client-side failure (such as invalid authorization, or an invalid parameter), and a `5XX` status code to indicate server-side failure (such as an uncaught exception).


### Pagination

If pagination is required to navigate datasets, use the method that makes the most sense for the API's data.

Common patterns:

* `page` and `per_page`. Intuitive for many use cases. Links to "page 2" may not always contain the same data.
* `offset` and `limit`. This standard comes from the SQL database world, and is a good option when you need stable permalinks to result sets.
* `since` and `limit`. Get everything "since" some ID or timestamp. Useful when it's a priority to let clients efficiently stay "in sync" with data. Generally requires result set order to be very stable.

### Metadata

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

### Use UTF-8

Just [use UTF-8](http://utf8everywhere.org).

Expect accented characters or "smart quotes" in API output, even if they're not expected.

An API should tell clients to expect UTF-8 by including a charset notation in the `Content-Type` header for responses.

An API that returns JSON should use:

```
Content-Type: application/json; charset=utf-8
```

### Enable CORS

For clients to be able to use an API from inside web browsers, the API must [enable CORS](http://enable-cors.org).

For the simplest and most common use case, where the entire API should be accessible from inside the browser, enabling CORS is as simple as including this HTTP header in all responses:

```
Access-Control-Allow-Origin: *
```

It's supported by [every modern browser](http://enable-cors.org/client.html), and will Just Work in many JavaScript clients.

For more advanced configuration, see the [W3C spec](http://www.w3.org/TR/cors/) or [Mozilla's guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS).

## SOAP Web Services
* Provide a WSDL. 

  Most platforms will provide this by default out of the box. Leave it active unless you have a strong reason not to. A useful convention is that the WSDL will be available at: {URL Path)?wsdl

* Provide documentation for SOAP web services.

  Users of SOAP web services need documentation, just like REST users. GSA has developed an [API Documentation Template](https://github.com/GSA/api-documentation-template) which can easily be re-used for your SOAP web service.

* See examples of versioning of SOAP web services above. 

## Future Topics
Several additional API related topics continue to emerge and will be considered for future updates to these standards.

That list includes:
* Microservices
* Hypermedia and HATEOAS
* Responsive APIs
* GraphQL

### What are we missing? 
If you see a future topic we need to consider, take a look at our [contributing page](https://github.com/GSA/api-standards/blob/master/CONTRIBUTING.md) for instructions to share that info.


## Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.

