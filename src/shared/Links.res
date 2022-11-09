let apiBaseUrl = "https://api.themoviedb.org"
let apiVersion = "3"

let imageBaseUrl = "https://image.tmdb.org/t/p"
let originalImageBaseUrl = `${imageBaseUrl}/original`

let getPosterImageW342Link = (seg: string) => `${imageBaseUrl}/w342/${seg}`
let getOriginalBigImage = (seg: string) => `${originalImageBaseUrl}/${seg}`
let getHeroImage = (seg: string) => `${imageBaseUrl}/w780/${seg}`

let getImdbLink = (id: string) => `https://www.imdb.com/title/${id}`
let getTwitterLink = (id: string) => `https://twitter.com/${id}`
let getFacebookLink = (id: string) => `https://www.facebook.com/${id}`
let getInstagramLink = (id: string) => `https://instagram.com/${id}`

let getYoutubeImageLink = (id: string) => `https://img.youtube.com/vi/${id}/mqdefault.jpg`

let placeholderImage = "/assets/nothing.svg"

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
