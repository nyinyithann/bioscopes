// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Util from "../../shared/Util.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Links from "../../shared/Links.js";
import * as React from "react";
import * as Rating from "../Rating.js";
import * as Loading from "../Loading.js";
import * as MediaQuery from "../../hooks/MediaQuery.js";

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
    runtime = "" + Util.itos(t / 60 | 0) + "h " + Util.itos(t % 60) + "min";
  } else {
    runtime = "";
  }
  return React.createElement("div", {
              className: "flex flex-col w-full p-[0.6rem] gap-2 " + textColor + ""
            }, Util.isEmptyString(name) ? React.createElement("span", {
                    className: "font-nav text-[2rem]"
                  }, title) : React.createElement("span", {
                    className: "font-nav text-[2rem]"
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

function Hero(Props) {
  var movie = Props.movie;
  var match = React.useState(function () {
        return false;
      });
  var setLoaded = match[1];
  var imgPathRef = React.useRef("");
  var match$1 = React.useState(function () {
        return {
                width: 100,
                height: 18
              };
      });
  var setSize = match$1[1];
  var size = match$1[0];
  React.useMemo((function () {
          imgPathRef.current = Links.getOriginalBigImage(Util.getOrEmptyString(movie.backdrop_path));
        }), [movie]);
  var updateLayout = function (param) {
    var isMobile = MediaQuery.matchMedia("(max-width: 600px)");
    var isSmallScreen = MediaQuery.matchMedia("(max-width: 700px)");
    var isMediumScreen = MediaQuery.matchMedia("(max-width: 1000px)");
    var isLargeScreen = MediaQuery.matchMedia("(max-width: 1300px)");
    var isVeryLargeScreen = MediaQuery.matchMedia("(min-width: 1500px)");
    if (isMobile) {
      return Curry._1(setSize, (function (param) {
                    return {
                            width: 100,
                            height: 16
                          };
                  }));
    } else if (isSmallScreen) {
      return Curry._1(setSize, (function (param) {
                    return {
                            width: 100,
                            height: 26
                          };
                  }));
    } else if (isMediumScreen) {
      return Curry._1(setSize, (function (param) {
                    return {
                            width: 100,
                            height: 30
                          };
                  }));
    } else if (isLargeScreen) {
      return Curry._1(setSize, (function (param) {
                    return {
                            width: 70,
                            height: 32
                          };
                  }));
    } else if (isVeryLargeScreen) {
      return Curry._1(setSize, (function (param) {
                    return {
                            width: 70,
                            height: 46
                          };
                  }));
    } else {
      return Curry._1(setSize, (function (param) {
                    return {
                            width: 70,
                            height: 34
                          };
                  }));
    }
  };
  var handleWindowSizeChange = function (param) {
    updateLayout(undefined);
  };
  React.useEffect((function () {
          updateLayout(undefined);
          window.addEventListener("resize", handleWindowSizeChange);
          return (function (param) {
                    window.removeEventListener("resize", handleWindowSizeChange);
                  });
        }), []);
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
                              size.width === 100 ? "bottom-0 left-0 text-[1.1rem] rounded-tr-full pr-4" : "top-0 left-0 text-[1.4rem] rounded-br-full pr-8"
                            ) + " absolute z-50 p-1 w-auto font-nav font-extrabold text-500 bg-slate-100 bg-clip-padding backdrop-filter backdrop-blur-xl bg-opacity-20"
                          }, Util.toStringElement(tagline)), size.width === 100 ? React.createElement("img", {
                            className: "w-full transition transform ease-in-out duration-100 ml-auto z-0",
                            style: imageStyle,
                            alt: "Poster",
                            src: imgPathRef.current,
                            onError: (function (e) {
                                if (e.target.src !== Links.placeholderImage) {
                                  e.target.src = Links.placeholderImage;
                                  return ;
                                }
                                
                              }),
                            onLoad: (function (param) {
                                Curry._1(setLoaded, (function (param) {
                                        return true;
                                      }));
                              })
                          }) : null, size.width !== 100 ? React.createElement("div", {
                            className: "z-0 relative flex w-full h-full bg-black",
                            id: "top-overlayed-image-container"
                          }, React.createElement("div", {
                                className: "relative z-10 ml-auto after:absolute after:top-0 after:left-0 after:bg-gradient-title after:z-20 after:w-full after:h-full ",
                                id: "overlayed-image-container",
                                style: imageStyle
                              }, React.createElement("img", {
                                    className: "w-full transition transform ease-in-out duration-100 ml-auto z-0",
                                    style: imageStyle,
                                    alt: "Poster",
                                    src: imgPathRef.current,
                                    onError: (function (e) {
                                        if (e.target.src !== Links.placeholderImage) {
                                          e.target.src = Links.placeholderImage;
                                          return ;
                                        }
                                        
                                      }),
                                    onLoad: (function (param) {
                                        Curry._1(setLoaded, (function (param) {
                                                return true;
                                              }));
                                      })
                                  })), React.createElement("div", {
                                className: "absolute top-[20%] left-[6%] z-50"
                              }, React.createElement(Hero$HeroText, {
                                    movie: movie,
                                    textColor: "text-white"
                                  }), React.createElement("span", {
                                    className: "break-words w-full flex text-white prose pl-2 pt-2"
                                  }, sotryline))) : null, match[0] ? null : React.createElement("div", {
                            className: "absolute top-[" + (size.height / 2 | 0).toString() + "rem)] w-full h-full flex flex-col items-center justify-center"
                          }, React.createElement(Loading.make, {
                                className: "w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
                              }))), size.width === 100 ? React.createElement(Hero$HeroText, {
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
  make ,
}
/* react Not a pure module */
