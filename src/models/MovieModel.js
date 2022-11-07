// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Marshal from "../shared/Marshal.js";
import * as Json$JsonCombinators from "@glennsl/rescript-json-combinators/src/Json.js";
import * as Json_Decode$JsonCombinators from "@glennsl/rescript-json-combinators/src/Json_Decode.js";

var movie_error = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              errors: Marshal.to_opt(fields, "errors", Json_Decode$JsonCombinators.array(Json_Decode$JsonCombinators.string)),
              success: Marshal.to_opt(fields, "success", Json_Decode$JsonCombinators.bool)
            };
    });

function decode(json) {
  return Json$JsonCombinators.decode(json, movie_error);
}

var MovieErrorDecoder = {
  movie_error: movie_error,
  decode: decode
};

var movie = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              adult: Marshal.to_opt(fields, "adult", Json_Decode$JsonCombinators.bool),
              backdrop_path: Marshal.to_opt(fields, "backdrop_path", Json_Decode$JsonCombinators.string),
              genre_ids: Marshal.to_opt(fields, "genre_ids", Json_Decode$JsonCombinators.array(Json_Decode$JsonCombinators.$$int)),
              id: fields.required("id", Json_Decode$JsonCombinators.$$int),
              original_language: Marshal.to_opt(fields, "original_language", Json_Decode$JsonCombinators.string),
              original_title: Marshal.to_opt(fields, "original_title", Json_Decode$JsonCombinators.string),
              overview: Marshal.to_opt(fields, "overview", Json_Decode$JsonCombinators.string),
              popularity: Marshal.to_opt(fields, "popularity", Json_Decode$JsonCombinators.$$float),
              poster_path: Marshal.to_opt(fields, "poster_path", Json_Decode$JsonCombinators.string),
              release_date: Marshal.to_opt(fields, "release_date", Json_Decode$JsonCombinators.string),
              title: Marshal.to_opt(fields, "title", Json_Decode$JsonCombinators.string),
              video: Marshal.to_opt(fields, "video", Json_Decode$JsonCombinators.bool),
              vote_average: Marshal.to_opt(fields, "vote_average", Json_Decode$JsonCombinators.$$float),
              vote_count: Marshal.to_opt(fields, "vote_count", Json_Decode$JsonCombinators.$$int)
            };
    });

function decode$1(json) {
  return Json$JsonCombinators.decode(json, movie);
}

var MovieDecoder = {
  movie: movie,
  decode: decode$1
};

var dates = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              maximum: Marshal.to_opt(fields, "maximum", Json_Decode$JsonCombinators.string),
              minimum: Marshal.to_opt(fields, "minimum", Json_Decode$JsonCombinators.string)
            };
    });

var movieList = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              dates: Marshal.to_opt(fields, "dates", dates),
              page: Marshal.to_opt(fields, "page", Json_Decode$JsonCombinators.$$int),
              results: Marshal.to_opt(fields, "results", Json_Decode$JsonCombinators.array(movie)),
              total_pages: Marshal.to_opt(fields, "total_pages", Json_Decode$JsonCombinators.$$int),
              total_results: Marshal.to_opt(fields, "total_results", Json_Decode$JsonCombinators.$$int)
            };
    });

function decode$2(json) {
  var d = Json$JsonCombinators.decode(json, movieList);
  console.log(d);
  return d;
}

var MovieListDecoder = {
  dates: dates,
  movieList: movieList,
  decode: decode$2
};

export {
  MovieErrorDecoder ,
  MovieDecoder ,
  MovieListDecoder ,
}
/* movie_error Not a pure module */
