// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Util from "../../shared/Util.js";
import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Js_option from "rescript/lib/es6/js_option.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as JsArray2Ex from "js-array2-ex/src/JsArray2Ex.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as UrlQueryParam from "../../routes/UrlQueryParam.js";
import * as React$1 from "@headlessui/react";

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

var y3000 = new Date("3000-12-31");

function getDateOr3000(stew) {
  var getOrY3000 = function (date) {
    try {
      return new Date(date);
    }
    catch (exn){
      return y3000;
    }
  };
  var match = Util.getOrEmptyString(stew.release_date);
  var match$1 = Util.getOrEmptyString(stew.first_air_date);
  if (match === "" && match$1 === "") {
    return y3000;
  }
  if (match$1 === "") {
    return getOrY3000(match);
  } else if (match === "") {
    return getOrY3000(match$1);
  } else {
    return y3000;
  }
}

function toCredit(stew) {
  return {
          id: Util.getOrIntZero(stew.id),
          title: Util.getOrEmptyString(stew.title),
          name: Util.getOrEmptyString(stew.name),
          character: Util.getOrEmptyString(stew.character),
          department: Util.getOrEmptyString(stew.department),
          job: Util.getOrEmptyString(stew.job),
          episode_count: Util.getOrIntZero(stew.episode_count),
          date: getDateOr3000(stew),
          media_type: Util.getOrEmptyString(stew.media_type)
        };
}

function Credits$CreditItem(Props) {
  var credit = Props.credit;
  var childItem = React.createElement("ul", {
        className: "flex w-full p-1 list-none text-900 px-4 py-2"
      }, React.createElement("li", {
            className: "w-[5rem]"
          }, Caml_obj.equal(credit.date, y3000) ? "-" : credit.date.getFullYear().toString()), React.createElement("li", {
            className: "flex w-full"
          }, React.createElement("p", {
                className: "w-full text-900"
              }, "" + (
                credit.media_type === "movie" ? "" + credit.title + "" : "" + credit.name + ""
              ) + "", credit.episode_count > 0 ? React.createElement("span", {
                      className: "pl-1 text-[0.9rem] text-800/90"
                    }, "(" + credit.episode_count.toString() + " episode)") : null, credit.character !== "" ? React.createElement("span", {
                      className: "pl-1 text-[0.9rem] text-800/90"
                    }, "as " + credit.character + "") : null, credit.job !== "" ? React.createElement("span", {
                      className: "pl-1 text-[0.9rem] text-800/90"
                    }, "as " + credit.job + "") : null)));
  if (credit.media_type !== "movie") {
    return childItem;
  }
  var param_id = credit.id.toString();
  var param_media_type = credit.media_type;
  var param = {
    id: param_id,
    media_type: param_media_type
  };
  var seg = "/movie?" + new URLSearchParams(UrlQueryParam.Converter_movie_tv_param.stringfy(param)).toString();
  return React.createElement("a", {
              className: "hover:text-200",
              href: seg,
              rel: "noopener noreferrer"
            }, childItem);
}

var CreditItem = {
  make: Credits$CreditItem
};

function Credits$CreditGroup(Props) {
  var creditGroup = Props.creditGroup;
  return React.createElement("div", {
              className: "flex flex-col w-full"
            }, React.createElement("div", {
                  className: "flex flex-col w-full divide-y divide-200"
                }, Belt_Array.mapWithIndex(creditGroup, (function (i, param) {
                        return Belt_Array.map(param[1], (function (credit) {
                                      return React.createElement("div", {
                                                  key: credit.id.toString(),
                                                  className: "" + (
                                                    i % 2 === 0 ? "bg-50" : "bg-100"
                                                  ) + ""
                                                }, React.createElement(Credits$CreditItem, {
                                                      credit: credit
                                                    }));
                                    }));
                      }))));
}

var CreditGroup = {
  make: Credits$CreditGroup
};

function Credits(Props) {
  var person = Props.person;
  var creditGroupsRef = React.useRef([]);
  React.useMemo((function () {
          var castList = Belt_Option.getWithDefault(Belt_Option.map(person.combined_credits, (function (c) {
                      return Belt_Array.map(Js_option.getWithDefault([], c.cast), toCredit);
                    })), []);
          var castGroup = JsArray2Ex.groupBy(castList, (function (x) {
                    return {
                            year: x.date.getFullYear(),
                            dept: x.department
                          };
                  })).sort(function (param, param$1) {
                var yd = param$1[0];
                var xd = param[0];
                if (Caml_obj.lessthan(xd, yd)) {
                  return 1;
                } else if (Caml_obj.greaterthan(xd, yd)) {
                  return -1;
                } else {
                  return 0;
                }
              });
          var crewList = Belt_Option.getWithDefault(Belt_Option.map(person.combined_credits, (function (c) {
                      return Belt_Array.map(Js_option.getWithDefault([], c.crew), toCredit);
                    })), []);
          var crewGroups = JsArray2Ex.groupBy(crewList, (function (x) {
                    return {
                            year: x.date.getFullYear(),
                            dept: x.department
                          };
                  })).sort(function (param, param$1) {
                var ykey = param$1[0];
                var xkey = param[0];
                if (xkey.year < ykey.year) {
                  return 1;
                } else if (xkey.year > ykey.year) {
                  return -1;
                } else {
                  return 0;
                }
              });
          creditGroupsRef.current = JsArray2Ex.groupBy(Belt_Array.concat(castGroup, crewGroups), (function (param) {
                  return param[0].dept;
                }));
        }), [person]);
  var getTabHeaderStyle = function (selected) {
    var base = "w-full h-full flex items-start justify-start py-2 border-b-2 border-b-100 text-600";
    if (selected) {
      return base + " border-b-500 font-semibold";
    } else {
      return base;
    }
  };
  return React.createElement("div", {
              className: "flex flex-col w-full gap-4 px-2"
            }, React.createElement("div", {
                  className: "w-full flex flex-col items-center justify-center",
                  id: "credit_info_tab_container"
                }, React.createElement(React$1.Tab.Group, {
                      children: (function (selectedIndex) {
                          return React.createElement("div", {
                                      className: "flex flex-col w-full"
                                    }, React.createElement(React$1.Tab.List, {
                                          className: "flex w-full flex-nowrap items-start justify-start",
                                          children: (function (param) {
                                              return React.createElement("div", {
                                                          className: "flex flex-col w-full items-start justify-start"
                                                        }, Belt_Array.map(JsArray2Ex.chunkBySize(creditGroupsRef.current, 4), (function (x) {
                                                                return React.createElement("div", {
                                                                            className: "flex w-full"
                                                                          }, Belt_Array.map(x, (function (param) {
                                                                                  var key = param[0];
                                                                                  var headerText = key === "" ? "Acting" : key;
                                                                                  return React.createElement(React$1.Tab, {
                                                                                              className: "flex flex-col items-start justify-start w-full h-full outline-none ring-0 px-1",
                                                                                              children: (function (props) {
                                                                                                  return React.createElement("div", {
                                                                                                              className: getTabHeaderStyle(props.selected)
                                                                                                            }, "" + headerText + "");
                                                                                                }),
                                                                                              key: key
                                                                                            });
                                                                                })));
                                                              })));
                                            })
                                        }), React.createElement(React$1.Tab.Panels, {
                                          className: "pt-1",
                                          children: (function (props) {
                                              return Belt_Array.map(creditGroupsRef.current, (function (param) {
                                                            var creditGroup = param[1];
                                                            return React.createElement(React$1.Tab.Panel, {
                                                                        children: (function (props) {
                                                                            return React.createElement("div", {
                                                                                        className: "flex w-full px-1"
                                                                                      }, React.createElement(Credits$CreditGroup, {
                                                                                            creditGroup: creditGroup
                                                                                          }));
                                                                          }),
                                                                        key: "all-credits-panel"
                                                                      });
                                                          }));
                                            })
                                        }));
                        })
                    })));
}

var make = Credits;

export {
  string ,
  $$int ,
  $$float ,
  array ,
  y3000 ,
  getDateOr3000 ,
  toCredit ,
  CreditItem ,
  CreditGroup ,
  make ,
}
/* y3000 Not a pure module */
