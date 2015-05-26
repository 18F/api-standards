# Estándares para APIs

Este documento encapsula los estádares y prácticas de Mexico Abierto, basado en los estándares propuestos por [18F](https://github.com/18F/api-standards).

APIs, como cualquier otra aplicación web, varían en gran medida en implementación y diseño, dependiendo de la situciación y el problema que la aplicación resuelva.

Este documento provee una mezcla de:

* **Guía de diseño de alto nivel** que APIs individuales interpretan para cubrir sus necesidades.
* **Prácticas de bajo nivel** que la mayoría de APIs HTTP modenas utiizan.

### Diseña para casos de uso comunes

Para APIs que organizan información, se deben considerar casos de uso comunes:

* **Datos a granel.** Los clientes frecuentemente buscan establecer su propia copía de los conjuntos de datos del API en su totalidad. Por ejemplo, alguién podría intentar crear su propio buscador sobre el dataset, utilizando parametros y tecnologías distintas que los "oficiales" que el API soporta. Si el no puede actuar fácilmente como un proveedor de datos, provee un mecanismo separado para adquirir el conjunto de datos.
* **Manteniendose al día.** Especialmente para grandes conjuntos de datos, los clientes pueden buscar mantener sus conjuntos de datos actualiados sin requerir descargar el conjunto de datos después de cada actualización. Si este es un caso de uso para el API, prioriza en su diseño.
* **Manejando acciones costosas.** ¿Que pasaría si un cliente buscará enviar mensajes de texto a miles de personas automáticamente o intentará iluminar la pared lateral de un rascacielos cada vez que un nuevo conjunto de datos apareza? Considera si los records del API se encontrarán siempre en un orden confiable e inmutable, y sí tienden a aparecer en grupos o en un flujo estable. En términos generales, considera la "entropía" que un cliente del API experimentaría.

### Utiliza tu propia API

La mejor manera para entender y resolver las debilidades en el diseño e implementación de un API es utilizarla en un sistema en producción.

Cuando sea factible, diseña el API en paralelo con la integración de la misma.

### Punto de contacto

Crea un mecanismo obvio para clientes para reportasr problemas y realizar preguntas sobre el API.

Cuando utilices GitHub para el código de un API, utiliza el seguimiento de incidencias asociado. Adicionalmente, publica una dirección de correo electrónico para consultas privadas directas.

### Notificaciones sobre actualizaciones

Crea un mecanismo simple para que los clientes puedan consultar actualizaciones al API.

Medios comunes para esto pueden ser una lista de correo, o un [blog de desarrollo dedicado](https://developer.github.com/changes/) con un feed RSS.

### Puntos de acceso

Un punto de acceso es una combinación de dos cosas:

* El verbo (ej. `GET` o `POST`)
* La ruta URL ( ej. `/articles` )

Datos pueden ser enviados a un punto de acceso en una de dos maneras:

* Parámetros de consulta del URL (ej. `?year=2014`)
* Encabezados HTTP (ej. `X-Api-Key: my-key`)

Hoy en día cuando las personas dicen "tipo REST", realmente se refieren al diseño de puntos de acceso simples, intuitivos y que representan funciones específicas en el API.

En términos generales:


* **Evita puntos de acceso únicos.** No encapsules múltiples operaciones en el mismo punto de acceso con el mísmo verbo HTTP.
* **Prioriza la simplicidad.** Debería ser trivial deducir la acción que realiza un punto de acceso mediante la ruta y el verbo HTTP, sin necesidad de ver la cadena de consulta.
* Punto de acceso URL deben anunciar recursos, y **evitar verbos**.

Algunos ejemplos de estos principios en acción:

* [FBOpen API documentation](https://18f.github.io/fbopen/)
* [OpenFDA example query](http://open.fda.gov/api/reference/#example-query)
* [Sunlight Congress API methods](https://sunlightlabs.github.io/congress/#using-the-api)

### Utiliza JSON

[JSON](https://es.wikipedia.org/wiki/JSON) es un formato de transporte excelente y ampliamente soportado, adecuado para muchas APIs web.

Soportar JSON y solamente JSON es un caso por defecto practico para APIs, y generalmente reduce la complejidad tanto para el proveedor del API como para el consumidor de la misma.

Directrices generales JSON:

* Las respuestas deben ser **un objeto JSON** (no un arreglo). Utilizando un arreglo para emitir resultados límita la habilidad para incluir metadatos sobre los resultados, y límita la capacidad futura del API para añadir campos de nivel superior al documento JSON.
* **No utilices campos impredecibles**. Procesar una respuesta JSON donde los campos son impredecibles (ej. derivados de información) es díficil, y añade fricción para los clientes.
* **Utiliza nomenclatura de `guión_bajo` para campos**. Diferentes lenguajes utilizan nomenclatura diferente. JSON utiliza `guión_bajo`, no `camelCase`.

### Utiliza un formato de fechas consistente

Y específicamente, [utiliza ISO 8601](https://xkcd.com/1179/), en UTC.

Únicamente para fechas, eso sería algo como `2013-02-27`. Para fecha y hora, es de la forma `2013-02-27T10:00:00Z`.

Este formato de fechas es utilizado ampliamente en la web, y coloca cada campo en un orden consistente -- del menos específico al más específico.

### Llaves de API

Este estándar no toma una posición al respecto de utilizar o no llaves para el API.

Pero _si_ llaves son utilizadas para manejar y autenticar el acceso al API, la misma debería permitir algún tipo de acceso sin autenticación, sin utilizar llaves.

Esto permite a nuevos usuarios utilizar y experimentar con el API en ambientes demo y con solitictudes `curl`/`wget`/etc. simples.

Considera si una de las metas del producto es permitir un cierto nivel de uso del API en producción sin necesidad de registro por parte de los clientes.

### Manejo de errores

Maneja todos los errores (incluyendo excepciones no capturadas) y regresa una estructura de datos en el mismo formato que el resto del API.

Por ejemplo, una API JSON puede regresar la siguiente respuesta cuando una excepción no capturada ocurre:

```json
{
	"message": "Descripción del error.",
	"exception": "[stacktrace detallado]"
}
```

Respuestas HTTP con detalles de errores deben utilizar un código de estatus `4xx` para indicar una falla en el lado del cliente (como autorización inválida, o parámetros inválidos), y un código de estatus `5xx` para indicar una falla en el lado del servidor (una excepción no capturada).

### Paginación

Si para navegar los conjuntos de datos, paginación es requerida, utiliza el método que haga más sentido a los datos del API.

#### Parámetros

Patrones comunes:

* `page` y `per_page`. Intuitivo para muchos casos de usos. Enlaces a "página 2" pueden no contener siempre la misma información.
* `offset` y `limit`. Este estándar se deriva del mundo de las bases de datos SQL, y es una buena opción cuando enlaces permanentes a resultados son requeridos.
* `since` y `limit`. Obtener todo "desde" algún ID o marca de tiempo. Útil cuando es una prioridad permitir a los clientes mantenrse "sincronizados" de un modo efectivo con los datos. Generalmente requiere que el orden de los resultados sea muy estable.

#### Metadatos

Incluye suficientes metadatos de modo que los clientes puedan calcular que tantos más resultados existen, y como obtener el siguiente grupo de resultados.

Ejemplo de como puede ser implementado:

```json
{
	"results": [ ... conjuntos de datos ...],
	"pagination": {
		"count": 2340,
		"page": 4,
		"per_page": 20
	}
}
```
### Siempre utiliza HTTPS

Cualquier nueva API debe utilizar y requerir [encripción HTTPS](https://es.wikipedia.org/wiki/Hypertext_Transfer_Protocol_Secure) (utilizando TLS/SSL). HTTPS provee:

* **Seguridad**. El contenido de las peticiones están encriptidas a través de internet.
* **Autenticidad**. Una fuerte garantía de que los clientes se comunican con el API real.
* **Privacidad**. Privacidad aumentada para aplicaciones y usuarios que utilizan el API. Encabezados HTTP y los parámetros de consulta (entre otros) estarán encriptados.
* **Compatibilidad**. Compatibiladad del lado cliente más amplia. Para que peticiones CORS (Cross-Origin Request Sharing) al API funcionen en sitios con HTTPS -- para que no sean bloqueadas como contenido perdido -- esas peticiones deben ser enviadas sobre HTTPS.

HTTPS debe ser configurada utilizando prácticas estándares modenas, incluyendo cifrados que soporten [_forward secrecy_ (secreto-perfecto-hacía-adelante)](http://es.wikipedia.org/wiki/Perfect_forward_secrecy), y [Seguridad de Transporte HTTP Estricta](http://es.wikipedia.org/wiki/HTTP_Strict_Transport_Security). **Esto no es comprensivo**: utiliza herramientas como [_SSL Labs_](ssllabs.com/ssltest/analyze.html) para evaluar la configuración HTTPS del API.

Para una API existente que utiliza HTTP, el primer paso es añadir soporte HTTPS, y actualizar la documentación para declararlo como el método por defecto, usarlo en ejemplos, etc.

Después, evalúa la viabilidad de desactivar o redireccionar peticiones HTTP. Ver [GSA/api.data.gov#34](https://github.com/GSA/api.data.gov/issues/34) para una discusión de algunos conflictos involucrados con la transición de HTTP->HTTPS.

#### Indicación de Nombre de Servidor

De ser posible, utiliza [_Server Name Indication_ (Indicación de Nombre de Servidor)](http://es.wikipedia.org/wiki/Server_Name_Indication) (SNI) para servir peticiones HTTPS.

SNI es una extensión del protocolo TLS, [propuesto inicialmente en 2003](http://tools.ietf.org/html/rfc3546), esto permite certificados SSL para que múltiples dominios utilicen una misma dirección IP.

Utilizar una dirección IP para alberar múltiples dominios con HTTPS habilitado puede disminuir  significativamente costos y complejidad en la amdinistración y alojamiento del servidor. Esto es especialmente verdadero conforme direcciones IPv4 se vuelven escasas y costosas. SNI es una buena idea, y es ampliamente soportado.

Sin embargo, algunos clientes y redes siguen sin soportar propiamente SNI. Al momento de este escrito, eso incluye:

* Internet Explorer 8 e inferiores en Windows XP.
* Android 2.3 (Gingerbread) e inferiores.
* Todas las versiones de Pythons 2.x (una versión de Python 2.x con SNI [está planeada](http://legacy.python.org/dev/peps/pep-0466/)).
* Algunas redes coorporativas han sido configuradas en modos que deshabilitan o interfieren con soporte para SNI. Una red identificada donde este es el caso: la Casa Blanca.

Al implementar soporte SSL para un API, evalua si el soporte para SNI hace sentido para la audiencia que sirve.

### Utiliza UTF-8

Sólo [utiliza UTF-8](http://utf8everywhere.org).

Prepara el API para aceptar carácteres acentuados o "comillas tipográficas", aún cuando no sean esperados.

Un API debe informar a sus clientes de esperar UTF-8 incluyendo una notación de _charset_ en el encabezado `Content-Type` de las respuestas.

Un API que responde con JSON debería utilizar:

```
Content-Type: application/json; charset=utf-8
```

### CORS

Para que los clientes puedan utilizar el API desde navegadores web, el API debe habilitar [CORS](http://enable-cors.org).

Para el más simple y más común caso de uso, donde toda la API debe ser accesible desde un navegador, habilitar CORS es tan simple como incluir el siguiente encabezado en todas las respuestas:

```
Access-Control-Allow-Origin: *
```

Es soportado por [todos los navegadores modernos](http://enable-cors.org/client.html), y funcionará en la mayoría de clientes JavaScript, como [jQuery](https://jquery.com).

Para configuración más avanzada, vea la [especificación W3C](http://www.w3.org/TR/cors/) o la [guía de Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS).

**¿Qué hay de JSONP?**

JSONP [no es seguro o eficiente](https://gist.github.com/tmcw/6244497). Si se requiere soporte para IE8 o IE9, utiliza objetos [XDomainRequest](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx?Redirected=true) de Microsoft en lugar de JSONP. Existen [librerías](https://github.com/mapbox/corslite) para ayudar con esto.