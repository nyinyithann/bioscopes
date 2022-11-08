type video = {
  id?: string,
  key?: string,
  site?: string,
}

type image = {
  aspect_ratio?: float,
  height?: float,
  width?: float,
  file_path?: string,
  vote_average?: float,
  vote_count?: float,
}

type cast = {
  adult?: bool,
  gender?: int,
  id?: int,
  known_for_department?: string,
  name?: string,
  popularity?: float,
  profile_path?: string,
  cast_id?: int,
  character?: string,
  credit_id?: string,
  order?: int,
}

type crew = {
  adult?: bool,
  gender?: int,
  id?: int,
  known_for_department?: string,
  name?: string,
  original_name?: string,
  popularity?: float,
  profile_path?: string,
  credit_id?: string,
  department?: string,
  job?: string,
}

type detail_movie = {
  adult?: bool,
  backdrop_path?: string,
  genre_ids?: array<GenreModel.genre>,
  id?: int,
  original_language?: string,
  original_title?: string,
  overview?: string,
  popularity?: float,
  poster_path?: string,
  release_date?: string,
  runtime?: float,
  status?: string,
  title?: string,
  video?: bool,
  vote_average?: float,
  vote_count?: int,
  videos?: array<video>,
  backdrops?: array<image>,
  posters?: array<image>,
  casts?: array<cast>,
  crews?: array<crew>,
}

module Decoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let video = object(fields => {
    id: ?Marshal.to_opt(. fields, "id", string),
    key: ?Marshal.to_opt(. fields, "key", string),
    site: ?Marshal.to_opt(. fields, "site", string),
  })

  let image = object(fields => {
    aspect_ratio: ?Marshal.to_opt(. fields, "aspect_ratio", float),
    height: ?Marshal.to_opt(. fields, "height", float),
    width: ?Marshal.to_opt(. fields, "width", float),
    file_path: ?Marshal.to_opt(. fields, "file_path", string),
    vote_average: ?Marshal.to_opt(. fields, "vote_average", float),
    vote_count: ?Marshal.to_opt(. fields, "vote_count", float),
  })

  let cast = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    gender: ?Marshal.to_opt(. fields, "gender", int),
    id: ?Marshal.to_opt(. fields, "id", int),
    known_for_department: ?Marshal.to_opt(. fields, "known_for_department", string),
    name: ?Marshal.to_opt(. fields, "name", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    profile_path: ?Marshal.to_opt(. fields, "profile_path", string),
    cast_id: ?Marshal.to_opt(. fields, "cast_id", int),
    character: ?Marshal.to_opt(. fields, "character", string),
    credit_id: ?Marshal.to_opt(. fields, "credit_id", string),
    order: ?Marshal.to_opt(. fields, "order", int),
  })

  let crew = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    gender: ?Marshal.to_opt(. fields, "gender", int),
    id: ?Marshal.to_opt(. fields, "id", int),
    known_for_department: ?Marshal.to_opt(. fields, "known_for_department", string),
    name: ?Marshal.to_opt(. fields, "name", string),
    original_name: ?Marshal.to_opt(. fields, "original_name", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    profile_path: ?Marshal.to_opt(. fields, "profile_path", string),
    credit_id: ?Marshal.to_opt(. fields, "credit_id", string),
    department: ?Marshal.to_opt(. fields, "department", string),
    job: ?Marshal.to_opt(. fields, "job", string),
  })

  let detail_movie: Json.Decode.t<detail_movie> = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    backdrop_path: ?Marshal.to_opt(. fields, "backdrop_path", string),
    genre_ids: ?Marshal.to_opt(. fields, "genre_ids", array(GenreModel.GenreDecoder.genre)),
    id: fields.required(. "id", int),
    original_language: ?Marshal.to_opt(. fields, "original_language", string),
    original_title: ?Marshal.to_opt(. fields, "original_title", string),
    overview: ?Marshal.to_opt(. fields, "overview", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    poster_path: ?Marshal.to_opt(. fields, "poster_path", string),
    release_date: ?Marshal.to_opt(. fields, "release_date", string),
    runtime: ?Marshal.to_opt(. fields, "runtime", float),
    title: ?Marshal.to_opt(. fields, "title", string),
    video: ?Marshal.to_opt(. fields, "video", bool),
    vote_average: ?Marshal.to_opt(. fields, "vote_average", float),
    vote_count: ?Marshal.to_opt(. fields, "vote_count", int),
    videos: ?Marshal.to_opt(. fields, "videos", array(video)),
    backdrops: ?Marshal.to_opt(. fields, "videos", array(image)),
    posters: ?Marshal.to_opt(. fields, "posters", array(image)),
    casts: ?Marshal.to_opt(. fields, "casts", array(cast)),
    crews: ?Marshal.to_opt(. fields, "crews", array(crew)),
  })
  
  let decode = (. ~json: Js.Json.t): result<detail_movie, string> => {
    Json.decode(json, detail_movie)
  }
}
