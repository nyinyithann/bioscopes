type category_param = {name: string, display: string, page: int}
type genre_param = {id: int, name: string, display: string, page: int, sort_by: string}
type search_param = {query: string, page: int}

type query_param =
  | Category(category_param)
  | Genre(genre_param)
  | Search(search_param)
  | Movie(int)
  | Person(int)
  | Invalid(string)

module Converter_category_param = Marshal.Make({
  open! JsonCombinators
  open! JsonCombinators.Json.Decode
  type t = category_param
  let to = object(fields => {
    name: fields.required(. "name", string),
    display: fields.required(. "display", string),
    page: fields.required(. "page", int),
  })

  let from = (o: t) => {
    open! JsonCombinators.Json.Encode
    Unsafe.object({
      "name": string(o.name),
      "display": string(o.display),
      "page": int(o.page),
    })
  }
})

module Converter_genre_param = Marshal.Make({
  open! JsonCombinators
  open! JsonCombinators.Json.Decode
  type t = genre_param
  let to = object(fields => {
    id: fields.required(. "id", int),
    name: fields.required(. "name", string),
    display: fields.required(. "display", string),
    page: fields.required(. "page", int),
    sort_by: fields.required(. "sort_by", string),
  })

  let from = (o: t) => {
    open! JsonCombinators.Json.Encode
    Unsafe.object({
      "id": int(o.id),
      "name": string(o.name),
      "display": string(o.display),
      "page": int(o.page),
      "sort_by": string(o.sort_by),
    })
  }
})

let useQueryParams = (): (query_param, query_param => unit) => {
  let url = RescriptReactRouter.useUrl()
  let queryParam = switch (url.path, url.search) {
  | (list{}, "") => Category({name: "popular", display: "Popular", page: 1})
  | (list{}, q) =>
    switch Converter_category_param.parse(. q) {
    | Ok(p) => Category(p)
    | Error(msg) => Invalid(msg)
    }
  | (list{"genre"}, q) =>
    switch Converter_genre_param.parse(. q) {
    | Ok(p) => Genre(p)
    | Error(msg) => Invalid(msg)
    }
  | _ => Invalid("Invalid Route")
  }

  open Webapi.Url
  let setQueryParam = (params: query_param) => {
    switch params {
    | Category(p) => {
        let seg =
          `/?` ++
          Converter_category_param.stringfy(. p)->URLSearchParams.make->URLSearchParams.toString
        RescriptReactRouter.push(seg)
      }
    | Genre(p) => {
        let seg =
          `/genre?` ++
          Converter_genre_param.stringfy(. p)->URLSearchParams.make->URLSearchParams.toString
        RescriptReactRouter.push(seg)
      }
    | Movie(id) => {
        let seg = `/movie/${string_of_int(id)}` 
        RescriptReactRouter.push(seg)
      }

    | _ => ()
    }
  }
  (queryParam, setQueryParam)
}
