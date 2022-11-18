// Generated by ReScript, PLEASE EDIT WITH CARE

import * as App from "./App.js";
import * as React from "react";
import * as ReactDom from "react-dom";

import '../style/main.css';
;

var root = document.querySelector("#root");

if (!(root == null)) {
  var prim0 = React.createElement(App.make, {});
  ReactDom.render(prim0, root);
}

const reportWebVitals = (onPerfEntry) => {
  if (onPerfEntry && onPerfEntry instanceof Function) {
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) => {
      getCLS(onPerfEntry);
      getFID(onPerfEntry);
      getFCP(onPerfEntry);
      getLCP(onPerfEntry);
      getTTFB(onPerfEntry);
    });
  }
};
if (process.env.NODE_ENV === 'development') {
  // eslint-disable-next-line no-console
  //reportWebVitals(console.log);
}
;

export {
  
}
/*  Not a pure module */
