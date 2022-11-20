let apiBaseUrl = "https://api.themoviedb.org"
let apiVersion = "3"

let imageBaseUrl = "https://image.tmdb.org/t/p"
let originalImageBaseUrl = `${imageBaseUrl}/original`

let getPosterImageW342Link = (seg: string) => `${imageBaseUrl}/w342/${seg}`
let getPosterImageW533H300Bestv2Link = (seg: string) =>
  `${imageBaseUrl}/w533_and_h300_bestv2/${seg}`
let getPosterImage_W370_H556_bestv2Link = (seg: string) =>
  `${imageBaseUrl}/w370_and_h556_bestv2
/${seg}`

let getOriginalBigImage = (seg: string) => `${originalImageBaseUrl}/${seg}`
let getHeroImage = (seg: string) => `${imageBaseUrl}/w780/${seg}`

let getImdbLink = (id: string, type_: string) => `https://www.imdb.com/${type_}/${id}`

let getTwitterLink = (id: string) => `https://twitter.com/${id}`
let getFacebookLink = (id: string) => `https://www.facebook.com/${id}`
let getInstagramLink = (id: string) => `https://instagram.com/${id}`

let getYoutubeImageLink = (id: string) => `https://img.youtube.com/vi/${id}/mqdefault.jpg`

let placeholderImage = "/static/nothing.svg"

let getYoutubeVideoLink = key => `https://youtu.be/${key}`
