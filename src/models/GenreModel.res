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
