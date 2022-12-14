// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_int from "rescript/lib/es6/js_int.js";
import * as Marshal from "../shared/Marshal.js";
import * as ImageModel from "./ImageModel.js";
import * as Json$JsonCombinators from "@glennsl/rescript-json-combinators/src/Json.js";
import * as Json_Decode$JsonCombinators from "@glennsl/rescript-json-combinators/src/Json_Decode.js";

var images = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              profiles: Marshal.to_opt(fields, "profiles", Json_Decode$JsonCombinators.array(ImageModel.ImageDecoder.image))
            };
    });

var external_ids = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              freebase_mid: Marshal.to_opt(fields, "freebase_mid", Json_Decode$JsonCombinators.string),
              freebase_id: Marshal.to_opt(fields, "freebase_id", Json_Decode$JsonCombinators.string),
              imdb_id: Marshal.to_opt(fields, "imdb_id", Json_Decode$JsonCombinators.string),
              tvrage_id: Marshal.to_opt(fields, "tvrage_id", Json_Decode$JsonCombinators.string),
              wikidata_id: Marshal.to_opt(fields, "wikidata_id", Json_Decode$JsonCombinators.string),
              facebook_id: Marshal.to_opt(fields, "facebook_id", Json_Decode$JsonCombinators.string),
              instagram_id: Marshal.to_opt(fields, "instagram_id", Json_Decode$JsonCombinators.string),
              twitter_id: Marshal.to_opt(fields, "twitter_id", Json_Decode$JsonCombinators.string)
            };
    });

var cast = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              adult: Marshal.to_opt(fields, "adult", Json_Decode$JsonCombinators.bool),
              backdrop_path: Marshal.to_opt(fields, "backdrop_path", Json_Decode$JsonCombinators.string),
              genre_ids: Marshal.to_opt(fields, "genre_ids", Json_Decode$JsonCombinators.array(Json_Decode$JsonCombinators.$$int)),
              id: Marshal.to_opt(fields, "id", Json_Decode$JsonCombinators.$$int),
              original_language: Marshal.to_opt(fields, "original_language", Json_Decode$JsonCombinators.string),
              original_title: Marshal.to_opt(fields, "original_title", Json_Decode$JsonCombinators.string),
              overview: Marshal.to_opt(fields, "overview", Json_Decode$JsonCombinators.string),
              popularity: Marshal.to_opt(fields, "popularity", Json_Decode$JsonCombinators.$$float),
              poster_path: Marshal.to_opt(fields, "poster_path", Json_Decode$JsonCombinators.string),
              release_date: Marshal.to_opt(fields, "release_date", Json_Decode$JsonCombinators.string),
              first_air_date: Marshal.to_opt(fields, "first_air_date", Json_Decode$JsonCombinators.string),
              name: Marshal.to_opt(fields, "name", Json_Decode$JsonCombinators.string),
              title: Marshal.to_opt(fields, "title", Json_Decode$JsonCombinators.string),
              video: Marshal.to_opt(fields, "video", Json_Decode$JsonCombinators.bool),
              vote_average: Marshal.to_opt(fields, "vote_average", Json_Decode$JsonCombinators.$$float),
              vote_count: Marshal.to_opt(fields, "vote_count", Json_Decode$JsonCombinators.$$int),
              character: Marshal.to_opt(fields, "character", Json_Decode$JsonCombinators.string),
              credit_id: Marshal.to_opt(fields, "credit_id", Json_Decode$JsonCombinators.string),
              order: Marshal.to_opt(fields, "order", Json_Decode$JsonCombinators.$$int),
              department: Marshal.to_opt(fields, "department", Json_Decode$JsonCombinators.string),
              job: Marshal.to_opt(fields, "job", Json_Decode$JsonCombinators.string),
              media_type: Marshal.to_opt(fields, "media_type", Json_Decode$JsonCombinators.string),
              episode_count: Marshal.to_opt(fields, "episode_count", Json_Decode$JsonCombinators.$$int)
            };
    });

var combined_credits = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              cast: Marshal.to_opt(fields, "cast", Json_Decode$JsonCombinators.array(cast)),
              crew: Marshal.to_opt(fields, "crew", Json_Decode$JsonCombinators.array(cast))
            };
    });

var person = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              adult: Marshal.to_opt(fields, "adult", Json_Decode$JsonCombinators.bool),
              also_known_as: Marshal.to_opt(fields, "also_known_as", Json_Decode$JsonCombinators.array(Json_Decode$JsonCombinators.string)),
              biography: Marshal.to_opt(fields, "biography", Json_Decode$JsonCombinators.string),
              birthday: Marshal.to_opt(fields, "birthday", Json_Decode$JsonCombinators.string),
              deathday: Marshal.to_opt(fields, "deathday", Json_Decode$JsonCombinators.string),
              gender: Marshal.to_opt(fields, "gender", Json_Decode$JsonCombinators.$$int),
              homepage: Marshal.to_opt(fields, "homepage", Json_Decode$JsonCombinators.string),
              id: fields.required("id", Json_Decode$JsonCombinators.$$int),
              imdb_id: Marshal.to_opt(fields, "imdb_id", Json_Decode$JsonCombinators.string),
              known_for_department: Marshal.to_opt(fields, "known_for_department", Json_Decode$JsonCombinators.string),
              name: Marshal.to_opt(fields, "name", Json_Decode$JsonCombinators.string),
              place_of_birth: Marshal.to_opt(fields, "place_of_birth", Json_Decode$JsonCombinators.string),
              popularity: Marshal.to_opt(fields, "popularity", Json_Decode$JsonCombinators.$$float),
              profile_path: Marshal.to_opt(fields, "profile_path", Json_Decode$JsonCombinators.string),
              images: Marshal.to_opt(fields, "images", images),
              external_ids: Marshal.to_opt(fields, "external_ids", external_ids),
              combined_credits: Marshal.to_opt(fields, "combined_credits", combined_credits)
            };
    });

function decode(json) {
  return Json$JsonCombinators.decode(json, person);
}

var Decoder = {
  images: images,
  external_ids: external_ids,
  cast: cast,
  combined_credits: combined_credits,
  person: person,
  decode: decode
};

var initial_invalid_id = Js_int.min;

export {
  initial_invalid_id ,
  Decoder ,
}
/* images Not a pure module */
