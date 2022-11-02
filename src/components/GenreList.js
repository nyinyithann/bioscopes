// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Loading from "./Loading.js";
import * as MovieAPI from "../http/MovieAPI.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as GenreModel from "../models/GenreModel.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Solid from "@heroicons/react/solid";

var cache = {
  contents: {}
};

function GenreList$Title(Props) {
  var name = Props.name;
  return React.createElement("div", {
              className: "w-full font-nav text-lg border-b-[1px] pl-4 pb-1 border-b-indigo-100 text-500"
            }, name);
}

var Title = {
  make: GenreList$Title
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

function GenreList$GenreLink(Props) {
  var id = Props.id;
  var name = Props.name;
  var dataName = Props.dataName;
  var icon = Props.icon;
  var onClick = Props.onClick;
  return React.cloneElement(React.createElement("button", {
                  className: "w-full font-general text-base text-left rounded-sm active:to-blue-500 transition duration-150 ease-linear pl-[3rem] py-1 flex gap-2 items-center text-600 hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:text-yellow-200",
                  type: "button",
                  onClick: onClick
                }, icon !== undefined ? Caml_option.valFromOption(icon) : React.createElement(Solid.FilmIcon, {
                        className: "w-3 h-3"
                      }), name), {
              "data-id": id,
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
  React.useEffect((function () {
          var genreCallback = function (json) {
            var genreList = GenreModel.GenreDecoder.decode(json);
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
            Curry._1(setState, (function (param) {
                    return {
                            TAG: /* Error */0,
                            _0: msg
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
            MovieAPI.getGenres(genreCallback, Caml_option.some(controller.signal), undefined);
          }
          return (function (param) {
                    controller.abort("Cancel the request");
                  });
        }), []);
  var onClick = React.useCallback((function (e) {
          var dataName = e.target.getAttribute("data-name");
          console.log(dataName);
        }), []);
  var tmp;
  tmp = typeof state === "number" ? React.createElement(Loading.make, {
          className: "w-[4rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
        }) : (
      state.TAG === /* Error */0 ? React.createElement("div", {
              className: "flex flex-wrap w-full px-1 text-red-400"
            }, "Error occured while loaind genres: " + state._0) : React.createElement("div", {
              className: "w-full"
            }, React.createElement("div", {
                  className: "flex flex-col w-full"
                }, React.createElement(GenreList$Title, {
                      name: "Discover"
                    }), React.createElement("div", {
                      className: "pt-1 flex flex-col justify-center items-center"
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
                      className: "pt-1 flex flex-col items-start justify-start h-[55vh] md:h-[70vh]"
                    }, React.createElement("div", {
                          className: "w-full flex flex-col overflow-y-auto bs-scrollbar dark:dark-scrollbar"
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
                  className: "flex font-brand w-full items-center justify-center pt-2 pb-4"
                }, React.createElement("h1", {
                      className: "text-3xl rounded-full font-extrabold bg-gradient-to-r from-teal-400 via-indigo-400 to-blue-400 text-yellow-200 flex items-center justify-center gap-2"
                    }, React.createElement(Solid.CameraIcon, {
                          className: "h-3 w-3 pl-1"
                        }), "BISCOPES", React.createElement(Solid.CameraIcon, {
                          className: "h-3 w-3 pr-1"
                        }))), tmp);
}

var make = GenreList;

export {
  cache ,
  Title ,
  staticItems ,
  GenreLink ,
  make ,
}
/* staticItems Not a pure module */
