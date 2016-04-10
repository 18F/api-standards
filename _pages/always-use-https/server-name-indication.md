---
title: "Server Name Indication"
---

If you can, use [Server Name Indication](http://en.wikipedia.org/wiki/Server_Name_Indication) (SNI) to serve HTTPS requests.

SNI is an extension to TLS, [first proposed in 2003](http://tools.ietf.org/html/rfc3546), that allows SSL certificates for multiple domains to be served from a single IP address.

Using one IP address to host multiple HTTPS-enabled domains can significantly lower costs and complexity in server hosting and administration. This is especially true as IPv4 addresses become more rare and costly. SNI is a Good Idea, and it is widely supported.

However, some clients and networks still do not properly support SNI. As of this writing, that includes:

* Internet Explorer 8 and below on Windows XP
* Android 2.3 (Gingerbread) and below.
* All versions of Python 2.x (a version of Python 2.x with SNI [is planned](http://legacy.python.org/dev/peps/pep-0466/)).
* Some enterprise network environments have been configured in some custom way that disables or interferes with SNI support. One identified network where this is the case: the White House.

When implementing SSL support for an API, evaluate whether SNI support makes sense for the audience it serves.
