open Fetch
open Promise

let apiBaseUrl = "https://api.themoviedb.org/"
let apiVersion = "3"

let contentType = ("Content-type", "application/json")
let authorization = ("Authorization", `Bearer ${Env.apiReadAccess}`)

let checkResponseStatus = promise => {
  promise->then(response => {
    Response.ok(response)
      ? Ok(Response.json(response))->resolve
      : Error(
          `Error with status code: ${Response.status(
              response,
            )->Js.Int.toString}, status text: ${Response.statusText(response)}`,
        )->resolve
  })
}

let catchPromiseFault = promise => {
  promise->catch(e => {
    switch e {
    | Js.Exn.Error(obj) =>
      switch Js.Exn.message(obj) {
      | Some(msg) => Error(msg)->resolve
      | _ => Error("Unexpected Error")->resolve
      }
    | _ => Error("Unexpected Error")->resolve
    }
  })
}

let handleResponse = (promise, ~callback, ()) => {
  promise->then(result => {
    switch result {
    | Ok(p) =>
      p
      ->thenResolve(data => {
        callback(data)
        resolve()
      })
      ->ignore
    | Error(msg) => Js.log(msg)
    }
    resolve()
  })
}

let getMovies = (~apiPath: string, ~callback, ~signal=?, ()) => {
  fetch(
    apiPath,
    {
      method: #GET,
      headers: Headers.fromArray([contentType, authorization]),
      ?signal
    },
  )
  ->checkResponseStatus
  ->catchPromiseFault
  ->handleResponse(~callback, ())
}

let getGenres = (~callback, ~signal=?, ()) => {
  let apiPath = `${apiBaseUrl}/${apiVersion}/genre/movie/list`
  fetch(
    apiPath,
    {
      method: #GET,
      headers: Headers.fromArray([contentType, authorization]),
      ?signal
    },
  )
  ->checkResponseStatus
  ->catchPromiseFault
  ->handleResponse(~callback, ())
}
