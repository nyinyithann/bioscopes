open Fetch
open Promise

let contentType = ("Content-type", "application/json")
let authorization = ("Authorization", `Bearer ${Env.apiReadAccess}`)

let checkResponseStatus = promise => {
  promise->then(response => {
    if Response.ok(response) {
      Ok(Response.json(response))->resolve
    } else {
      Error(Response.json(response))->resolve
    }
  })
}

let catchPromiseFault: Promise.t<result<Promise.t<Js.Json.t>, Promise.t<Js.Json.t>>> => Promise.t<
  result<Promise.t<Js.Json.t>, Promise.t<Js.Json.t>>,
> = promise => {
  let defaultFaultMsg = () => Js.Json.string("Unexpected Promise Fault!")
  promise->catch(e => {
    switch e {
    | Js.Exn.Error(obj) =>
      switch Js.Exn.message(obj) {
      | Some(msg) =>
        Error(
          Promise.resolve(
            try Js.Json.parseExn(msg) catch {
            | _ => defaultFaultMsg()
            },
          ),
        )->resolve
      | _ => Error(Promise.resolve(defaultFaultMsg()))->resolve
      }
    | _ => Error(Promise.resolve(defaultFaultMsg()))->resolve
    }
  })
}

let handleResponse = (promise, ~callback, ()) => {
  promise->then(result => {
    switch result {
    | Ok(p) =>
      p
      ->thenResolve(data => {
        callback(Ok(data))
        resolve()
      })
      ->ignore
    | Error(msg) =>
      msg
      ->thenResolve(err => {
        callback(Error(err))
        resolve()
      })
      ->ignore
    }
    resolve()
  })
}

let getData = (
  ~apiPath: string,
  ~callback: result<Js.Json.t, Js.Json.t> => unit,
  ~signal=?,
  (),
) => {
  fetch(
    apiPath,
    {
      method: #GET,
      headers: Headers.fromArray([contentType, authorization]),
      ?signal,
    },
  )
  ->checkResponseStatus
  ->catchPromiseFault
  ->handleResponse(~callback, ())
}

let getGenres = (~callback, ~signal=?, ()) => {
  open Links
  let apiPath = `${apiBaseUrl}/${apiVersion}/genre/movie/list`
  fetch(
    apiPath,
    {
      method: #GET,
      headers: Headers.fromArray([contentType, authorization]),
      ?signal,
    },
  )
  ->checkResponseStatus
  ->catchPromiseFault
  ->handleResponse(~callback, ())
}
