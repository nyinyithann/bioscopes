module type Interface = {
  type t
  let parse: (. string) => result<t, string>
  let stringfy: (. t) => string
}

module type Marshalable = {
  type t
  let to: JsonCombinators.Json.Decode.t<t>
  let from: t => Js.Json.t
}

module Make = (M: Marshalable): (Interface with type t := M.t) => {
  open! JsonCombinators
  open! JsonCombinators.Json.Decode
  open Webapi.Url

  type t = M.t

  let parse = (. str: string) => {
    let (fst, _) =
      str->URLSearchParams.make->URLSearchParams.entries->Js.Array2.from->Js.Array2.unsafe_get(0)
    Json.decode(Json.parseExn(fst), M.to)
  }

  let stringfy = (. o: t) => M.from(o)->JsonCombinators.Json.stringify
}

let to_opt: 'a. (
  . JsonCombinators.Json.Decode.fieldDecoders,
  string,
  JsonCombinators.Json.Decode.t<'a>,
) => option<'a> = (. fields, path, decode) => {
  try {
    fields.optional(. path, decode)
  } catch {
  | _ => None
  }
}
