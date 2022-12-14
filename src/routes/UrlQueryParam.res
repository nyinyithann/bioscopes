type category_param = {name: string, display: string, page: int}
type genre_param = {id: int, name: string, display: string, page: int, sort_by: string}
type search_param = {query: string, page: int}
type movie_tv_param = {id: string, media_type: string}
type person_param = {id: string}

type query_param =
  | Category(category_param)
  | Genre(genre_param)
  | Search(search_param)
  | Movie(movie_tv_param)
  | Person(person_param)
  | Void(string)

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

module Converter_search_param = Marshal.Make({
  open! JsonCombinators
  open! JsonCombinators.Json.Decode
  type t = search_param

  let to = object(fields => {
    query: fields.required(. "query", string),
    page: fields.required(. "page", int),
  })

  let from = (o: t) => {
    open! JsonCombinators.Json.Encode
    Unsafe.object({
      "query": string(o.query),
      "page": int(o.page),
    })
  }
})

module Converter_movie_tv_param = Marshal.Make({
  open! JsonCombinators
  open! JsonCombinators.Json.Decode
  type t = movie_tv_param

  let to = object(fields => {
    id: fields.required(. "id", string),
    media_type: fields.required(. "media_type", string),
  })

  let from = (o: t) => {
    open! JsonCombinators.Json.Encode
    Unsafe.object({
      "id": string(o.id),
      "media_type": string(o.media_type),
    })
  }
})

module Converter_person_param = Marshal.Make({
  open! JsonCombinators
  open! JsonCombinators.Json.Decode
  type t = person_param

  let to = object(fields => {
    id: fields.required(. "id", string),
  })

  let from = (o: t) => {
    open! JsonCombinators.Json.Encode
    Unsafe.object({
      "id": string(o.id),
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
    | Error(msg) => Void(msg)
    }
  | (list{"genre"}, q) =>
    switch Converter_genre_param.parse(. q) {
    | Ok(p) => Genre(p)
    | Error(msg) => Void(msg)
    }
  | (list{"search"}, q) =>
    switch Converter_search_param.parse(. q) {
    | Ok(p) => Search(p)
    | Error(msg) => Void(msg)
    }
  | (list{"movie"}, q) =>
    switch Converter_movie_tv_param.parse(. q) {
    | Ok(p) => Movie(p)
    | Error(msg) => Void(msg)
    }
  | (list{"person"}, q) =>
    switch Converter_person_param.parse(. q) {
    | Ok(p) => Person(p)
    | Error(msg) => Void(msg)
    }
  | _ => Void("Invalid Route")
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

    | Search(s) => {
        let seg =
          `/search?` ++
          Converter_search_param.stringfy(. s)->URLSearchParams.make->URLSearchParams.toString
        RescriptReactRouter.push(seg)
      }

    | Movie(m) => {
        let seg =
          `/movie?` ++
          Converter_movie_tv_param.stringfy(. m)->URLSearchParams.make->URLSearchParams.toString
        RescriptReactRouter.push(seg)
      }

    | Person(p) => {
        let seg =
          `/person?` ++
          Converter_person_param.stringfy(. p)->URLSearchParams.make->URLSearchParams.toString
        RescriptReactRouter.push(seg)
      }

    | _ => ()
    }
  }
  (queryParam, setQueryParam)
}
