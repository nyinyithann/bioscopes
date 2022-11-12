// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Loading from "./Loading.js";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as MediaQuery from "../hooks/MediaQuery.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import ReactLazyLoad from "react-lazy-load";

function LazyImage$LazyLoadWrapper(Props) {
  var enabled = Props.enabled;
  var height = Props.height;
  var offset = Props.offset;
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, enabled ? React.createElement(ReactLazyLoad, {
                    children: children,
                    offset: offset,
                    height: height
                  }) : React.createElement(React.Fragment, undefined, children));
}

var LazyLoadWrapper = {
  make: LazyImage$LazyLoadWrapper
};

function LazyImage(Props) {
  var className = Props.className;
  var lazyLoadEnabled = Props.lazyLoadEnabled;
  var lazyLoadOffset = Props.lazyLoadOffset;
  var width = Props.width;
  var height = Props.height;
  var sm_width = Props.sm_width;
  var sm_height = Props.sm_height;
  var sm_mediaQuery = Props.sm_mediaQuery;
  var alt = Props.alt;
  var placeholderPath = Props.placeholderPath;
  var src = Props.src;
  var match = React.useState(function () {
        return false;
      });
  var setLoaded = match[1];
  var match$1 = React.useState(function () {
        return false;
      });
  var setErr = match$1[1];
  var isMobile = MediaQuery.useMediaQuery(Js_option.getWithDefault("(max-width: 600px)", sm_mediaQuery));
  var cn = isMobile ? "w-[" + Js_option.getWithDefault(0, width).toString() + "px] h-[" + Js_option.getWithDefault(0, height).toString() + "px] " + Js_option.getWithDefault("", className) + "" : "w-[" + Js_option.getWithDefault(0, sm_width).toString() + "px] h-[" + Js_option.getWithDefault(0, sm_height).toString() + "px] " + Js_option.getWithDefault("", className) + "";
  var w = (
      isMobile ? Js_option.getWithDefault(0, width) : Js_option.getWithDefault(0, sm_width)
    ).toString();
  var h = (
      isMobile ? Js_option.getWithDefault(0, height) : Js_option.getWithDefault(0, sm_height)
    ).toString();
  var cn$1 = "" + (
    match$1[0] ? "object-fit" : "object-cover"
  ) + " " + Js_option.getWithDefault("", className) + " " + cn + "";
  var imgStyle = {
    height: "" + h + "px",
    width: "" + w + "px"
  };
  var tmp = {
    className: cn$1,
    style: imgStyle,
    src: src,
    onError: (function (e) {
        Curry._1(setErr, (function (param) {
                return true;
              }));
        if (e.target.src !== placeholderPath) {
          e.target.src = placeholderPath;
          return ;
        }
        
      }),
    onLoad: (function (param) {
        Curry._1(setLoaded, (function (param) {
                return true;
              }));
      })
  };
  if (alt !== undefined) {
    tmp.alt = Caml_option.valFromOption(alt);
  }
  return React.createElement("div", {
              className: "flex relative"
            }, match[0] ? null : React.createElement("div", {
                    className: "absolute top-[calc(h /. 2.)] w-full h-full flex flex-col items-center justify-center animate-pulse bg-50"
                  }, React.createElement(Loading.make, {
                        className: "w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
                      })), React.createElement(LazyImage$LazyLoadWrapper, {
                  enabled: Js_option.getWithDefault(false, lazyLoadEnabled),
                  height: isMobile ? Js_option.getWithDefault(0, height) : Js_option.getWithDefault(0, sm_height),
                  offset: Js_option.getWithDefault(0, lazyLoadOffset),
                  children: React.createElement("img", tmp)
                }));
}

var make = LazyImage;

export {
  LazyLoadWrapper ,
  make ,
}
/* react Not a pure module */