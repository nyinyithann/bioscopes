let {string, array} = module(React)

module Poster = {
  @react.component
  let make = (~movie: MovieModel.movie) => {
    let isMobile = MediaQuery.useMediaQuery("(max-width: 600px)")

    let imgLink = switch movie.poster_path {
    | Some(p) => Links.getPosterImageW342Link(p)
    | None => ""
    }

    let getHref = (movie: MovieModel.movie) => {
      open Webapi.Url
      let id = Js.Int.toString(movie.id)
      let param = switch movie.media_type {
      | Some(mt) => {UrlQueryParam.id, media_type: mt}
      | _ => {id, media_type: "movie"}
      }

      `/${Js.Option.getWithDefault("movie", movie.media_type)}?` ++
      UrlQueryParam.Converter_movie_tv_param.stringfy(. param)
      ->URLSearchParams.make
      ->URLSearchParams.toString
    }

    <a
      href={getHref(movie)}
      rel="noopener noreferrer"
      className="block cursor-pointer transform duration-300 hover:shadow-2xl hover:-translate-y-1 hover:scale-[1.01] hover:rounded group"
      role="button">
      <LazyImage
        alt="poster image"
        placeholderPath={Links.placeholderImage}
        src={imgLink}
        className="w-[16rem] h-full border-[2px] border-slate-200 rounded-md group-hover:border-0 group-hover rounded-b-none"
        lazyHeight={isMobile ? 286. : 366.}
        lazyOffset={200.}
      />
      <p
        className="text-base break-words transform duration-300 pt-[0.3rem] flex text-left text-900  p-1">
        {Util.getOrEmptyString(movie.title)->string}
      </p>
      <div className="pb-2">
        <Rating ratingValue={movie.vote_average} />
      </div>
      {switch movie.release_date {
      | Some(rd) =>
        let releaseYear = Js.String2.substring(rd, ~from=0, ~to_=4)

        if Js.String2.length(releaseYear) == 4 {
          <div
            className="absolute top-[2%] right-[3%] text-[0.8rem] bg-700/60 text-slate-50 px-[12px] py-[1px] rounded-sm">
            {releaseYear->React.string}
          </div>
        } else {
          React.null
        }

      | None => React.null
      }}
    </a>
  }
}

let isGenreRef = ref(false)

@react.component
let make = () => {
  let (queryParam, _) = UrlQueryParam.useQueryParams()

  let {movies, loading, error, loadMovies, clearError} = MoviesProvider.useMoviesContext()
  let movieList = Js.Option.getWithDefault([], movies.results)
  let currentPage = Js.Option.getWithDefault(0, movies.page)
  let totalPages = Js.Option.getWithDefault(0, movies.total_pages)

  let viewingTitleRef = React.useRef("")

  React.useMemo1(() => {
    switch queryParam {
    | Category({display}) => {
        if Js.String2.toLowerCase(display) == "upcoming" {
          let msg = switch movies.dates {
          | Some(ds) =>
            `(${Util.toLocaleString(
                ~date=ds.maximum,
                ~monthType="short",
                (),
              )} ~ ${Util.toLocaleString(~date=ds.minimum, ~monthType="short", ())})`
          | None => ""
          }
          viewingTitleRef.current = msg
        } else {
          viewingTitleRef.current = ""
        }
        DomBinding.setTitle(DomBinding.htmlDoc, display ++ " Movies")
        isGenreRef.contents = false
      }

    | Genre({display}) => {
        viewingTitleRef.current = ""
        DomBinding.setTitle(DomBinding.htmlDoc, display ++ " Movies")
        isGenreRef.contents = true
      }

    | Search(_) => {
        if Belt.Array.length(movieList) == 0 {
          viewingTitleRef.current = "No search results!"
        } else {
          viewingTitleRef.current = ""
        }
        DomBinding.setTitle(DomBinding.htmlDoc, viewingTitleRef.current)
        isGenreRef.contents = false
      }

    | _ => isGenreRef.contents = false
    }
  }, [movies])

  React.useEffect0(() => {
    let controller = Fetch.AbortController.make()
    switch queryParam {
    | Category({name, display, page}) =>
      loadMovies(
        ~apiParams=Category({name, display, page}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | Genre({id, name, display, page, sort_by}) =>
      loadMovies(
        ~apiParams=Genre({id, name, display, page, sort_by}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | Search({query, page}) =>
      loadMovies(~apiParams=Search({query, page}), ~signal=Fetch.AbortController.signal(controller))
    | _ => ()
    }

    Some(() => Fetch.AbortController.abort(controller, "Cancel the request"))
  })

  let onClose = arg => {
    if arg {
      clearError()
    }
  }

  let controller = Fetch.AbortController.make()
  let loadPage = (~page: int) => {
    switch queryParam {
    | Category({name, display}) =>
      loadMovies(
        ~apiParams=Category({name, display, page}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | Genre({id, name, display, sort_by}) =>
      loadMovies(
        ~apiParams=Genre({id, name, display, page, sort_by}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | Search({query}) =>
      loadMovies(~apiParams=Search({query, page}), ~signal=Fetch.AbortController.signal(controller))
    | _ => ()
    }
  }

  let (lastPoster, setLastPoster) = React.useState(_ => Js.Nullable.null)
  let (pageToLoad, setPageToLoad) = React.useState(_ => 1)

  let setLastPosterRef = elem => {
    setLastPoster(_ => elem)
  }

  let observer = React.useRef(
    Webapi.IntersectionObserver.make((entries, _) => {
      switch Belt.Array.get(entries, 0) {
      | Some(entry) =>
        if Webapi.IntersectionObserver.IntersectionObserverEntry.isIntersecting(entry) && !loading {
          setPageToLoad(p => {
            p + 1
          })
        }
      | _ => ()
      }
    }),
  )

  React.useEffect1(() => {
    if pageToLoad <= totalPages {
      loadPage(~page=pageToLoad)
    }
    None
  }, [pageToLoad])

  React.useEffect1(() => {
    let currentElem = lastPoster
    let currentObserver = observer.current

    switch Js.Nullable.toOption(currentElem) {
    | Some(ce) => Webapi.IntersectionObserver.observe(currentObserver, ce)

    | _ => ()
    }

    Some(
      () => {
        switch Js.Nullable.toOption(currentElem) {
        | Some(ce) => Webapi.IntersectionObserver.unobserve(currentObserver, ce)
        | _ => ()
        }
      },
    )
  }, [lastPoster])

  <div className="flex flex-col bg-white">
    <div
      className="flex items-center p-1 pl-4 sticky top-[3.4rem] z-50 shadlow-md flex-shrink-0 bg-white border-t-[2px] border-slate-200">
      <div className="flex items-center justify-center gap-2">
        <GenreList />
        {viewingTitleRef.current != ""
          ? <span className="text-[0.9rem] text-900"> {viewingTitleRef.current->string} </span>
          : React.null}
      </div>
      <div className={`${isGenreRef.contents ? "flex" : "hidden"} justify-start ml-auto pr-4`}>
        <FilterBox />
      </div>
    </div>
    <div className="flex flex-col items-center justify-center bg-white p-2">
      <ul
        className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 lg:grid-cols-6 xl:grid-cols-8 gap-y-4 gap-2 justify-center items-start w-full relative">
        {movieList
        ->Belt.Array.mapWithIndex((i, m) => {
          if i == Belt.Array.length(movieList) - 1 && !loading && currentPage <= totalPages {
            <li
              key={m.id->Util.itos ++ Js.Int.toString(currentPage)}
              ref={ReactDOM.Ref.callbackDomRef(setLastPosterRef)}>
              <Poster movie={m} />
            </li>
          } else {
            <li key={m.id->Util.itos ++ Js.Int.toString(currentPage)}>
              <Poster movie={m} />
            </li>
          }
        })
        ->array}
      </ul>
      <Pulse show={loading} />
    </div>
    {currentPage - 1 == totalPages && Belt.Array.length(movieList) > 0
      ? <div className="flex items-center justify-center w-full bg-900 gap-2 p-2">
          <p className="text-slate-50">
            {"Amazing... you browsed all the movies!  😲"->string}
          </p>
        </div>
      : React.null}
    {Js.String2.length(error) > 0
      ? <ErrorDialog isOpen={Js.String2.length(error) > 0} errorMessage={error} onClose />
      : React.null}
  </div>
}
