let {string, array} = module(React)

let toMovie = (~stew: PersonModel.cast) => {
  MovieModel.id: Util.getOrIntZero(stew.id),
  poster_path: ?stew.poster_path,
  media_type: ?stew.media_type,
  title: ?stew.title,
  vote_average: ?stew.vote_average,
  release_date: ?stew.release_date,
}

let moviesPerPage = 30
let c = ref(0)
@react.component
let make = (~person: PersonModel.person) => {
  open Belt
  let (moviesToDisplay, setMoviesToDisplay) = React.useState(_ => [])
  let totalPages = React.useRef(0)
  let allMovies = React.useRef([])

  React.useMemo1(() => {
    let castList =
      person.combined_credits
      ->Option.map(c => {
        let cast = Js.Option.getWithDefault([], c.cast)->Array.keepMap(
          c =>
            if Util.getOrEmptyString(c.media_type) == "movie" {
              Some(toMovie(~stew=c))
            } else {
              None
            },
        )
        let crew = Js.Option.getWithDefault([], c.crew)->Array.keepMap(
          c =>
            if Util.getOrEmptyString(c.media_type) == "movie" {
              Some(toMovie(~stew=c))
            } else {
              None
            },
        )

        Array.concat(cast, crew)
      })
      ->Option.getWithDefault([])

    totalPages.current = Array.length(castList)
    setMoviesToDisplay(_ => Array.slice(castList, ~offset=0, ~len=moviesPerPage))
    allMovies.current = castList
  }, [person])

  let (lastPoster, setLastPoster) = React.useState(_ => Js.Nullable.null)
  let (pageToLoad, setPageToLoad) = React.useState(_ => 1)

  let setLastPosterRef = elem => {
    setLastPoster(_ => elem)
  }

  let observer = React.useRef(
    Webapi.IntersectionObserver.make((entries, _) => {
      switch Belt.Array.get(entries, 0) {
      | Some(entry) =>
        if Webapi.IntersectionObserver.IntersectionObserverEntry.isIntersecting(entry) {
          setPageToLoad(p => {
            p + 1
          })
        }
      | _ => ()
      }
    }),
  )

  React.useEffect1(() => {
    if pageToLoad <= totalPages.current {
      setMoviesToDisplay(prev =>
        MovieModel.unique(
          prev,
          Array.slice(allMovies.current, ~offset=Array.length(prev), ~len=moviesPerPage),
        )
      )
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

  <div className="flex flex-col items-center justify-center bg-white">
    <ul
      className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-y-4 gap-2 justify-center items-start w-full relative">
      {moviesToDisplay
      ->Belt.Array.mapWithIndex((i, movie) => {
        if i == Belt.Array.length(moviesToDisplay) - 1 && pageToLoad <= totalPages.current {
          <li
            key={movie.id->Js.Int.toString ++ Util.getOrEmptyString(movie.title)}
            ref={ReactDOM.Ref.callbackDomRef(setLastPosterRef)}>
            <MovieList.Poster movie />
          </li>
        } else {
          <li key={movie.id->Js.Int.toString ++ Util.getOrEmptyString(movie.title)}>
            <MovieList.Poster movie />
          </li>
        }
      })
      ->array}
    </ul>
  </div>
}

let make = React.memo(make)
