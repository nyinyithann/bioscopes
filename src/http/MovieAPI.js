// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Links from "../shared/Links.js";
import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as $$Promise from "@ryyppy/rescript-promise/src/Promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var contentType = [
  "Content-type",
  "application/json"
];

var authorization_1 = "Bearer " + process.env.NEXT_PUBLIC_TMDB_API_READ_ACCESS_TOKEN + "";

var authorization = [
  "Authorization",
  authorization_1
];

function checkResponseStatus(promise) {
  return promise.then(function (response) {
              if (response.ok) {
                return Promise.resolve({
                            TAG: /* Ok */0,
                            _0: response.json()
                          });
              } else {
                return Promise.resolve({
                            TAG: /* Error */1,
                            _0: response.json()
                          });
              }
            });
}

function catchPromiseFault(promise) {
  return $$Promise.$$catch(promise, (function (e) {
                if (e.RE_EXN_ID !== Js_exn.$$Error) {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: Promise.resolve("Unexpected Promise Fault!")
                            });
                }
                var msg = e._1.message;
                if (msg === undefined) {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: Promise.resolve("Unexpected Promise Fault!")
                            });
                }
                var tmp;
                try {
                  tmp = JSON.parse(msg);
                }
                catch (exn){
                  tmp = "Unexpected Promise Fault!";
                }
                return Promise.resolve({
                            TAG: /* Error */1,
                            _0: Promise.resolve(tmp)
                          });
              }));
}

function handleResponse(promise, callback, param) {
  return promise.then(function (result) {
              if (result.TAG === /* Ok */0) {
                result._0.then(function (data) {
                      Curry._1(callback, {
                            TAG: /* Ok */0,
                            _0: data
                          });
                      return Promise.resolve(undefined);
                    });
              } else {
                result._0.then(function (err) {
                      Curry._1(callback, {
                            TAG: /* Error */1,
                            _0: err
                          });
                      return Promise.resolve(undefined);
                    });
              }
              return Promise.resolve(undefined);
            });
}

function getMovies(apiPath, callback, signal, param) {
  return handleResponse(catchPromiseFault(checkResponseStatus(fetch(apiPath, {
                          method: "GET",
                          headers: Caml_option.some(new Headers([
                                    contentType,
                                    authorization
                                  ])),
                          signal: signal
                        }))), callback, undefined);
}

function getGenres(callback, signal, param) {
  var apiPath = "" + Links.apiBaseUrl + "/" + Links.apiVersion + "/genre/movie/list";
  return handleResponse(catchPromiseFault(checkResponseStatus(fetch(apiPath, {
                          method: "GET",
                          headers: Caml_option.some(new Headers([
                                    contentType,
                                    authorization
                                  ])),
                          signal: signal
                        }))), callback, undefined);
}

export {
  contentType ,
  authorization ,
  checkResponseStatus ,
  catchPromiseFault ,
  handleResponse ,
  getMovies ,
  getGenres ,
}
/* authorization Not a pure module */
