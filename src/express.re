module Next = {
  type t;
};

module Request = {
  type t;
};

module Response = {
  type t;
  external sendFile : t => string => 'a => unit = "" [@@bs.send];
  external send : t => 'a => unit = "" [@@bs.send];
  external json : t => 'a => unit = "" [@@bs.send];
};

module Express = {
  type t;
  type middlewareT = Request.t => Response.t => Next.t => unit;
  external express : unit => t = "" [@@bs.module];
  external use : t => middlewareT => unit = "" [@@bs.send];
  external static : path::string => middlewareT = "" [@@bs.module "express"];
  external get : t => string => ('a => Response.t => unit) => unit = "" [@@bs.send];
  external listen : t => int => unit = "" [@@bs.send];
};
