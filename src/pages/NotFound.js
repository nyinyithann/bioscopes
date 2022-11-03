// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as RescriptReactRouter from "@rescript/react/src/RescriptReactRouter.js";

function string(prim) {
  return prim;
}

function NotFound(Props) {
  return React.createElement("div", {
              className: "w-full h-full flex flex-col items-center justify-center font-medium text-center text-slate-600"
            }, React.createElement("span", {
                  className: "text-[10rem] md:text-[16rem] text-500"
                }, "404"), React.createElement("span", {
                  className: "text-900 pb-5 text-[1.2rem] dark:text-slate-200"
                }, "Hmm... this page doesn't exist. Please go to the home page by clicking\n        the button below."), React.createElement("button", {
                  className: "font-nav font-medium text-900 text-[2rem] py-2 px-7 rounded-lg cursor hover:bg-400 bg-300 dark:text-slate-200 dark:bg-slate-600 dark:hover:bg-slate-700",
                  type: "button",
                  onClick: (function (param) {
                      RescriptReactRouter.push("/");
                    })
                }, "Home"));
}

var make = NotFound;

export {
  string ,
  make ,
}
/* react Not a pure module */
