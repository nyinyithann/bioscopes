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

let getTrailerVideo = (movie: DetailMovieModel.detail_movie) => {
  open Belt
  try {
    movie.videos
    ->Option.map(videos =>
      videos.results->Option.map(results =>
        results->Array.getBy(
          x =>
            Util.getOrEmptyString(x.type_)->Js.String2.toLowerCase->Js.String2.includes("trailer"),
        )
      )
    )
    ->Option.getExn
    ->Option.getExn
  } catch {
  | _ => None
  }
}

module WatchTrailerSmallButton = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie) => {
    let video = getTrailerVideo(movie)
    let {play} = YoutubePlayerProvider.useVideoPlayerContext()

    switch video {
    | None => React.null
    | Some(v) =>
      switch v.key {
      | None => React.null
      | Some(vkey) =>
        <button
          type_="button"
          onClick={e => {
            ReactEvent.Mouse.preventDefault(e)
            play(Links.getYoutubeVideoLink(vkey))
          }}
          className="absolute top-0 left-0 bottom-0 right-0 flex items-center justify-center group">
          <Heroicons.Outline.PlayIcon
            className="h-14 w-14 transition-all sm:h-16 sm:w-16 stroke-[1px] stroke-slate-100 group-hover:stroke-klor-400 group-hover:cursor-pointer"
          />
        </button>
      }
    }
  }
}

module WatchTrailerButton = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie) => {
    let video = getTrailerVideo(movie)
    let {play} = YoutubePlayerProvider.useVideoPlayerContext()

    switch video {
    | None => React.null
    | Some(v) =>
      switch v.key {
      | None => React.null
      | Some(vkey) =>
        <button
          type_="button"
          onClick={e => {
            ReactEvent.Mouse.preventDefault(e)
            play(Links.getYoutubeVideoLink(vkey))
          }}
          className="flex gap-2 px-2 py-2 border-[1px] border-slate-400 backdrop-filter backdrop-blur-xl  text-white rounded-sm group mr-auto hover:bg-klor-400 hover:text-black transition-all">
          <Heroicons.Solid.PlayIcon className="h-6 w-6 fill-white group-hover:fill-black" />
          <span> {"Watch Trailer"->string} </span>
        </button>
      }
    }
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

  let goBack = e => {
    ReactEvent.Mouse.preventDefault(e)
    Webapi.Dom.History.back(Webapi.Dom.history)
  }

  <div className="flex w-full">
    <div className="flex flex-col w-full">
      <div className="relative flex flex-col w-full">
        <button
          type_="button"
          onClick={goBack}
          className="flex w-auto gap-1 justify-center p-1 group rounded ring-0 outline-none absolute right-1 top-1 z-[5000] bg-white bg-opacity-20 backdrop-blur-lg drop-shadow-lg hover:bg-opacity-30">
          <Heroicons.Solid.ArrowLeftIcon className="w-5 h-6 fill-slate-400 bg-opacity-5" />
          <span className="block  text-slate-100 text-opacity-40"> {"Back"->React.string} </span>
        </button>
        {Util.isEmptyString(tagline)
          ? React.null
          : <span
              className={`${size.width == 100
                  ? "bottom-0 left-0 text-[1.1rem] rounded-tr-full pr-4"
                  : "top-0 left-0 text-[1.4rem] rounded-br-full pr-8"} absolute z-50 p-1 w-auto font-nav font-extrabold text-500 bg-slate-100 bg-clip-padding backdrop-filter backdrop-blur-xl bg-opacity-20`}>
              {Util.toStringElement(tagline)}
            </span>}
        {size.width == 100
          ? <div className="relative flex-inline">
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
              <WatchTrailerSmallButton movie />
            </div>
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
                <span className="break-words w-full flex text-white prose pl-2 pt-2 line-clamp-6">
                  sotryline
                </span>
                <div className="flex pl-2 pt-[2rem]">
                  <WatchTrailerButton movie />
                </div>
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
