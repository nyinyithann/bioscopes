// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Image from "./Image.js";
import * as Links from "../shared/Links.js";
import * as React from "react";
import * as Rating from "./Rating.js";
import * as Loading from "./Loading.js";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as UrlQueryParam from "../routes/UrlQueryParam.js";
import * as MoviesProvider from "../providers/MoviesProvider.js";

function string(prim) {
  return prim;
}

function array(prim) {
  return prim;
}

function MovieList$Poster(Props) {
  var title = Props.title;
  var poster_path = Props.poster_path;
  var vote_average = Props.vote_average;
  var release_date = Props.release_date;
  var imgLink = poster_path !== undefined ? Links.getPosterImageW342Link(poster_path) : "";
  var title$1 = Js_option.getWithDefault("", title);
  var releaseYear = release_date !== undefined ? release_date.substring(0, 4) : "";
  return React.createElement("div", {
              className: "relative flex flex-col flex-shrink-0 gap-2 transition ease-linear w-[10rem] h-[22rem] sm:w-[15rem] sm:h-[28rem] items-center justify-start hover:border-[1px] hover:border-slate-200 transform duration-300 hover:-translate-y-1 hover:shadow-2xl hover:scale-105 group hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:rounded-md",
              role: "button",
              type: "button",
              onClick: (function (param) {
                  console.log("Hello");
                })
            }, React.createElement($$Image.make, {
                  overlayEnabled: true,
                  lazyLoadEnabled: true,
                  lazyLoadOffset: 50,
                  className: "flex-shrink-0 group-hover:saturate-150 border-[2px] border-slate-200 rounded-md",
                  width: 160,
                  height: 240,
                  sm_width: 240,
                  sm_height: 352,
                  sm_mediaQuery: "(max-width: 600px)",
                  alt: "A poster",
                  placeholderPath: Links.placeholderImage,
                  src: imgLink
                }), React.createElement("p", {
                  className: "" + (
                    title$1.length > 50 ? "text-[0.7rem]" : "text-[0.95rem]"
                  ) + " break-words transform duration-300 group-hover:text-yellow-200 pt-[0.3rem] flex justify-center items-center text-center"
                }, title$1), React.createElement(Rating.make, {
                  ratingValue: vote_average
                }), releaseYear.length === 4 ? React.createElement("div", {
                    className: "absolute top-[0.5rem] right-[0.5rem] text-[0.8rem] bg-gray-700/60 text-slate-50 px-[4px] py-[1px] rounded-sm"
                  }, releaseYear) : null);
}

var Poster = {
  make: MovieList$Poster
};

function MovieList(Props) {
  var match = UrlQueryParam.useQueryParams(undefined);
  var queryParam = match[0];
  var match$1 = MoviesProvider.useMoviesContext(undefined);
  var loadMovies = match$1.loadMovies;
  var movieList = Js_option.getWithDefault([], match$1.movies.results);
  var viewingTitleRef = React.useRef("");
  React.useEffect((function () {
          switch (queryParam.TAG | 0) {
            case /* Category */0 :
                var match = queryParam._0;
                var display = match.display;
                viewingTitleRef.current = display;
                window.document.title = display + " Movies";
                Curry._1(loadMovies, {
                      TAG: /* Category */0,
                      _0: {
                        name: match.name,
                        display: display,
                        page: match.page
                      }
                    });
                break;
            case /* Genre */1 :
                var match$1 = queryParam._0;
                var display$1 = match$1.display;
                viewingTitleRef.current = display$1;
                window.document.title = display$1 + " Movies";
                Curry._1(loadMovies, {
                      TAG: /* Genre */1,
                      _0: {
                        id: match$1.id,
                        name: match$1.name,
                        display: display$1,
                        page: match$1.page,
                        sort_by: match$1.sort_by
                      }
                    });
                break;
            default:
              
          }
        }), []);
  if (match$1.error.length > 0) {
    return React.createElement("div", undefined, "Error");
  } else if (match$1.loading) {
    return React.createElement(Loading.make, {
                className: "w-[6rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-green-500 fill-50 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
              });
  } else {
    return React.createElement("div", {
                className: "flex flex-col bg-white"
              }, React.createElement("div", {
                    className: "font-nav text-[1.2rem] text-500 p-1 pl-4 sticky top-[3.4rem] z-50 shadlow-md flex-shrink-0 bg-white border-t-[2px] border-slate-200"
                  }, viewingTitleRef.current), React.createElement("div", {
                    className: "w-full h-full flex flex-1 flex-wrap p-1 pt-4 gap-[1rem] sm:gap-[1.4rem] justify-center items-center px-[1rem] sm:px-[2rem] bg-white",
                    id: "movie-list-here"
                  }, Belt_Array.map(movieList, (function (m) {
                          return React.createElement(MovieList$Poster, {
                                      title: m.title,
                                      poster_path: m.poster_path,
                                      vote_average: m.vote_average,
                                      release_date: m.release_date,
                                      key: m.id.toString()
                                    });
                        }))));
  }
}

var make = MovieList;

export {
  string ,
  array ,
  Poster ,
  make ,
}
/* Image Not a pure module */
