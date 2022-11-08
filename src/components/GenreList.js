// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Loading from "./Loading.js";
import * as MovieAPI from "../http/MovieAPI.js";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as GenreModel from "../models/GenreModel.js";
import * as MovieModel from "../models/MovieModel.js";
import * as Pervasives from "rescript/lib/es6/pervasives.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ErrorDisplay from "./ErrorDisplay.js";
import * as UrlQueryParam from "../routes/UrlQueryParam.js";
import * as Solid from "@heroicons/react/solid";

var cache = {
  contents: {}
};

var staticItems = [
  {
    id: -1,
    name: "Popular",
    dataName: "popular",
    icon: React.createElement(Solid.HeartIcon, {
          className: "w-3 h-3"
        })
  },
  {
    id: -2,
    name: "Top Rated",
    dataName: "top_rated",
    icon: React.createElement(Solid.TrendingUpIcon, {
          className: "w-3 h-3"
        })
  },
  {
    id: -3,
    name: "Upcoming",
    dataName: "upcoming",
    icon: React.createElement(Solid.TruckIcon, {
          className: "w-3 h-3"
        })
  }
];

function GenreList$Title(Props) {
  var name = Props.name;
  return React.createElement("div", {
              className: "w-full font-nav text-lg border-b-[1px] pl-4 pb-1 border-b-indigo-100 text-500"
            }, name);
}

var Title = {
  make: GenreList$Title
};

function GenreList$GenreLink(Props) {
  var id = Props.id;
  var name = Props.name;
  var dataName = Props.dataName;
  var icon = Props.icon;
  var onClick = Props.onClick;
  var match = UrlQueryParam.useQueryParams(undefined);
  var queryParam = match[0];
  var hl = "bg-gradient-to-r from-teal-400 to-blue-400 text-yellow-200";
  var highligh;
  switch (queryParam.TAG | 0) {
    case /* Category */0 :
        highligh = queryParam._0.name === Js_option.getWithDefault("", dataName) ? hl : "";
        break;
    case /* Genre */1 :
        highligh = queryParam._0.id === id ? hl : "";
        break;
    default:
      highligh = "";
  }
  return React.cloneElement(React.createElement("button", {
                  className: "" + highligh + " text-base text-left active:to-blue-500 transition duration-150 ease-linear pl-[3rem] py-1 flex gap-2 items-center hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:text-yellow-200 snap-start",
                  type: "button",
                  onClick: onClick
                }, icon !== undefined ? Caml_option.valFromOption(icon) : React.createElement(Solid.FilmIcon, {
                        className: "w-3 h-3"
                      }), name), {
              "data-id": id,
              "data-display": name,
              "data-name": dataName !== undefined ? dataName : name
            });
}

var GenreLink = {
  make: GenreList$GenreLink
};

function GenreList(Props) {
  var match = React.useState(function () {
        return /* Loading */0;
      });
  var setState = match[1];
  var state = match[0];
  var match$1 = UrlQueryParam.useQueryParams(undefined);
  var setQueryParam = match$1[1];
  var queryParam = match$1[0];
  React.useEffect((function () {
          var callback = function (result) {
            if (result.TAG === /* Ok */0) {
              var genreList = GenreModel.GenreDecoder.decode(result._0);
              if (genreList.TAG === /* Ok */0) {
                var genreList$1 = genreList._0;
                cache.contents["genres"] = genreList$1.genres;
                return Curry._1(setState, (function (param) {
                              return {
                                      TAG: /* Success */1,
                                      _0: genreList$1.genres
                                    };
                            }));
              }
              var msg = genreList._0;
              return Curry._1(setState, (function (param) {
                            return {
                                    TAG: /* Error */0,
                                    _0: msg
                                  };
                          }));
            }
            var e = GenreModel.GenreErrorDecoder.decode(result._0);
            if (e.TAG !== /* Ok */0) {
              return Curry._1(setState, (function (param) {
                            return {
                                    TAG: /* Error */0,
                                    _0: "Unexpected error occured while reteriving genre data."
                                  };
                          }));
            }
            var e$1 = e._0;
            Curry._1(setState, (function (param) {
                    return {
                            TAG: /* Error */0,
                            _0: e$1.status_message
                          };
                  }));
          };
          var controller = new AbortController();
          var genres = Js_dict.get(cache.contents, "genres");
          if (genres !== undefined) {
            Curry._1(setState, (function (param) {
                    return {
                            TAG: /* Success */1,
                            _0: genres
                          };
                  }));
          } else {
            MovieAPI.getGenres(callback, Caml_option.some(controller.signal), undefined);
          }
          return (function (param) {
                    controller.abort("Cancel the request");
                  });
        }), []);
  var onClick = React.useCallback((function (e) {
          var dataId = e.target.getAttribute("data-id");
          var dataName = e.target.getAttribute("data-name");
          var dataDisplay = e.target.getAttribute("data-display");
          var id = Pervasives.int_of_string_opt(dataId);
          if (id === undefined) {
            return ;
          }
          if (id < 0) {
            return Curry._1(setQueryParam, {
                        TAG: /* Category */0,
                        _0: {
                          name: dataName,
                          display: dataDisplay,
                          page: 1
                        }
                      });
          }
          if (id <= 0) {
            return ;
          }
          var sort_by;
          sort_by = queryParam.TAG === /* Genre */1 ? queryParam._0.sort_by : MovieModel.popularity.id;
          Curry._1(setQueryParam, {
                TAG: /* Genre */1,
                _0: {
                  id: id,
                  name: dataName,
                  display: dataDisplay,
                  page: 1,
                  sort_by: sort_by
                }
              });
        }), []);
  var tmp;
  tmp = typeof state === "number" ? React.createElement(Loading.make, {
          className: "w-[4rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
        }) : (
      state.TAG === /* Error */0 ? React.createElement("div", {
              className: "flex flex-wrap w-full h-auto"
            }, React.createElement(ErrorDisplay.make, {
                  errorMessage: state._0
                })) : React.createElement("div", {
              className: "w-full"
            }, React.createElement("div", {
                  className: "flex flex-col w-full"
                }, React.createElement(GenreList$Title, {
                      name: "Discover"
                    }), React.createElement("div", {
                      className: "pt-1 w-full flex flex-col"
                    }, Belt_Array.map(staticItems, (function (x) {
                            return React.createElement(GenreList$GenreLink, {
                                        id: x.id,
                                        name: x.name,
                                        dataName: x.dataName,
                                        icon: x.icon,
                                        onClick: onClick,
                                        key: x.dataName
                                      });
                          })))), React.createElement("div", {
                  className: "flex flex-col w-full"
                }, React.createElement(GenreList$Title, {
                      name: "Genres"
                    }), React.createElement("div", {
                      className: "pt-1 flex flex-col items-start justify-start h-[60vh] md:h-[68vh]"
                    }, React.createElement("div", {
                          className: "w-full flex flex-col overflow-y-auto scrollbar-thin scrollbar-thumb-slate-200 scrollbar-thumb-rounded snap-y"
                        }, Belt_Array.map(state._0, (function (x) {
                                return React.createElement(GenreList$GenreLink, {
                                            id: x.id,
                                            name: x.name,
                                            onClick: onClick,
                                            key: x.id.toString()
                                          });
                              }))))))
    );
  return React.createElement("div", {
              className: "flex flex-col items-start justify-center z-50"
            }, React.createElement("div", {
                  className: "flex font-nav tracking-widest w-full items-center pb-4 gap-2"
                }, React.createElement("div", {
                      className: "text-lg sm:text-2xl md:text-3xl w-full font-extrabold bg-gradient-to-r from-teal-400 via-indigo-400 to-blue-400 text-yellow-200 flex items-center justify-start gap-2 py-[0.2rem] px-[0.6rem]"
                    }, React.createElement(Solid.CameraIcon, {
                          className: "h-3 w-3 pl-1"
                        }), "BIOSCOPES", React.createElement(Solid.CameraIcon, {
                          className: "h-3 w-3 pr-1"
                        }))), tmp);
}

var make = GenreList;

export {
  cache ,
  staticItems ,
  Title ,
  GenreLink ,
  make ,
}
/* staticItems Not a pure module */
