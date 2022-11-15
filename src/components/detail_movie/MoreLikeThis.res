let {string, array} = module(React)

let nextPage = ref(0)

@react.component
let make = (~movieId: int) => {
  let {
    recommendedMovies,
    loading,
    error,
    loadRecommendedMovies,
    clearError,
  } = MoviesProvider.useMoviesContext()

  let mlist = Js.Option.getWithDefault([], recommendedMovies.results)
  let totalPages = Util.getOrIntZero(recommendedMovies.total_pages)

  let isMobile = MediaQuery.useMediaQuery("(max-width: 600px)")

  let (_, setQueryParam) = UrlQueryParam.useQueryParams()

  let handleClick = (movie: MovieModel.movie) => {
    switch movie.media_type {
    | Some(mt) =>
      setQueryParam(UrlQueryParam.Movie({id: movie.id->Js.Int.toString, media_type: mt}))
    | _ => setQueryParam(UrlQueryParam.Movie({id: movie.id->Js.Int.toString, media_type: "movie"}))
    }
  }

  let loadMore = _ => {
    open Webapi.Dom.Window
    open Js.Int
    if (
      Js.Math.ceil(toFloat(innerHeight(Webapi__Dom.window)) +. scrollY(Webapi__Dom.window)) >=
      Webapi.Dom.Element.scrollHeight(
        Webapi.Dom.Document.documentElement(Webapi__Dom.document),
      ) - 300 && !loading
    ) {
      let controller = Fetch.AbortController.make()
      nextPage.contents = nextPage.contents + 1
      if nextPage.contents <= totalPages {
        loadRecommendedMovies(
          ~movieId,
          ~page=nextPage.contents,
          ~signal=Fetch.AbortController.signal(controller),
        )
      }
    }
  }

  let onClose = arg => if arg { clearError() }

  React.useEffect1(() => {
    nextPage.contents = 0
    None
  }, [movieId])

  React.useEffect0(() => {
    Webapi.Dom.Window.addEventListener(Webapi.Dom.window, "scroll", loadMore)
    Some(() => Webapi.Dom.Window.removeEventListener(Webapi.Dom.window, "scroll", loadMore))
  })

  <div className="flex flex-col items-center justify-center bg-white">
    <ul
      className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-y-4 gap-2 justify-center items-center w-full relative">
      {mlist
      ->Belt.Array.mapWithIndex((i, m) =>
        <li
          key={m.id->Util.itos ++ Js.Int.toString(i)}
          className="cursor-pointer transform duration-300 hover:-translate-y-1 hover:shadow-2xl hover:scale-105 hover:rounded group"
          onClick={_ => handleClick(m)}
          role="button">
          <LazyImageLite
            alt="poster image"
            placeholderPath={Links.placeholderImage}
            src={Links.getPosterImage_W370_H556_bestv2Link(m.poster_path->Util.getOrEmptyString)}
            className="w-full h-full border-[2px] border-slate-200 rounded-md group-hover:border-0 group-hover rounded-b-none object-cover"
            lazyHeight={isMobile ? 280. : 356.}
            lazyOffset={50.}
          />
          <p
            className={`${Js.String2.length(Util.getOrEmptyString(m.title)) > 30
                ? "text-[0.7rem]"
                : "text-[0.95rem]"} break-words transform duration-300 pt-[0.3rem] flex text-left text-900 truncate overflow-hidden p-1`}>
            {Util.getOrEmptyString(m.title)->string}
          </p>
          <div className="pb-2">
            <Rating ratingValue={m.vote_average} />
          </div>
          {switch m.release_date {
          | Some(rd) =>
            let releaseYear = Js.String2.substring(rd, ~from=0, ~to_=4)

            if Js.String2.length(releaseYear) == 4 {
              <div
                className="absolute top-[2%] right-[8%] sm:right-[4%] text-[0.8rem] bg-700/60 text-slate-50 px-[12px] py-[1px] rounded-sm">
                {releaseYear->React.string}
              </div>
            } else {
              React.null
            }

          | None => React.null
          }}
        </li>
      )
      ->array}
    </ul>
    <ErrorDialog isOpen={Js.String2.length(error) > 0} errorMessage={error} onClose />
  </div>
}
