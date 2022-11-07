type genre = {
  id: int,
  name: string,
}

type genrelist = { genres : array<genre> }

module GenreDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let genre: Json.Decode.t<genre> = object(fields => {
    id: fields.required(. "id", int),
    name: fields.required(. "name", string),
  })

  let genrelist = object(fields => {
      genres: fields.required(. "genres", array(genre))
  })

  let decode = (. ~json: Js.Json.t): result<genrelist, string> => {
    Json.decode(json, genrelist)
  }
}

type genre_error = {
    success : bool,
    status_code : int,
    status_message: string
}

module GenreErrorDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let genre_error: Json.Decode.t<genre_error> = object(fields => {
    success: fields.required(. "success", bool),
    status_code: fields.required(. "status_code", int),
    status_message: fields.required(. "status_message", string),
  })

  let decode = (. ~json: Js.Json.t): result<genre_error, string> => {
    Json.decode(json, genre_error)
  }
}
