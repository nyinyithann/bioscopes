// Generated by ReScript, PLEASE EDIT WITH CARE


var imageBaseUrl = "https://image.tmdb.org/t/p";

var originalImageBaseUrl = "" + imageBaseUrl + "/original";

function getPosterImageW342Link(seg) {
  return "" + imageBaseUrl + "/w342/" + seg + "";
}

function getPosterImageW533H300Bestv2Link(seg) {
  return "" + imageBaseUrl + "/w533_and_h300_bestv2/" + seg + "";
}

function getPosterImage_W370_H556_bestv2Link(seg) {
  return "" + imageBaseUrl + "/w370_and_h556_bestv2\n/" + seg + "";
}

function getOriginalBigImage(seg) {
  return "" + originalImageBaseUrl + "/" + seg + "";
}

function getHeroImage(seg) {
  return "" + imageBaseUrl + "/w780/" + seg + "";
}

function getImdbLink(id) {
  return "https://www.imdb.com/title/" + id + "";
}

function getTwitterLink(id) {
  return "https://twitter.com/" + id + "";
}

function getFacebookLink(id) {
  return "https://www.facebook.com/" + id + "";
}

function getInstagramLink(id) {
  return "https://instagram.com/" + id + "";
}

function getYoutubeImageLink(id) {
  return "https://img.youtube.com/vi/" + id + "/mqdefault.jpg";
}

function getYoutubeVideoLink(key) {
  return "https://youtu.be/" + key + "";
}

var apiBaseUrl = "https://api.themoviedb.org";

var apiVersion = "3";

var placeholderImage = "/assets/nothing.svg";

var heroPlaceholderImage = "/assets/hero_placeholder.svg";

export {
  apiBaseUrl ,
  apiVersion ,
  imageBaseUrl ,
  originalImageBaseUrl ,
  getPosterImageW342Link ,
  getPosterImageW533H300Bestv2Link ,
  getPosterImage_W370_H556_bestv2Link ,
  getOriginalBigImage ,
  getHeroImage ,
  getImdbLink ,
  getTwitterLink ,
  getFacebookLink ,
  getInstagramLink ,
  getYoutubeImageLink ,
  placeholderImage ,
  heroPlaceholderImage ,
  getYoutubeVideoLink ,
}
/* No side effect */
