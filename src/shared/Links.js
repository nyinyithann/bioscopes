// Generated by ReScript, PLEASE EDIT WITH CARE


var imageBaseUrl = "https://image.tmdb.org/t/p";

var originalImageBaseUrl = "" + imageBaseUrl + "/original";

function getPosterImageW342Link(seg) {
  return "" + imageBaseUrl + "/w342/" + seg + "";
}

function getOriginalBigImage(seg) {
  return "" + originalImageBaseUrl + "/" + seg + "";
}

function getHeroImage(seg) {
  return "" + imageBaseUrl + "/w780/" + seg + "";
}

var apiBaseUrl = "https://api.themoviedb.org";

var apiVersion = "3";

var placeholderImage = "/assets/nothing.svg";

export {
  apiBaseUrl ,
  apiVersion ,
  imageBaseUrl ,
  originalImageBaseUrl ,
  getPosterImageW342Link ,
  getOriginalBigImage ,
  getHeroImage ,
  placeholderImage ,
}
/* No side effect */
