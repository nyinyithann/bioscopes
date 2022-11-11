let {string, int, float, array} = module(React)
module HeroText = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie, ~textColor: string) => {
    let title = Util.getOrEmptyString(movie.title)
    let name = Util.getOrEmptyString(movie.name)
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
      {Util.isEmptyString(name)
        ? <span className="font-nav text-[2rem]"> {title->string} </span>
        : <span className="font-nav text-[2rem]"> {name->string} </span>}
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

type size = {
  width: int,
  height: int,
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let (loaded, setLoaded) = React.useState(_ => false)
  let imgPathRef = React.useRef("")

  let (size, setSize) = React.useState(_ => {width: 100, height: 18})

  React.useMemo1(() => {
    imgPathRef.current = Links.getOriginalBigImage(Util.getOrEmptyString(movie.backdrop_path))
  }, [movie])

  let updateLayout = () => {
    let isMobile = MediaQuery.matchMedia("(max-width: 600px)")
    let isSmallScreen = MediaQuery.matchMedia("(max-width: 700px)")
    let isMediumScreen = MediaQuery.matchMedia("(max-width: 1000px)")
    let isLargeScreen = MediaQuery.matchMedia("(max-width: 1300px)")
    let isVeryLargeScreen = MediaQuery.matchMedia("(min-width: 1500px)")
    if isMobile {
      setSize(_ => {width: 100, height: 16})
    } else if isSmallScreen {
      setSize(_ => {width: 100, height: 26})
    } else if isMediumScreen {
      setSize(_ => {width: 100, height: 30})
    } else if isLargeScreen {
      setSize(_ => {width: 70, height: 32})
    } else if isVeryLargeScreen {
      setSize(_ => {width: 70, height: 46})
    } else {
      setSize(_ => {width: 70, height: 34})
    }
  }
  let handleWindowSizeChange = _ => updateLayout()

  React.useEffect0(() => {
    updateLayout()
    Webapi.Dom.Window.addEventListener(Webapi__Dom.window, "resize", handleWindowSizeChange)
    Some(
      () =>
        Webapi.Dom.Window.removeEventListener(Webapi__Dom.window, "resize", handleWindowSizeChange),
    )
  })

  let tagline = Util.getOrEmptyString(movie.tagline)

  let imageStyle = ReactDOM.Style.make(
    ~width=`${size.width->Js.Int.toString}vw`,
    ~height=`${size.height->Js.Int.toString}rem`,
    (),
  )

  let sotryline = Util.getOrEmptyString(movie.overview)->Util.toStringElement

  <div className="flex w-full">
    <div className="flex flex-col w-full">
      <div className="relative flex flex-col w-full">
        {Util.isEmptyString(tagline)
          ? React.null
          : <span
              className={`${size.width == 100
                  ? "bottom-0 left-0 text-[1.1rem] rounded-tr-full pr-4"
                  : "top-0 left-0 text-[1.4rem] rounded-br-full pr-8"} absolute z-50 p-1 w-auto font-nav font-extrabold text-500 bg-slate-100 bg-clip-padding backdrop-filter backdrop-blur-xl bg-opacity-20`}>
              {Util.toStringElement(tagline)}
            </span>}
        {size.width == 100
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
        {size.width != 100
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
                <span className="break-words w-full flex text-white prose pl-2 pt-2">
                  sotryline
                </span>
              </div>
            </div>
          : React.null}
        {!loaded
          ? <div
              className={`absolute top-[${(size.height / 2)
                  ->Js.Int.toString}rem)] w-full h-full flex flex-col items-center justify-center`}>
              <Loading
                className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
              />
            </div>
          : React.null}
      </div>
      {size.width == 100 ? <HeroText movie textColor="text-900" /> : React.null}
    </div>
  </div>
}
