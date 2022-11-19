type images = {profiles?: array<ImageModel.image>}

type external_ids = {
  freebase_mid?: string,
  freebase_id?: string,
  imdb_id?: string,
  tvrage_id?: string,
  wikidata_id?: string,
  facebook_id?: string,
  instagram_id?: string,
  twitter_id?: string,
}

type cast = {
  adult?: bool,
  backdrop_path?: string,
  genre_ids?: array<int>,
  id?: int,
  original_language?: string,
  original_title?: string,
  overview?: string,
  popularity?: float,
  poster_path?: string,
  release_date?: string,
  first_air_date?: string,
  name?: string,
  title?: string,
  video?: bool,
  vote_average?: float,
  vote_count?: int,
  character?: string,
  credit_id?: string,
  order?: int,
  department?: string,
  job?: string,
  media_type?: string,
  episode_count?: int,
}

type combined_credits = {
  cast?: array<cast>,
  crew?: array<cast>,
}

let initial_invalid_id = Js.Int.min

type person = {
  adult?: bool,
  also_known_as?: array<string>,
  biography?: string,
  birthday?: string,
  deathday?: string,
  gender?: int,
  homepage?: string,
  id: int,
  imdb_id?: string,
  known_for_department?: string,
  name?: string,
  place_of_birth?: string,
  popularity?: float,
  profile_path?: string,
  images?: images,
  external_ids?: external_ids,
  combined_credits?: combined_credits,
}

module Decoder = {
  open JsonCombinators
  open! JsonCombinators.Json.Decode

  let images = object(fields => {
    profiles: ?Marshal.to_opt(. fields, "profiles", array(ImageModel.ImageDecoder.image)),
  })

  let external_ids = object(fields => {
    freebase_mid: ?Marshal.to_opt(. fields, "freebase_mid", string),
    freebase_id: ?Marshal.to_opt(. fields, "freebase_id", string),
    imdb_id: ?Marshal.to_opt(. fields, "imdb_id", string),
    tvrage_id: ?Marshal.to_opt(. fields, "tvrage_id", string),
    wikidata_id: ?Marshal.to_opt(. fields, "wikidata_id", string),
    facebook_id: ?Marshal.to_opt(. fields, "facebook_id", string),
    instagram_id: ?Marshal.to_opt(. fields, "instagram_id", string),
    twitter_id: ?Marshal.to_opt(. fields, "twitter_id", string),
  })

  let cast: Json.Decode.t<cast> = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    backdrop_path: ?Marshal.to_opt(. fields, "backdrop_path", string),
    genre_ids: ?Marshal.to_opt(. fields, "genre_ids", array(int)),
    id: ?Marshal.to_opt(. fields, "id", int),
    original_language: ?Marshal.to_opt(. fields, "original_language", string),
    original_title: ?Marshal.to_opt(. fields, "original_title", string),
    overview: ?Marshal.to_opt(. fields, "overview", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    poster_path: ?Marshal.to_opt(. fields, "poster_path", string),
    release_date: ?Marshal.to_opt(. fields, "release_date", string),
    first_air_date: ?Marshal.to_opt(. fields, "first_air_date", string),
    title: ?Marshal.to_opt(. fields, "title", string),
    name: ?Marshal.to_opt(. fields, "name", string),
    video: ?Marshal.to_opt(. fields, "video", bool),
    vote_average: ?Marshal.to_opt(. fields, "vote_average", float),
    vote_count: ?Marshal.to_opt(. fields, "vote_count", int),
    character: ?Marshal.to_opt(. fields, "character", string),
    credit_id: ?Marshal.to_opt(. fields, "credit_id", string),
    order: ?Marshal.to_opt(. fields, "order", int),
    department: ?Marshal.to_opt(. fields, "department", string),
    job: ?Marshal.to_opt(. fields, "job", string),
    media_type: ?Marshal.to_opt(. fields, "media_type", string),
    episode_count: ?Marshal.to_opt(. fields, "episode_count", int),
  })

  let combined_credits = object(fields => {
    cast: ?Marshal.to_opt(. fields, "cast", array(cast)),
    crew: ?Marshal.to_opt(. fields, "crew", array(cast)),
  })

  let person: Json.Decode.t<person> = object(fields => {
    adult: ?Marshal.to_opt(. fields, "adult", bool),
    also_known_as: ?Marshal.to_opt(. fields, "also_known_as", array(string)),
    biography: ?Marshal.to_opt(. fields, "biography", string),
    birthday: ?Marshal.to_opt(. fields, "birthday", string),
    deathday: ?Marshal.to_opt(. fields, "deathday", string),
    gender: ?Marshal.to_opt(. fields, "gender", int),
    homepage: ?Marshal.to_opt(. fields, "homepage", string),
    id: fields.required(. "id", int),
    imdb_id: ?Marshal.to_opt(. fields, "imdb_id", string),
    known_for_department: ?Marshal.to_opt(. fields, "known_for_department", string),
    name: ?Marshal.to_opt(. fields, "name", string),
    place_of_birth: ?Marshal.to_opt(. fields, "place_of_birth", string),
    popularity: ?Marshal.to_opt(. fields, "popularity", float),
    profile_path: ?Marshal.to_opt(. fields, "profile_path", string),
    images: ?Marshal.to_opt(. fields, "images", images),
    external_ids: ?Marshal.to_opt(. fields, "external_ids", external_ids),
    combined_credits: ?Marshal.to_opt(. fields, "combined_credits", combined_credits),
  })

  let decode = (. ~json: Js.Json.t): result<person, string> => {
    Json.decode(json, person)
  }
}
