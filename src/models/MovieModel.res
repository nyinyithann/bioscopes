type movie = {
  adult: bool,
  backdrop_path?: string,
  genre_ids?: array<int>,
  id: int,
  original_language?: string,
  original_title?: string,
  overview?: string,
  popularity: float,
  poster_path?: string,
  release_date?: string,
  title: string,
  video: bool,
  vote_average: float,
  vote_count: int,
}

type movielist = {
  page: int,
  results: array<movie>,
  total_pages: int,
  total_results: int,
}

module MovieDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let opt = (fields, path, decode) =>
    try {
      fields.optional(. path, decode)
    } catch {
    | _ => None
    }

  let movie: Json.Decode.t<movie> = object(fields => {
    adult: fields.required(. "adult", bool),
    backdrop_path: ?opt(fields, "backdrop_path", string), // ?fields.optional(. "backdrop_path", string),
    genre_ids: ?fields.optional(. "genre_ids", array(int)),
    id: fields.required(. "id", int),
    original_language: ?fields.optional(. "original_language", string),
    original_title: ?fields.optional(. "original_title", string),
    overview: ?fields.optional(. "overview", string),
    popularity: fields.required(. "popularity", float),
    poster_path: ?opt(fields, "poster_path", string),
    release_date: ?fields.optional(. "release_date", string),
    title: fields.required(. "title", string),
    video: fields.required(. "video", bool),
    vote_average: fields.required(. "vote_average", float),
    vote_count: fields.required(. "vote_count", int),
  })

  let decode = (. ~json: Js.Json.t): result<movie, string> => {
    Json.decode(json, movie)
  }
}

module MovieListDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let movieList: Json.Decode.t<movielist> = object(fields => {
    page: fields.required(. "page", int),
    results: fields.required(. "results", array(MovieDecoder.movie)),
    total_pages: fields.required(. "total_pages", int),
    total_results: fields.required(. "total_results", int),
  })

  let decode = (. ~json: Js.Json.t): result<movielist, string> => {
    Json.decode(json, movieList)
  }
}
