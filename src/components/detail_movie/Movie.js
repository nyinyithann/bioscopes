// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Hero from "./Hero.js";
import * as Util from "../../shared/Util.js";
import * as Casts from "./Casts.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Pulse from "../Pulse.js";
import * as React from "react";
import * as $$Window from "../../hooks/Window.js";
import * as $$Document from "../../hooks/Document.js";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as VideoPanel from "./VideoPanel.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ErrorDialog from "../ErrorDialog.js";
import * as ModalDialog from "../ModalDialog.js";
import * as PhotosPanel from "./PhotosPanel.js";
import * as MoreLikeThis from "./MoreLikeThis.js";
import * as UrlQueryParam from "../../routes/UrlQueryParam.js";
import * as MoviesProvider from "../../providers/MoviesProvider.js";
import * as StorylinePanel from "./StorylinePanel.js";
import * as React$1 from "@headlessui/react";
import Youtube from "react-player/youtube";
import * as YoutubePlayerProvider from "../../providers/YoutubePlayerProvider.js";
import * as Outline from "@heroicons/react/outline";

function string(prim) {
  return prim;
}

function Movie(Props) {
  var match = MoviesProvider.useMoviesContext(undefined);
  var clearError = match.clearError;
  var loadDetailMovie = match.loadDetailMovie;
  var error = match.error;
  var loading = match.loading;
  var detail_movie = match.detail_movie;
  var match$1 = YoutubePlayerProvider.useVideoPlayerContext(undefined);
  var stop = match$1.stop;
  var videoPlayState = match$1.videoPlayState;
  var windowSize = $$Window.useWindowSize(undefined);
  var match$2 = UrlQueryParam.useQueryParams(undefined);
  var queryParam = match$2[0];
  $$Document.useTitle(Js_option.getWithDefault("🎬", detail_movie.title));
  var voidLoading;
  voidLoading = match.apiParams.TAG === /* Void */5 ? true : false;
  React.useEffect((function () {
          var controller = new AbortController();
          if (queryParam.TAG === /* Movie */3) {
            var match = queryParam._0;
            Curry._2(loadDetailMovie, {
                  TAG: /* Movie */3,
                  _0: {
                    id: match.id,
                    media_type: match.media_type
                  }
                }, controller.signal);
          }
          return (function (param) {
                    controller.abort("Cancel the request");
                  });
        }), []);
  var onClose = function (arg) {
    if (arg) {
      return Curry._1(clearError, undefined);
    }
    
  };
  var tmp;
  if (loading) {
    tmp = React.createElement(Pulse.make, {
          show: loading && !voidLoading
        });
  } else {
    var movieId = detail_movie.id;
    tmp = React.createElement(React.Fragment, undefined, React.createElement("main", {
              className: "flex border-t-[2px] border-slate-200 relative dark:dark-top-border dark:dark-bg"
            }, React.createElement("div", {
                  className: "flex flex-col w-full h-full dark:dark-bg"
                }, React.createElement("div", {
                      className: "w-full dark:dark-bg",
                      id: "hero_container"
                    }, React.createElement(Hero.make, {
                          movie: detail_movie
                        })), React.createElement("div", {
                      className: "w-full flex flex-col items-center justify-center dark:dark-top-border-2",
                      id: "movie_info_tab_container"
                    }, React.createElement(React$1.Tab.Group, {
                          children: (function (selectedIndex) {
                              return React.createElement("div", {
                                          className: "flex flex-col w-full dark:dark-bg dark:dark-text"
                                        }, React.createElement(React$1.Tab.List, {
                                              className: "flex w-full flex-nowrap items-center justify-around",
                                              children: (function (param) {
                                                  return React.createElement(React.Fragment, undefined, React.createElement(React$1.Tab, {
                                                                  className: "control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300 dark:dark-tab-button",
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "" + (
                                                                                    props.selected ? "bg-300 text-900 dark:dark-tab-selected" : ""
                                                                                  ) + " w-full h-full control-color flex items-center justify-center py-2 font-semibold"
                                                                                }, "OVERVIEW");
                                                                    }),
                                                                  key: "overview"
                                                                }), React.createElement(React$1.Tab, {
                                                                  className: "control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300 dark:dark-tab-button",
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "" + (
                                                                                    props.selected ? "bg-300 text-900 dark:dark-tab-selected" : ""
                                                                                  ) + " w-full h-full control-color flex items-center justify-center py-2 font-semibold"
                                                                                }, "CASTS");
                                                                    }),
                                                                  key: "casts"
                                                                }), React.createElement(React$1.Tab, {
                                                                  className: "control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300 dark:dark-tab-button",
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "" + (
                                                                                    props.selected ? "bg-300 text-900 dark:dark-tab-selected" : ""
                                                                                  ) + " w-full h-full control-color flex items-center justify-center py-2 font-semibold"
                                                                                }, "VIDEOS");
                                                                    }),
                                                                  key: "videos"
                                                                }), React.createElement(React$1.Tab, {
                                                                  className: "control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300 dark:dark-tab-button",
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "" + (
                                                                                    props.selected ? "bg-300 text-900 dark:dark-tab-selected" : ""
                                                                                  ) + " w-full h-full control-color flex items-center justify-center py-2 font-semibold"
                                                                                }, "PHOTOS");
                                                                    }),
                                                                  key: "photos"
                                                                }));
                                                })
                                            }), React.createElement(React$1.Tab.Panels, {
                                              className: "pt-1",
                                              children: (function (props) {
                                                  return React.createElement(React.Fragment, undefined, React.createElement(React$1.Tab.Panel, {
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "flex w-full p-2"
                                                                                }, React.createElement(StorylinePanel.make, {
                                                                                      movie: detail_movie
                                                                                    }));
                                                                    }),
                                                                  key: "overview-panel"
                                                                }), React.createElement(React$1.Tab.Panel, {
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "flex w-full p-2"
                                                                                }, React.createElement(Casts.make, {
                                                                                      movie: detail_movie
                                                                                    }));
                                                                    }),
                                                                  key: "casts-panel"
                                                                }), React.createElement(React$1.Tab.Panel, {
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "flex w-full p-2"
                                                                                }, React.createElement(VideoPanel.make, {
                                                                                      movie: detail_movie
                                                                                    }));
                                                                    }),
                                                                  key: "videos-panel"
                                                                }), React.createElement(React$1.Tab.Panel, {
                                                                  children: (function (props) {
                                                                      return React.createElement("div", {
                                                                                  className: "flex w-full p-2"
                                                                                }, React.createElement(PhotosPanel.make, {
                                                                                      movie: detail_movie
                                                                                    }));
                                                                    }),
                                                                  key: "photos-panel"
                                                                }));
                                                })
                                            }));
                            })
                        }), movieId !== undefined && !Util.isEmptyArray(Belt_Option.getWithDefault(match.recommendedMovies.results, [])) ? React.createElement("div", {
                            className: "w-full flex flex-col justify-center items-center p-2 pt-8 gap-2"
                          }, React.createElement("span", {
                                className: "text-900 text-[1.2rem] font-semibold text-left w-full pb-2 dark:dark-text"
                              }, "MORE LIKE THIS"), React.createElement(MoreLikeThis.make, {
                                movieId: movieId
                              })) : null))), React.createElement(ModalDialog.make, {
              isOpen: videoPlayState.playing,
              onClose: (function (param) {
                  Curry._1(stop, undefined);
                }),
              className: "relative z-50",
              panelClassName: "w-full h-full transform overflow-hidden transition-all",
              children: null
            }, React.createElement("div", {
                  onClick: (function (param) {
                      Curry._1(stop, undefined);
                    })
                }, React.createElement(Outline.XIcon, {
                      className: "absolute z-50 top-0 right-4 w-8 h-8 p-2 border-2 border-slate-400 fill-white stroke-white hover:bg-slate-500 rounded-full bg-slate-900"
                    })), React.createElement(Youtube, {
                  url: videoPlayState.url,
                  playing: videoPlayState.playing,
                  controls: true,
                  width: "" + (windowSize.width - 32 | 0).toString() + "px",
                  height: "" + (windowSize.height - 32 | 0).toString() + "px"
                })));
  }
  return React.createElement(React.Fragment, undefined, tmp, error.length > 0 ? React.createElement(ErrorDialog.make, {
                    isOpen: error.length > 0,
                    errorMessage: error,
                    onClose: onClose
                  }) : null);
}

var make = Movie;

export {
  string ,
  make ,
}
/* Hero Not a pure module */
