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
}

type movielist = {
  page?: int,
  results?: array<movie>,
  total_pages?: int,
  total_results?: int,
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
  })

  let decode = (. ~json: Js.Json.t): result<movie, string> => {
    Json.decode(json, movie)
  }
}

module MovieListDecoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let movieList: Json.Decode.t<movielist> = object(fields => {
    page: ?Marshal.to_opt(. fields, "page", int),
    results: ?Marshal.to_opt(. fields, "results", array(MovieDecoder.movie)),
    total_pages: ?Marshal.to_opt(. fields, "total_pages", int),
    total_results: ?Marshal.to_opt(. fields, "total_results", int),
  })

  let decode = (. ~json: Js.Json.t): result<movielist, string> => {
    Json.decode(json, movieList)
  }
}
