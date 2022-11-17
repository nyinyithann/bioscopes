type video = {
  id?: string,
  key?: string,
  site?: string,
  name?: string,
  type_?: string,
}

type images = {
  backdrops?: array<ImageModel.image>,
  logos?: array<ImageModel.image>,
  posters?: array<ImageModel.image>,
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

type external_ids = {
  imdb_id?: string,
  facebook_id?: string,
  instagram_id?: string,
  twitter_id?: string,
}

type production_company = {
  name?: string,
  origin_country?: string,
}

type videos = {results?: array<video>}

type credits = {
  cast?: array<cast>,
  crew?: array<crew>,
}

type spoken_language = {
  english_name?: string,
  iso_639_1?: string,
  name?: string,
}

type created_by = {
  id?: int,
  credit_id?: string,
  name?: string,
  gender?: int,
  profile_path?: string,
}

type episode = {
  air_date?: string,
  episode_count?: int,
  id?: int,
  name?: string,
  overview?: string,
  poster_path?: string,
  season_number?: int,
}

type detail_movie = {
  adult?: bool,
  backdrop_path?: string,
  genres?: array<GenreModel.genre>,
  id?: int,
  original_language?: string,
  original_title?: string,
  overview?: string,
  tagline?: string,
  popularity?: float,
  poster_path?: string,
  release_date?: string,
  runtime?: float,
  status?: string,
  title?: string,
  homepage?: string,
  video?: bool,
  vote_average?: float,
  vote_count?: int,
  budget?: float,
  revenue?: float,
  external_ids?: external_ids,
  production_companies?: array<production_company>,
  videos?: videos,
  credits?: credits,
  images?: images,
  spoken_languages?: array<spoken_language>,
  created_by?: created_by,
  episode_run_time?: array<int>,
  first_air_date?: string,
  last_air_date?: string,
  in_production?: bool,
  name?: string,
  number_of_episodes?: int,
  number_of_seasons?: int,
  original_name?: string,
  episodes?: array<episode>,
}

module Decoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let video = object(fields => {
    id: ?Marshal.to_opt(. fields, "id", string),
    key: ?Marshal.to_opt(. fields, "key", string),
    site: ?Marshal.to_opt(. fields, "site", string),
    name: ?Marshal.to_opt(. fields, "name", string),
    type_: ?Marshal.to_opt(. fields, "type", string),
  })

  let images = object(fields => {
    backdrops: ?Marshal.to_opt(. fields, "backdrops", array(ImageModel.ImageDecoder.image)),
    logos: ?Marshal.to_opt(. fields, "logos", array(ImageModel.ImageDecoder.image)),
    posters: ?Marshal.to_opt(. fields, "posters", array(ImageModel.ImageDecoder.image)),
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

  let external_ids = object(fields => {
    imdb_id: ?Marshal.to_opt(. fields, "imdb_id", string),
    facebook_id: ?Marshal.to_opt(. fields, "facebook_id", string),
    instagram_id: ?Marshal.to_opt(. fields, "instagram_id", string),
    twitter_id: ?Marshal.to_opt(. fields, "twitter_id", string),
  })

  let production_company = object(fields => {
    name: ?Marshal.to_opt(. fields, "name", string),
    origin_country: ?Marshal.to_opt(. fields, "origin_country", string),
  })

  let spoken_language = object(fields => {
    name: ?Marshal.to_opt(. fields, "name", string),
    iso_639_1: ?Marshal.to_opt(. fields, "iso_639_1", string),
    english_name: ?Marshal.to_opt(. fields, "english_name", string),
  })

  let videos = object(fields => {
    results: ?Marshal.to_opt(. fields, "results", array(video)),
  })

  let credits = object(fields => {
    cast: ?Marshal.to_opt(. fields, "cast", array(cast)),
    crew: ?Marshal.to_opt(. fields, "crew", array(crew)),
  })

  let created_by = object(fields => {
    id: ?Marshal.to_opt(. fields, "id", int),
    credit_id: ?Marshal.to_opt(. fields, "credit_id", string),
    name: ?Marshal.to_opt(. fields, "name", string),
    gender: ?Marshal.to_opt(. fields, "gender", int),
    profile_path: ?Marshal.to_opt(. fields, "profile_path", string),
  })

  let episode = object(fields => {
    air_date: ?Marshal.to_opt(. fields, "air_date", string),
    episode_count: ?Marshal.to_opt(. fields, "episode_count", int),
    id: ?Marshal.to_opt(. fields, "id", int),
    name: ?Marshal.to_opt(. fields, "name", string),
    overview: ?Marshal.to_opt(. fields, "overview", string),
    poster_path: ?Marshal.to_opt(. fields, "poster_path", string),
    season_number: ?Marshal.to_opt(. fields, "season_number", int),
  })

  let detail_movie: Json.Decode.t<detail_movie> = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    backdrop_path: ?Marshal.to_opt(. fields, "backdrop_path", string),
    genres: ?Marshal.to_opt(. fields, "genres", array(GenreModel.GenreDecoder.genre)),
    id: fields.required(. "id", int),
    original_language: ?Marshal.to_opt(. fields, "original_language", string),
    original_title: ?Marshal.to_opt(. fields, "original_title", string),
    status: ?Marshal.to_opt(. fields, "status", string),
    overview: ?Marshal.to_opt(. fields, "overview", string),
    tagline: ?Marshal.to_opt(. fields, "tagline", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    poster_path: ?Marshal.to_opt(. fields, "poster_path", string),
    homepage: ?Marshal.to_opt(. fields, "homepage", string),
    release_date: ?Marshal.to_opt(. fields, "release_date", string),
    runtime: ?Marshal.to_opt(. fields, "runtime", float),
    budget: ?Marshal.to_opt(. fields, "budget", float),
    revenue: ?Marshal.to_opt(. fields, "revenue", float),
    external_ids: ?Marshal.to_opt(. fields, "external_ids", external_ids),
    production_companies: ?Marshal.to_opt(.
      fields,
      "production_companies",
      array(production_company),
    ),
    title: ?Marshal.to_opt(. fields, "title", string),
    video: ?Marshal.to_opt(. fields, "video", bool),
    vote_average: ?Marshal.to_opt(. fields, "vote_average", float),
    vote_count: ?Marshal.to_opt(. fields, "vote_count", int),
    videos: ?Marshal.to_opt(. fields, "videos", videos),
    credits: ?Marshal.to_opt(. fields, "credits", credits),
    images: ?Marshal.to_opt(. fields, "images", images),
    spoken_languages: ?Marshal.to_opt(. fields, "spoken_languages", array(spoken_language)),
    created_by: ?Marshal.to_opt(. fields, "created_by", created_by),
    episode_run_time: ?Marshal.to_opt(. fields, "episode_run_time", array(int)),
    first_air_date: ?Marshal.to_opt(. fields, "first_air_date", string),
    last_air_date: ?Marshal.to_opt(. fields, "last_air_date", string),
    in_production: ?Marshal.to_opt(. fields, "in_production", bool),
    name: ?Marshal.to_opt(. fields, "name", string),
    original_name: ?Marshal.to_opt(. fields, "original_name", string),
    number_of_episodes: ?Marshal.to_opt(. fields, "number_of_episodes", int),
    number_of_seasons: ?Marshal.to_opt(. fields, "number_of_seasons", int),
    episodes: ?Marshal.to_opt(. fields, "episodes", array(episode)),
  })

  let decode = (. ~json: Js.Json.t): result<detail_movie, string> => {
    Json.decode(json, detail_movie)
  }
}
