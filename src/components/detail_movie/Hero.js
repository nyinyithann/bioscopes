// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Util from "../../shared/Util.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Links from "../../shared/Links.js";
import * as React from "react";
import * as Rating from "../Rating.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as MediaQuery from "../../hooks/MediaQuery.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as React$1 from "@headlessui/react";
import * as YoutubePlayerProvider from "../../providers/YoutubePlayerProvider.js";
import * as Solid from "@heroicons/react/solid";
import * as Outline from "@heroicons/react/outline";

function string(prim) {
  return prim;
}

function $$int(prim) {
  return prim;
}

function $$float(prim) {
  return prim;
}

function array(prim) {
  return prim;
}

function Hero$HeroText(Props) {
  var movie = Props.movie;
  var textColor = Props.textColor;
  var title = Util.getOrEmptyString(movie.title);
  var name = Util.getOrEmptyString(movie.name);
  var voteAverage = String(Util.getOrIntZero(movie.vote_count));
  var releaseYear = Util.getOrEmptyString(movie.release_date).substring(0, 4);
  var x = movie.runtime;
  var runtime;
  if (x !== undefined) {
    var t = x | 0;
    runtime = t === 0 ? "" : "" + Util.itos(t / 60 | 0) + "h " + Util.itos(t % 60) + "min";
  } else {
    runtime = "";
  }
  return React.createElement("div", {
              className: "flex flex-col w-full p-[0.6rem] gap-2 " + textColor + ""
            }, Util.isEmptyString(name) ? React.createElement("span", {
                    className: "font-nav text-[2rem] md:text-[3rem]"
                  }, title) : React.createElement("span", {
                    className: "font-nav text-[2rem] md:text-[3rem]"
                  }, name), React.createElement("div", {
                  className: "flex w-full gap-4"
                }, React.createElement(Rating.make, {
                      ratingValue: movie.vote_average
                    }), React.createElement("span", undefined, "" + voteAverage + " Reviews")), React.createElement("div", {
                  className: "flex w-full gap-4"
                }, React.createElement("span", undefined, releaseYear), React.createElement("span", undefined, runtime)));
}

var HeroText = {
  make: Hero$HeroText
};

function getTrailerVideo(movie) {
  try {
    return Belt_Option.getExn(Belt_Option.getExn(Belt_Option.map(movie.videos, (function (videos) {
                          return Belt_Option.map(videos.results, (function (results) {
                                        return Belt_Array.getBy(results, (function (x) {
                                                      return Util.getOrEmptyString(x.type_).toLowerCase().includes("trailer");
                                                    }));
                                      }));
                        }))));
  }
  catch (exn){
    return ;
  }
}

function Hero$WatchTrailerSmallButton(Props) {
  var movie = Props.movie;
  var video = getTrailerVideo(movie);
  var match = YoutubePlayerProvider.useVideoPlayerContext(undefined);
  if (video === undefined) {
    return null;
  }
  var play = match.play;
  var vkey = video.key;
  if (vkey !== undefined) {
    return React.createElement("button", {
                className: "absolute top-0 left-0 bottom-0 right-0 flex items-center justify-center group",
                type: "button",
                onClick: (function (e) {
                    e.preventDefault();
                    Curry._1(play, Links.getYoutubeVideoLink(vkey));
                  })
              }, React.createElement(Outline.PlayIcon, {
                    className: "h-14 w-14 transition-all sm:h-16 sm:w-16 stroke-[1px] stroke-slate-100 group-hover:stroke-klor-400 group-hover:cursor-pointer"
                  }));
  } else {
    return null;
  }
}

var WatchTrailerSmallButton = {
  make: Hero$WatchTrailerSmallButton
};

function Hero$WatchTrailerButton(Props) {
  var movie = Props.movie;
  var video = getTrailerVideo(movie);
  var match = YoutubePlayerProvider.useVideoPlayerContext(undefined);
  if (video === undefined) {
    return null;
  }
  var play = match.play;
  var vkey = video.key;
  if (vkey !== undefined) {
    return React.createElement("button", {
                className: "flex gap-2 px-6 py-2 border-[1px] border-slate-400 backdrop-filter backdrop-blur-xl  text-white rounded-sm group mr-auto hover:bg-klor-400 hover:text-black transition-all",
                type: "button",
                onClick: (function (e) {
                    e.preventDefault();
                    Curry._1(play, Links.getYoutubeVideoLink(vkey));
                  })
              }, React.createElement(Solid.PlayIcon, {
                    className: "h-6 w-6 fill-white group-hover:fill-black"
                  }), React.createElement("span", undefined, "Watch Trailer"));
  } else {
    return null;
  }
}

var WatchTrailerButton = {
  make: Hero$WatchTrailerButton
};

function Hero(Props) {
  var movie = Props.movie;
  var match = React.useState(function () {
        return false;
      });
  var setLoaded = match[1];
  var loaded = match[0];
  var imgPathRef = React.useRef("");
  var match$1 = React.useState(function () {
        return {
                width: 100,
                height: 18
              };
      });
  var setSize = match$1[1];
  var size = match$1[0];
  var isMobile = MediaQuery.useMediaQuery("(max-width: 600px)");
  var isSmallScreen = MediaQuery.useMediaQuery("(max-width: 700px)");
  var isMediumScreen = MediaQuery.useMediaQuery("(max-width: 1000px)");
  var isLargeScreen = MediaQuery.useMediaQuery("(max-width: 1300px)");
  var isVeryLargeScreen = MediaQuery.useMediaQuery("(min-width: 1500px)");
  React.useLayoutEffect((function () {
          if (isMobile) {
            Curry._1(setSize, (function (param) {
                    return {
                            width: 100,
                            height: 14
                          };
                  }));
          } else if (isSmallScreen) {
            Curry._1(setSize, (function (param) {
                    return {
                            width: 100,
                            height: 24
                          };
                  }));
          } else if (isMediumScreen) {
            Curry._1(setSize, (function (param) {
                    return {
                            width: 100,
                            height: 28
                          };
                  }));
          } else if (isLargeScreen) {
            Curry._1(setSize, (function (param) {
                    return {
                            width: 70,
                            height: 32
                          };
                  }));
          } else if (isVeryLargeScreen) {
            Curry._1(setSize, (function (param) {
                    return {
                            width: 70,
                            height: 46
                          };
                  }));
          } else {
            Curry._1(setSize, (function (param) {
                    return {
                            width: 70,
                            height: 34
                          };
                  }));
          }
        }), [
        isMobile,
        isSmallScreen,
        isMediumScreen,
        isLargeScreen,
        isVeryLargeScreen
      ]);
  React.useMemo((function () {
          var seg = Util.getOrEmptyString(movie.backdrop_path);
          imgPathRef.current = Util.isEmptyString(seg) ? seg : Links.getOriginalBigImage(seg);
        }), [movie]);
  var match$2 = React.useState(function () {
        return false;
      });
  var setShowHeroText = match$2[1];
  var tagline = Util.getOrEmptyString(movie.tagline);
  var imageStyle = {
    height: "" + size.height.toString() + "rem",
    width: "" + size.width.toString() + "vw"
  };
  var sotryline = Util.toStringElement(Util.getOrEmptyString(movie.overview));
  return React.createElement("div", {
              className: "flex w-full"
            }, React.createElement("div", {
                  className: "flex flex-col w-full"
                }, React.createElement("div", {
                      className: "relative flex flex-col w-full"
                    }, Util.isEmptyString(tagline) ? null : React.createElement("span", {
                            className: "" + (
                              size.width === 100 ? "bottom-0 left-0 text-[1rem] rounded-tr-full p-1 pr-4" : "top-0 left-0 text-[1.2rem] rounded-br-full p-1 pr-8"
                            ) + " absolute z-50 w-auto font-nav font-extrabold text-600 bg-gray-100 bg-clip-padding backdrop-filter backdrop-blur-xl bg-opacity-80"
                          }, Util.toStringElement(tagline)), size.width === 100 ? React.createElement("div", {
                            className: "relative flex-inline"
                          }, React.createElement("img", {
                                className: "w-full transition duration-1000 ml-auto z-0 " + (
                                  loaded ? "opacity-100" : "opacity-0"
                                ) + "",
                                style: imageStyle,
                                alt: "poster",
                                src: imgPathRef.current,
                                onError: (function (e) {
                                    Curry._1(setShowHeroText, (function (param) {
                                            return true;
                                          }));
                                    if (e.target.src !== Links.placeholderImage) {
                                      e.target.src = Links.placeholderImage;
                                      return ;
                                    }
                                    
                                  }),
                                onLoad: (function (e) {
                                    Curry._1(setLoaded, (function (param) {
                                            return true;
                                          }));
                                  })
                              }), React.createElement(Hero$WatchTrailerSmallButton, {
                                movie: movie
                              })) : null, size.width !== 100 ? React.createElement("div", {
                            className: "z-0 relative flex w-full h-full bg-black transition-all duration-300",
                            id: "top-overlayed-image-container"
                          }, React.createElement("div", {
                                className: "relative z-10 ml-auto after:absolute after:top-0 after:left-0 after:bg-gradient-title after:z-20 after:w-full after:h-full",
                                id: "overlayed-image-container",
                                style: imageStyle
                              }, React.createElement("img", {
                                    className: "w-full ml-auto z-0 transition duration-1000 " + (
                                      loaded ? "opacity-100" : "opacity-0"
                                    ) + "",
                                    style: imageStyle,
                                    alt: "poster",
                                    src: Util.isEmptyString(imgPathRef.current) ? "" : imgPathRef.current,
                                    onError: (function (e) {
                                        Curry._1(setShowHeroText, (function (param) {
                                                return true;
                                              }));
                                        if (e.target.src !== Links.placeholderImage) {
                                          e.target.src = Links.placeholderImage;
                                          return ;
                                        }
                                        
                                      }),
                                    onLoad: (function (e) {
                                        Curry._1(setLoaded, (function (param) {
                                                return true;
                                              }));
                                      })
                                  })), React.createElement("div", {
                                className: "absolute top-[14%] left-[6%] z-50"
                              }, React.createElement(React$1.Transition, {
                                    show: loaded || match$2[0],
                                    as_: "div",
                                    enter: "transition ease duration-700 transform",
                                    enterFrom: "opacity-0 -translate-y-full",
                                    enterTo: "opacity-100 translate-y-0",
                                    leave: "transition ease duration-1000 transform",
                                    leaveFrom: "opacity-100 translate-y-0",
                                    leaveTo: "opacity-0 -translate-y-full",
                                    children: null
                                  }, React.createElement(Hero$HeroText, {
                                        movie: movie,
                                        textColor: "text-white"
                                      }), React.createElement("span", {
                                        className: "break-words w-full flex text-white prose pl-2 pt-2 line-clamp-6"
                                      }, sotryline), React.createElement("div", {
                                        className: "flex pl-2 pt-[2rem]"
                                      }, React.createElement(Hero$WatchTrailerButton, {
                                            movie: movie
                                          }))))) : null), size.width === 100 ? React.createElement(Hero$HeroText, {
                        movie: movie,
                        textColor: "text-900"
                      }) : null));
}

var make = Hero;

export {
  string ,
  $$int ,
  $$float ,
  array ,
  HeroText ,
  getTrailerVideo ,
  WatchTrailerSmallButton ,
  WatchTrailerButton ,
  make ,
}
/* react Not a pure module */
