// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Util from "../../shared/Util.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as MovieList from "../movie_list/MovieList.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ErrorDialog from "../ErrorDialog.js";
import * as MoviesProvider from "../../providers/MoviesProvider.js";

function string(prim) {
  return prim;
}

function array(prim) {
  return prim;
}

function MoreLikeThis(Props) {
  var movieId = Props.movieId;
  var match = MoviesProvider.useMoviesContext(undefined);
  var clearError = match.clearError;
  var loadRecommendedMovies = match.loadRecommendedMovies;
  var error = match.error;
  var loading = match.loading;
  var recommendedMovies = match.recommendedMovies;
  var mlistRef = React.useRef([]);
  var totalPagesRef = React.useRef(0);
  var currentPageRef = React.useRef(0);
  React.useMemo((function () {
          mlistRef.current = Js_option.getWithDefault([], recommendedMovies.results);
          totalPagesRef.current = Util.getOrIntZero(recommendedMovies.total_pages);
          currentPageRef.current = Util.getOrIntZero(recommendedMovies.page);
        }), [movieId]);
  var onClose = function (arg) {
    if (arg) {
      return Curry._1(clearError, undefined);
    }
    
  };
  var controller = new AbortController();
  var loadPage = function (page) {
    Curry._3(loadRecommendedMovies, movieId, page, controller.signal);
  };
  var match$1 = React.useState(function () {
        return null;
      });
  var setLastPoster = match$1[1];
  var lastPoster = match$1[0];
  var match$2 = React.useState(function () {
        return currentPageRef.current;
      });
  var setPageToLoad = match$2[1];
  var pageToLoad = match$2[0];
  var setLastPosterRef = function (elem) {
    Curry._1(setLastPoster, (function (param) {
            return elem;
          }));
  };
  var observer = React.useRef(new IntersectionObserver((function (entries, param) {
              var entry = Belt_Array.get(entries, 0);
              if (entry !== undefined && Caml_option.valFromOption(entry).isIntersecting && !loading) {
                return Curry._1(setPageToLoad, (function (p) {
                              return p + 1 | 0;
                            }));
              }
              
            })));
  React.useEffect((function () {
          if (pageToLoad !== currentPageRef.current && pageToLoad <= totalPagesRef.current) {
            loadPage(pageToLoad);
          }
          
        }), [pageToLoad]);
  React.useEffect((function () {
          var currentObserver = observer.current;
          if (!(lastPoster == null)) {
            currentObserver.observe(lastPoster);
          }
          return (function (param) {
                    if (!(lastPoster == null)) {
                      currentObserver.unobserve(lastPoster);
                      return ;
                    }
                    
                  });
        }), [lastPoster]);
  return React.createElement("div", {
              className: "flex flex-col items-center justify-center bg-white dark:dark-bg"
            }, React.createElement("ul", {
                  className: "grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-y-4 gap-2 justify-center items-start w-full relative dark:dark-bg"
                }, Belt_Array.mapWithIndex(mlistRef.current, (function (i, m) {
                        if (i === (mlistRef.current.length - 1 | 0) && !loading && currentPageRef.current <= totalPagesRef.current) {
                          return React.createElement("li", {
                                      key: Util.itos(m.id) + currentPageRef.current.toString(),
                                      ref: setLastPosterRef
                                    }, React.createElement(MovieList.Poster.make, {
                                          movie: m
                                        }));
                        } else {
                          return React.createElement("li", {
                                      key: Util.itos(m.id) + currentPageRef.current.toString()
                                    }, React.createElement(MovieList.Poster.make, {
                                          movie: m
                                        }));
                        }
                      }))), error.length > 0 ? React.createElement(ErrorDialog.make, {
                    isOpen: error.length > 0,
                    errorMessage: error,
                    onClose: onClose
                  }) : null);
}

var make = MoreLikeThis;

export {
  string ,
  array ,
  make ,
}
/* react Not a pure module */
