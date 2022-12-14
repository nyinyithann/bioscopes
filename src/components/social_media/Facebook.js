// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Links from "../../shared/Links.js";
import * as React from "react";

function Facebook(Props) {
  var id = Props.id;
  var className = Props.className;
  if (id === "") {
    return null;
  }
  var lnk = Links.getFacebookLink(id);
  return React.createElement("a", {
              "aria-label": "Link to Facebook",
              href: lnk,
              rel: "noopener",
              target: "_blank"
            }, React.createElement("svg", {
                  className: className,
                  height: "24",
                  width: "24",
                  viewBox: "0 0 24 24",
                  xmlns: "http://www.w3.org/2000/svg"
                }, React.createElement("path", {
                      d: "M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z"
                    })));
}

var make = Facebook;

export {
  make ,
}
/* react Not a pure module */
