// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var timeoutId = {
  contents: undefined
};

var valRef = {
  contents: ""
};

function useDebounce(delay, value) {
  var match = React.useState(function () {
        return value;
      });
  var setDebouncedValue = match[1];
  var $$clearTimeout$1 = function (param) {
    var id = timeoutId.contents;
    if (id !== undefined) {
      clearTimeout(Caml_option.valFromOption(id));
      return ;
    }
    
  };
  React.useEffect((function () {
          debugger;
          $$clearTimeout$1(undefined);
          timeoutId.contents = Caml_option.some(setTimeout((function (param) {
                      debugger;
                      Curry._1(setDebouncedValue, (function (param) {
                              return value;
                            }));
                    }), delay));
          return (function (param) {
                    $$clearTimeout$1(undefined);
                  });
        }), [
        delay,
        value
      ]);
  return match[0];
}

export {
  timeoutId ,
  valRef ,
  useDebounce ,
}
/* react Not a pure module */
