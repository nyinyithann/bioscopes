let {string, int, float, array} = module(React)
module HeroText = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie, ~textColor: string) => {
    let title = Util.getOrEmptyString(movie.title)
    let voteAverage = Util.getOrIntZero(movie.vote_count)->string_of_int
    let releaseYear =
      Util.getOrEmptyString(movie.release_date)->Js.String2.substring(~from=0, ~to_=4)
    let runtime = switch movie.runtime {
    | Some(x) => {
        let t = int_of_float(x)
        `${(t / 60)->Util.itos}h ${mod(t, 60)->Util.itos}min`
      }

    | None => ""
    }

    <div className={`flex flex-col w-full p-[0.6rem] gap-2 ${textColor}`}>
      <span className="font-nav text-[2rem]"> {title->string} </span>
      <div className="flex w-full gap-4">
        <Rating ratingValue={movie.vote_average} />
        <span> {`${voteAverage} Reviews`->string} </span>
      </div>
      <div className="flex w-full gap-4">
        <span> {releaseYear->string} </span>
        <span> {runtime->string} </span>
      </div>
    </div>
  }
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let (loaded, setLoaded) = React.useState(_ => false)

  let isMobile = MediaQuery.useMediaQuery("(max-width: 600px)")
  let isSmallScreen = MediaQuery.useMediaQuery("(max-width: 700px)")
  let isMediumScreen = MediaQuery.useMediaQuery("(max-width: 1000px)")
  let isLargeScreen = MediaQuery.useMediaQuery("(max-width: 1300px)")
  let isVeryLargeScreen = MediaQuery.useMediaQuery("(min-width: 1500px)")

  let imgPathRef = React.useRef("")
  let imgHeightRef = React.useRef(18)
  let imgWidthRef = React.useRef(100)

  React.useMemo1(() => {
    imgPathRef.current = Links.getOriginalBigImage(Util.getOrEmptyString(movie.backdrop_path))
  }, [movie])

  React.useLayoutEffect6(() => {
    if isMobile {
      imgHeightRef.current = 16
      imgWidthRef.current = 100
    } else if isSmallScreen {
      imgHeightRef.current = 26
      imgWidthRef.current = 100
    } else if isMediumScreen {
      imgHeightRef.current = 28
      imgWidthRef.current = 100
    } else if isLargeScreen {
      imgHeightRef.current = 34
      imgWidthRef.current = 70
    } else if isVeryLargeScreen {
      imgHeightRef.current = 46
      imgWidthRef.current = 70
    } else {
      imgHeightRef.current = 34
      imgWidthRef.current = 70
    }
    None
  }, (movie, isMobile, isSmallScreen, isMediumScreen, isLargeScreen, isVeryLargeScreen))

  let tagline = Util.getOrEmptyString(movie.tagline)

  let imageStyle = ReactDOM.Style.make(
    ~width=`${imgWidthRef.current->Js.Int.toString}vw`,
    ~height=`${imgHeightRef.current->Js.Int.toString}rem`,
    (),
  )

  let sotryline = Util.getOrEmptyString(movie.overview)->Util.toStringElement

  <div className="flex w-full">
    <div className="flex flex-col w-full">
      <div className="relative flex flex-col w-full">
        {Util.isEmptyString(tagline)
          ? React.null
          : <span
              className={`${imgWidthRef.current == 100
                  ? "bottom-0 left-0 text-[1.1rem] rounded-tr-full pr-4"
                  : "top-0 left-0 text-[1.4rem] rounded-br-full pr-8"} absolute z-50 p-1 w-auto font-nav font-extrabold text-500 bg-slate-100 bg-clip-padding backdrop-filter backdrop-blur-xl bg-opacity-20`}>
              {Util.toStringElement(tagline)}
            </span>}
        {imgWidthRef.current == 100
          ? <img
              alt="Poster"
              className="w-full transition transform ease-in-out duration-100 ml-auto z-0"
              src={imgPathRef.current}
              style={imageStyle}
              onLoad={_ => setLoaded(_ => true)}
              onError={e => {
                open ReactEvent.Media
                if target(e)["src"] !== Links.placeholderImage {
                  target(e)["src"] = Links.placeholderImage
                }
              }}
            />
          : React.null}
        {imgWidthRef.current != 100
          ? <div
              id="top-overlayed-image-container"
              className="z-0 relative flex w-full h-full bg-black">
              <div
                id="overlayed-image-container"
                style={imageStyle}
                className="relative z-10 ml-auto after:absolute after:top-0 after:left-0 after:bg-gradient-title after:z-20 after:w-full after:h-full ">
                <img
                  alt="Poster"
                  className="w-full transition transform ease-in-out duration-100 ml-auto z-0"
                  src={imgPathRef.current}
                  style={imageStyle}
                  onLoad={_ => setLoaded(_ => true)}
                  onError={e => {
                    open ReactEvent.Media
                    if target(e)["src"] !== Links.placeholderImage {
                      target(e)["src"] = Links.placeholderImage
                    }
                  }}
                />
              </div>
              <div className="absolute top-[20%] left-[6%] z-50">
                <HeroText movie textColor="text-white" />
                <span className="break-words w-full flex text-white prose pl-2 pt-2"> sotryline </span>
              </div>
            </div>
          : React.null}
        {!loaded
          ? <div
              className={`absolute top-[${(imgHeightRef.current / 2)
                  ->Js.Int.toString}rem)] w-full h-full flex flex-col items-center justify-center`}>
              <Loading
                className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
              />
            </div>
          : React.null}
      </div>
      {imgWidthRef.current == 100 ? <HeroText movie textColor="text-900" /> : React.null}
    </div>
  </div>
}
