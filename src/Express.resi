@ocaml.doc(
  "abstract type which ensure middleware function must either
     call the [next] function or one of the [send] function on the
     response object.

     This should be a great argument for OCaml, the type system
     prevents silly error which in this case would make the server hang"
)
type complete

module Error: {
  @ocaml.doc("Error type")
  type t = exn

  @bs.send @bs.return(null_undefined_to_opt)
  external message: Js_exn.t => option<string> = "message"
  @bs.send @bs.return(null_undefined_to_opt)
  external name: Js_exn.t => option<string> = "name"
}

module Request: {
  type t
  type params = Js.Dict.t<Js.Json.t>

  @ocaml.doc("[params request] return the JSON object filled with the
       request parameters")
  @bs.get
  external params: t => params = "params"

  @ocaml.doc(
    "[asJsonObject request] casts a [request] to a JSON object. It is
       common in Express application to use the Request object as a
       placeholder to maintain state through the various middleware which
       are executed."
  )
  external asJsonObject: t => Js.Dict.t<Js.Json.t> = "%identity"

  @ocaml.doc("[baseUrl request] returns the 'baseUrl' property") @bs.get
  external baseUrl: t => string = "baseUrl"

  @ocaml.doc(
    "When using the json body-parser middleware and receiving a request with a
       content type of \"application/json\", this property is a Js.Json.t that
       contains the body sent by the request."
  )
  @bs.get
  @bs.return(null_undefined_to_opt)
  external bodyJSON: t => option<Js.Json.t> = "body"

  @ocaml.doc(
    "When using the raw body-parser middleware and receiving a request with a
       content type of \"application/octet-stream\", this property is a
       Node_buffer.t that contains the body sent by the request."
  )
  @bs.get
  @bs.return(null_undefined_to_opt)
  external bodyRaw: t => option<Node_buffer.t> = "body"

  @ocaml.doc(
    "When using the text body-parser middleware and receiving a request with a
       content type of \"text/plain\", this property is a string that
       contains the body sent by the request."
  )
  let bodyText: t => option<string>

  @ocaml.doc(
    "When using the urlencoded body-parser middleware and receiving a request
       with a content type of \"application/x-www-form-urlencoded\", this property
        is a Js.Dict.t string that contains the body sent by the request."
  )
  let bodyURLEncoded: t => option<Js.Dict.t<string>>

  @ocaml.doc(
    "When using cookie-parser middleware, this property is an object
       that contains cookies sent by the request. If the request contains
       no cookies, it defaults to {}."
  )
  @bs.get
  @bs.return(null_undefined_to_opt)
  external cookies: t => option<Js.Dict.t<Js.Json.t>> = "cookies"

  @ocaml.doc(
    "When using cookie-parser middleware, this property contains signed cookies
       sent by the request, unsigned and ready for use. Signed cookies reside in
       a different object to show developer intent; otherwise, a malicious attack
       could be placed on req.cookie values (which are easy to spoof).
       Note that signing a cookie does not make it “hidden” or encrypted;
       but simply prevents tampering (because the secret used to
       sign is private)."
  )
  @bs.get
  @bs.return(null_undefined_to_opt)
  external signedCookies: t => option<Js.Dict.t<Js.Json.t>> = "signedCookies"

  @ocaml.doc("[hostname request] Contains the hostname derived from the Host HTTP header.") @bs.get
  external hostname: t => string = "hostname"

  @ocaml.doc("[ip request] Contains the remote IP address of the request.") @bs.get
  external ip: t => string = "ip"

  @ocaml.doc("[fresh request] returns [true] whether the request is \"fresh\"") @bs.get
  external fresh: t => bool = "fresh"

  @ocaml.doc("[stale request] returns [true] whether the request is \"stale\"") @bs.get
  external stale: t => bool = "stale"

  @ocaml.doc(
    "[method_ request] return a string corresponding to the HTTP
       method of the request: GET, POST, PUT, and so on"
  )
  @bs.get
  external methodRaw: t => string = "method"
  type httpMethod =
    | Get
    | Post
    | Put
    | Delete
    | Head
    | Options
    | Trace
    | Connect
    | Patch

  @ocaml.doc(
    "[method_ request] return a variant corresponding to the HTTP
       method of the request: Get, Post, Put, and so on"
  )
  let httpMethod: t => httpMethod

  @ocaml.doc(
    "[originalUrl request] returns the original url. See
       https://expressjs.com/en/4x/api.html#req.originalUrl"
  )
  @bs.get
  external originalUrl: t => string = "originalUrl"

  @ocaml.doc("[path request] returns the path part of the request URL.") @bs.get
  external path: t => string = "path"
  type protocol =
    | Http
    | Https

  @ocaml.doc(
    "[protocol request] returns the request protocol string: either http
       or (for TLS requests) https."
  )
  let protocol: t => protocol

  @ocaml.doc("[secure request] returns [true] if a TLS connection is established") @bs.get
  external secure: t => bool = "secure"

  @ocaml.doc(
    "[query request] returns an object containing a property for each
       query string parameter in the route. If there is no query string,
       it returns the empty object, {}"
  )
  @bs.get
  external query: t => Js.Dict.t<Js.Json.t> = "query"

  @ocaml.doc(
    "[acceptsRaw accepts types] checks if the specified content types
       are acceptable, based on the request's Accept HTTP header field.
       The method returns the best match, or if none of the specified
       content types is acceptable, returns [false]"
  )
  let accepts: (t, array<string>) => option<string>
  let acceptsCharsets: (t, array<string>) => option<string>

  @ocaml.doc(
    "[get return field] returns the specified HTTP request header
       field (case-insensitive match)"
  )
  @bs.send
  @bs.return(null_undefined_to_opt)
  external get: (t, string) => option<string> = "get"

  @ocaml.doc(
    "[xhr request] returns [true] if the request’s X-Requested-With
       header field is \"XMLHttpRequest\", indicating that the request was
       issued by a client library such as jQuery"
  )
  @bs.get
  external xhr: t => bool = "xhr"
}

module Response: {
  type t
  module StatusCode: {
    @bs.deriving(jsConverter)
    type t =
      | Ok
      | Created
      | Accepted
      | NonAuthoritativeInformation
      | NoContent
      | ResetContent
      | PartialContent
      | MultiStatus
      | AleadyReported
      | IMUsed
      | MultipleChoices
      | MovedPermanently
      | Found
      | SeeOther
      | NotModified
      | UseProxy
      | SwitchProxy
      | TemporaryRedirect
      | PermanentRedirect
      | BadRequest
      | Unauthorized
      | PaymentRequired
      | Forbidden
      | NotFound
      | MethodNotAllowed
      | NotAcceptable
      | ProxyAuthenticationRequired
      | RequestTimeout
      | Conflict
      | Gone
      | LengthRequired
      | PreconditionFailed
      | PayloadTooLarge
      | UriTooLong
      | UnsupportedMediaType
      | RangeNotSatisfiable
      | ExpectationFailed
      | ImATeapot
      | MisdirectedRequest
      | UnprocessableEntity
      | Locked
      | FailedDependency
      | UpgradeRequired
      | PreconditionRequired
      | TooManyRequests
      | RequestHeaderFieldsTooLarge
      | UnavailableForLegalReasons
      | InternalServerError
      | NotImplemented
      | BadGateway
      | ServiceUnavailable
      | GatewayTimeout
      | HttpVersionNotSupported
      | VariantAlsoNegotiates
      | InsufficientStorage
      | LoopDetected
      | NotExtended
      | NetworkAuthenticationRequired
    let fromInt: int => option<t>
    let toInt: t => int
  }

  let cookie: (
    t,
    ~name: string,
    ~maxAge: int=?,
    ~expiresGMT: Js.Date.t=?,
    ~httpOnly: bool=?,
    ~secure: bool=?,
    ~signed: bool=?,
    ~path: string=?,
    ~sameSite: [#Lax | #Strict | #None]=?,
    ~domain: string=?,
    Js.Json.t
  ) => t

  @ocaml.doc(
    "Web browsers and other compliant clients will only clear the cookie if the given options is identical to those given to res.cookie(), excluding expires and maxAge."
  )
  let clearCookie: (
    t,
    ~name: string,
    ~httpOnly: bool=?,
    ~secure: bool=?,
    ~signed: bool=?,
    ~path: string=?,
    ~sameSite: [#Lax | #Strict | #None]=?,
    ()
  ) => t

  @bs.send external sendFile: (t, string, 'a) => complete = "sendFile"
  @bs.send external sendString: (t, string) => complete = "send"
  @bs.send external sendJson: (t, Js.Json.t) => complete = "json"
  // not covered in tests
  @bs.send external sendBuffer: (t, Node.Buffer.t) => complete = "send"
  // not covered in tests
  @bs.send external sendArray: (t, array<'a>) => complete = "send" 
  @bs.send external sendRawStatus: (t, int) => complete = "sendStatus"
  let sendStatus: (t, StatusCode.t) => complete
  @bs.send external rawStatus: (t, int) => t = "status"
  let status: (t, StatusCode.t) => t

  // not covered in tests
  @bs.send @ocaml.deprecated("Use sendJson instead`") 
  external json: (t, Js.Json.t) => complete = "json" 
  @bs.send
  external redirectCode: (t, int, string) => complete = "redirect"
  @bs.send external redirect: (t, string) => complete = "redirect"
  @bs.send external setHeader: (t, string, string) => t = "set"
  // not covered in tests
  @bs.send external setType: (t, string) => t = "type"
  // not covered in tests
  @bs.send external setLinks: (t, Js.Dict.t<string>) => t = "links"
  // not covered in tests
  @bs.send external end_: t => complete = "end"
  // not covered in tests
  @bs.send external render: (t, string, 'v, 'a) => complete = "render"
}

module Next: {
  type content
  type t = (Js.undefined<content>, Response.t) => complete

  @ocaml.doc("value to use as [next] callback argument to invoke the next middleware")
  let middleware: Js.undefined<content>

  @ocaml.doc(
    "value to use as [next] callback argument to skip middleware processing for the current route."
  )
  let route: Js.undefined<content>

  @ocaml.doc(
    "[error e] returns the argument for [next] callback to be propagate
       error [e] through the chain of middleware."
  )
  let error: Error.t => Js.undefined<content>
}

module ByteLimit: {
  type t =
    | B(int)
    | Kb(float)
    | Mb(float)
    | Gb(float)
  let b: int => t
  let kb: float => t
  let mb: float => t
  let gb: float => t
}

module Middleware: {
  type t
  type next = Next.t
  let json: (~inflate: bool=?, ~strict: bool=?, ~limit: ByteLimit.t=?, unit) => t
  let text: (
    ~defaultCharset: string=?,
    ~fileType: string=?,
    ~inflate: bool=?,
    ~limit: ByteLimit.t=?,
    unit,
  ) => t
  let raw: (~inflate: bool=?, ~fileType: string=?, ~limit: ByteLimit.t=?, unit) => t
  let urlencoded: (
    ~extended: bool=?,
    ~inflate: bool=?,
    ~limit: ByteLimit.t=?,
    ~parameterLimit: int=?,
    unit,
  ) => t
  module type S = {
    type f
    let from: f => t
    type errorF
    let fromError: errorF => t
  }
  module type ApplyMiddleware = {
    type f
    let apply: (f, next, Request.t, Response.t) => unit
    type errorF
    let applyWithError: (errorF, next, Error.t, Request.t, Response.t) => unit
  }
  module Make: (A: ApplyMiddleware) => (S with type f = A.f and type errorF = A.errorF)
  include S
    with type f = (next, Request.t, Response.t) => complete
    and type errorF = (next, Error.t, Request.t, Response.t) => complete
}

module PromiseMiddleware: Middleware.S
  with type f = (Middleware.next, Request.t, Response.t) => Js.Promise.t<complete>
  and type errorF = (Middleware.next, Error.t, Request.t, Response.t) => Js.Promise.t<complete>

module type Routable = {
  type t
  let use: (t, Middleware.t) => unit
  let useWithMany: (t, array<Middleware.t>) => unit
  let useOnPath: (t, ~path: string, Middleware.t) => unit
  let useOnPathWithMany: (t, ~path: string, array<Middleware.t>) => unit
  let get: (t, ~path: string, Middleware.t) => unit
  let getWithMany: (t, ~path: string, array<Middleware.t>) => unit
  let options: (t, ~path: string, Middleware.t) => unit
  let optionsWithMany: (t, ~path: string, array<Middleware.t>) => unit
  let param: (t, ~name: string, Middleware.t) => unit
  let post: (t, ~path: string, Middleware.t) => unit
  let postWithMany: (t, ~path: string, array<Middleware.t>) => unit
  let put: (t, ~path: string, Middleware.t) => unit
  let putWithMany: (t, ~path: string, array<Middleware.t>) => unit
  let patch: (t, ~path: string, Middleware.t) => unit
  let patchWithMany: (t, ~path: string, array<Middleware.t>) => unit
  let delete: (t, ~path: string, Middleware.t) => unit
  let deleteWithMany: (t, ~path: string, array<Middleware.t>) => unit
}

module MakeBindFunctions: (
  T: {
    type t
  },
) => (Routable with type t = T.t)

module Router: {
  include Routable
  let make: (~caseSensitive: bool=?, ~mergeParams: bool=?, ~strict: bool=?, unit) => t
  external asMiddleware: t => Middleware.t = "%identity"
}

module HttpServer: {
  type t
  @bs.send
  external on: (
    t,
    @bs.string [#request((Request.t, Response.t) => unit) | #close(unit => unit)],
  ) => unit = "on"
}

let router: (~caseSensitive: bool=?, ~mergeParams: bool=?, ~strict: bool=?, unit) => Router.t

module App: {
  include Routable
  let useRouter: (t, Router.t) => unit
  let useRouterOnPath: (t, ~path: string, Router.t) => unit
  @bs.module external make: unit => t = "express"
  external asMiddleware: t => Middleware.t = "%identity"
  let listen: (
    t,
    ~port: int=?,
    ~hostname: string=?,
    ~onListen: Js.null_undefined<Js.Exn.t> => unit=?,
    unit,
  ) => HttpServer.t
  @bs.send external disable: (t, ~name: string) => unit = "disable"
  @bs.send external set: (t, string, string) => unit = "set"
  @bs.send external engine : (t, string, 'engine) => unit = "engine"
}

@ocaml.doc("[express ()] creates an instance of the App class.
     Alias for [App.make ()]")
let express: unit => App.t

module Static: {
  type options
  type stat
  type t
  
  let defaultOptions: unit => options
  @bs.set external dotfiles: (options, string) => unit = "dotfiles"
  @bs.set external etag: (options, bool) => unit = "etag"
  @bs.set external extensions: (options, array<string>) => unit = "extensions"
  @bs.set external fallthrough: (options, bool) => unit = "fallthrough"
  @bs.set external immutable: (options, bool) => unit = "immutable"
  @bs.set external indexBool: (options, bool) => unit = "index"
  @bs.set external indexString: (options, string) => unit = "index"
  @bs.set external lastModified: (options, bool) => unit = "lastModified"
  @bs.set external maxAge: (options, int) => unit = "maxAge"
  @bs.set external redirect: (options, bool) => unit = "redirect"
  @bs.set external setHeaders: (options, (Request.t, string, stat) => unit) => unit = "setHeaders"

  @ocaml.doc("[make directory] creates a static middleware for [directory]") @bs.module("express")
  external make: (string, options) => t = "static"

  @ocaml.doc("[asMiddleware static] casts [static] to a Middleware type")
  external asMiddleware: t => Middleware.t = "%identity"
}
