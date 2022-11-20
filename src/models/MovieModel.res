type sort_info = {id: string, name: string}
let popularity: sort_info = {id: "popularity.desc", name: "Popularity"}
let vote_average: sort_info = {id: "vote_average.desc", name: "Vote Average"}
let original_title: sort_info = {id: "original_title.asc", name: "Original Title"}
let release_date: sort_info = {id: "release_date.desc", name: "Release Date"}

type movie = {
  adult?: bool,
  backdrop_path?: string,
  genre_ids?: array<int>,
  id: int,
  original_language?: string,
  original_title?: string,
  overview?: string,
  popularity?: float,
  poster_path?: string,
  release_date?: string,
  title?: string,
  video?: bool,
  vote_average?: float,
  vote_count?: int,
  media_type?: string,
  /*
  The following fields are supposed to be in Person model.
  They are here because movie type is also used to represent search result for now.
  They will be moved to the proper place after TV shows borwsing and searching are supported.
 */
  name?: string,
  profile_path?: string,
}

type upcoming_dates = {
  maximum?: string,
  minimum?: string,
}

type movielist = {
  dates?: upcoming_dates,
  page?: int,
  results?: array<movie>,
  total_pages?: int,
  total_results?: int,
}

type movie_error = {
  errors?: array<string>,
  success?: bool,
}

module MovieErrorDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode
  let movie_error = object(fields => {
    errors: ?Marshal.to_opt(. fields, "errors", array(string)),
    success: ?Marshal.to_opt(. fields, "success", bool),
  })
  let decode = (. ~json: Js.Json.t): result<movie_error, string> => {
    Json.decode(json, movie_error)
  }
}

module MovieDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let movie: Json.Decode.t<movie> = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    backdrop_path: ?Marshal.to_opt(. fields, "backdrop_path", string),
    genre_ids: ?Marshal.to_opt(. fields, "genre_ids", array(int)),
    id: fields.required(. "id", int),
    original_language: ?Marshal.to_opt(. fields, "original_language", string),
    original_title: ?Marshal.to_opt(. fields, "original_title", string),
    overview: ?Marshal.to_opt(. fields, "overview", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    poster_path: ?Marshal.to_opt(. fields, "poster_path", string),
    release_date: ?Marshal.to_opt(. fields, "release_date", string),
    title: ?Marshal.to_opt(. fields, "title", string),
    video: ?Marshal.to_opt(. fields, "video", bool),
    vote_average: ?Marshal.to_opt(. fields, "vote_average", float),
    vote_count: ?Marshal.to_opt(. fields, "vote_count", int),
    media_type: ?Marshal.to_opt(. fields, "media_type", string),
    profile_path: ?Marshal.to_opt(. fields, "profile_path", string),
    name: ?Marshal.to_opt(. fields, "name", string),
  })

  let decode = (. ~json: Js.Json.t): result<movie, string> => {
    Json.decode(json, movie)
  }
}

module MovieListDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let dates = object(fields => {
    maximum: ?Marshal.to_opt(. fields, "maximum", string),
    minimum: ?Marshal.to_opt(. fields, "minimum", string),
  })

  let movieList: Json.Decode.t<movielist> = object(fields => {
    dates: ?Marshal.to_opt(. fields, "dates", dates),
    page: ?Marshal.to_opt(. fields, "page", int),
    results: ?Marshal.to_opt(. fields, "results", array(MovieDecoder.movie)),
    total_pages: ?Marshal.to_opt(. fields, "total_pages", int),
    total_results: ?Marshal.to_opt(. fields, "total_results", int),
  })

  let decode = (. ~json: Js.Json.t): result<movielist, string> => {
    Json.decode(json, movieList)
  }
}

module HashableMovie = unpack(
  Belt.Id.hashableU(~hash=(. m: movie) => land(m.id, 65536), ~eq=(. x, y) => x.id == y.id)
)

let unique = (arr1, arr2) => {
  open Belt.HashSet
  fromArray(Belt.Array.concat(arr1, arr2), ~id=module(HashableMovie))->toArray
}
