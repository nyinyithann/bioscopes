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

let getImdbLink = (id: string) => `https://www.imdb.com/title/${id}`
let getTwitterLink = (id: string) => `https://twitter.com/${id}`
let getFacebookLink = (id: string) => `https://www.facebook.com/${id}`
let getInstagramLink = (id: string) => `https://instagram.com/${id}`

let getYoutubeImageLink = (id: string) => `https://img.youtube.com/vi/${id}/mqdefault.jpg`

let placeholderImage = "/assets/nothing.svg"

let getYoutubeVideoLink = key => `https://youtu.be/${key}`

/* Rendered size:	198 × 297 px */
/* Rendered aspect ratio:	2∶3 */
/* Intrinsic size:	370 × 556 px */
/* Intrinsic aspect ratio:	185∶278 */
/* File size:	39.6 kB */
/* Current source:	https://image.tmdb.org/t/p/w370_and_h556_bestv2/2miJH1JWJdVw4AMV6Q0IcTNrWmO.jpg */
/*  */

//https://youtu.be/mkomfZHG5q4
// https://youtu.be/0RnGge4t_ZU
// https://youtu.be/wajuHqcA_Rg
/* https://api.themoviedb.org/3/search/multi?api_key=8235fd73c07d8e61320d0df784562bb2&language=en-US&query=breaking+bad&page=1 */
/*
 "backdrop_sizes": [
            "w300",
            "w780",
            "w1280",
            "original"
        ],
        "logo_sizes": [
            "w45",
            "w92",
            "w154",
            "w185",
            "w300",
            "w500",
            "original"
        ],
        "poster_sizes": [
            "w92",
            "w154",
            "w185",
            "w342",
            "w500",
            "w780",
            "original"
        ],
        "profile_sizes": [
            "w45",
            "w185",
            "h632",
            "original"
        ],
        "still_sizes": [
            "w92",
            "w185",
            "w300",
            "original"
        ]
*/
