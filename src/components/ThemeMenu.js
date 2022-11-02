// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as React$1 from "@headlessui/react";
import * as ThemeSwitchProvider from "../providers/ThemeSwitchProvider.js";
import * as Solid from "@heroicons/react/solid";

function string(prim) {
  return prim;
}

var themeList = [
  {
    category: "gray",
    themes: [
      {
        color: "#000000",
        name: "dark"
      },
      {
        color: "#94A3B8",
        name: "theme-slate"
      },
      {
        color: "#A3A3A3",
        name: "theme-neutral"
      },
      {
        color: "#cccccc",
        name: "theme-lightgray"
      }
    ]
  },
  {
    category: "rose",
    themes: [
      {
        color: "#FB7185",
        name: "theme-rose"
      },
      {
        color: "#F472B6",
        name: "theme-pink"
      },
      {
        color: "#ff9494",
        name: "theme-monalisa"
      },
      {
        color: "#cf9068",
        name: "theme-coffee"
      }
    ]
  },
  {
    category: "orange",
    themes: [
      {
        color: "#FB923C",
        name: "theme-orange"
      },
      {
        color: "#b2ad55",
        name: "theme-olive"
      },
      {
        color: "#FACC15",
        name: "theme-yellow"
      },
      {
        color: "#e8e121",
        name: "theme-sunflower"
      }
    ]
  },
  {
    category: "green",
    themes: [
      {
        color: "#4ADE80",
        name: "theme-green"
      },
      {
        color: "#34D399",
        name: "theme-emerald"
      },
      {
        color: "#2DD4BF",
        name: "theme-teal"
      },
      {
        color: "#A3E635",
        name: "theme-lime"
      }
    ]
  },
  {
    category: "blue",
    themes: [
      {
        color: "#60A5FA",
        name: "theme-blue"
      },
      {
        color: "#38BDF8",
        name: "theme-sky"
      },
      {
        color: "#22D3EE",
        name: "theme-cyan"
      },
      {
        color: "#a2b3d7",
        name: "theme-polo"
      }
    ]
  },
  {
    category: "indigo",
    themes: [
      {
        color: "#818CF8",
        name: "theme-indigo"
      },
      {
        color: "#A78BFA",
        name: "theme-violet"
      },
      {
        color: "#C084FC",
        name: "theme-purple"
      },
      {
        color: "#E879F9",
        name: "theme-fuchsia"
      }
    ]
  }
];

function ThemeMenu$ColorButton(Props) {
  var color = Props.color;
  var theme = Props.theme;
  var onClick = Props.onClick;
  return React.cloneElement(React.createElement("button", {
                  "aria-label": "color",
                  className: "flex h-8 w-8 items-center justify-center rounded-full p-1 shadow shadow-500 hover:ring-2 hover:ring-slate-300 focus:shadow-600 focus:outline-none dark:shadow-xl dark:shadow-gray-800 md:h-6 md:w-6",
                  style: {
                    backgroundColor: color
                  },
                  type: "button",
                  onClick: onClick
                }), {
              "data-theme": theme
            });
}

var ColorButton = {
  make: ThemeMenu$ColorButton
};

function ThemeMenu(Props) {
  var setTheme = React.useContext(ThemeSwitchProvider.themeSwitchContext);
  var onClick = React.useCallback((function (e) {
          Curry._1(setTheme, e.target.getAttribute("data-theme"));
        }), [setTheme]);
  return React.createElement(React$1.Menu, {
              children: React.createElement(React.Fragment, undefined, React.createElement(React$1.Menu.Button, {
                        children: React.createElement(Solid.ColorSwatchIcon, {
                              className: "self-center w-5 h-5 text-900 dark:text-white"
                            }),
                        className: "flex h-8 w-8 items-center justify-center rounded-full border-transparent bg-200 text-700 outline-none ring-0 saturate-150 hover:bg-400 hover:text-white dark:border-[1px] dark:border-slate-400 dark:bg-slate-400 dark:hover:bg-slate-700"
                      }), React.createElement(React$1.Menu.Items, {
                        children: Belt_Array.map(themeList, (function (param) {
                                return React.createElement("div", {
                                            key: param.category,
                                            className: "z-10 flex items-center justify-center bg-300/80 gap-[1rem]"
                                          }, Belt_Array.map(param.themes, (function (param) {
                                                  var name = param.name;
                                                  return React.createElement(React$1.Menu.Item, {
                                                              children: React.createElement(ThemeMenu$ColorButton, {
                                                                    color: param.color,
                                                                    theme: name,
                                                                    onClick: onClick
                                                                  }),
                                                              className: "flex flex-row items-center justify-center gap-2 p-1",
                                                              key: name
                                                            });
                                                })));
                              })),
                        className: "absolute right-1 top-6 mt-3 flex w-[12rem] origin-top-right flex-col rounded bg-300 shadow-md border-[1px] border-200 focus:outline-none dark:border-[1px] dark:border-slate-500 dark:bg-slate-600 md:w-40 gap-[1rem] p-2"
                      })),
              className: "relative z-50 flex items-center justify-center text-left"
            });
}

var make = ThemeMenu;

export {
  string ,
  themeList ,
  ColorButton ,
  make ,
}
/* react Not a pure module */
