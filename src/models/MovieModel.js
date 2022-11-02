// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Json$JsonCombinators from "@glennsl/rescript-json-combinators/src/Json.js";
import * as Json_Decode$JsonCombinators from "@glennsl/rescript-json-combinators/src/Json_Decode.js";

var movie = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              adult: fields.required("adult", Json_Decode$JsonCombinators.bool),
              backdrop_path: fields.optional("backdrop_path", Json_Decode$JsonCombinators.string),
              genre_ids: fields.optional("genre_ids", Json_Decode$JsonCombinators.array(Json_Decode$JsonCombinators.$$int)),
              id: fields.required("id", Json_Decode$JsonCombinators.$$int),
              original_language: fields.optional("original_language", Json_Decode$JsonCombinators.string),
              original_title: fields.optional("original_title", Json_Decode$JsonCombinators.string),
              overview: fields.optional("overview", Json_Decode$JsonCombinators.string),
              popularity: fields.required("popularity", Json_Decode$JsonCombinators.$$float),
              poster_path: fields.optional("poster_path", Json_Decode$JsonCombinators.string),
              release_date: fields.optional("release_date", Json_Decode$JsonCombinators.string),
              title: fields.required("title", Json_Decode$JsonCombinators.string),
              video: fields.required("video", Json_Decode$JsonCombinators.bool),
              vote_average: fields.required("vote_average", Json_Decode$JsonCombinators.$$float),
              vote_count: fields.required("vote_count", Json_Decode$JsonCombinators.$$int)
            };
    });

function decode(json) {
  return Json$JsonCombinators.decode(json, movie);
}

var MovieDecoder = {
  movie: movie,
  decode: decode
};

var movieList = Json_Decode$JsonCombinators.object(function (fields) {
      return {
              page: fields.required("page", Json_Decode$JsonCombinators.$$int),
              results: fields.required("results", Json_Decode$JsonCombinators.array(movie)),
              total_pages: fields.required("total_pages", Json_Decode$JsonCombinators.$$int),
              total_results: fields.required("total_results", Json_Decode$JsonCombinators.$$int)
            };
    });

function decode$1(json) {
  return Json$JsonCombinators.decode(json, movieList);
}

var MovieListDecoder = {
  movieList: movieList,
  decode: decode$1
};

export {
  MovieDecoder ,
  MovieListDecoder ,
}
/* movie Not a pure module */
