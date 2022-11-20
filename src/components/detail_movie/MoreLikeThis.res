let {string, array} = module(React)

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
  let currentPage = Util.getOrIntZero(recommendedMovies.page)

  let onClose = arg =>
    if arg {
      clearError()
    }

  let controller = Fetch.AbortController.make()

  let loadPage = (~page: int) => {
    loadRecommendedMovies(~movieId, ~page, ~signal=Fetch.AbortController.signal(controller))
  }

  let (lastPoster, setLastPoster) = React.useState(_ => Js.Nullable.null)
  let (pageToLoad, setPageToLoad) = React.useState(_ => currentPage)

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
    if pageToLoad != currentPage && pageToLoad <= totalPages {
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

  <div className="flex flex-col items-center justify-center bg-white dark:dark-bg">
    <ul
      className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-y-4 gap-2 justify-center items-start w-full relative dark:dark-bg">
      {mlist
      ->Belt.Array.mapWithIndex((i, m) => {
        if i == Belt.Array.length(mlist) - 1 && !loading && currentPage <= totalPages {
          <li
            key={m.id->Util.itos ++ Js.Int.toString(currentPage)}
            ref={ReactDOM.Ref.callbackDomRef(setLastPosterRef)}>
            <MovieList.Poster movie={m} />
          </li>
        } else {
          <li key={m.id->Util.itos ++ Js.Int.toString(currentPage)}>
            <MovieList.Poster movie={m} />
          </li>
        }
      })
      ->array}
    </ul>
    {Js.String2.length(error) > 0
      ? <ErrorDialog isOpen={Js.String2.length(error) > 0} errorMessage={error} onClose />
      : React.null}
  </div>
}
