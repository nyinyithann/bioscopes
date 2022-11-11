let {string, array} = module(React)

module Poster = {
  @react.component
  let make = (
    ~id: string,
    ~title: option<string>,
    ~poster_path: option<string>,
    ~vote_average: option<float>,
    ~release_date: option<string>,
  ) => {
    let (_, setQueryParam) = UrlQueryParam.useQueryParams()

    open Js.String2
    let imgLink = switch poster_path {
    | Some(p) => Links.getPosterImageW342Link(p)
    | None => ""
    }
    let title = Js.Option.getWithDefault("", title)
    let releaseYear = switch release_date {
    | Some(rd) => Js.String2.substring(rd, ~from=0, ~to_=4)
    | None => ""
    }

    let handleClick = e => {
      open ReactEvent.Mouse
      preventDefault(e)
      setQueryParam(UrlQueryParam.Movie({id : id}))
    }

    <button
      type_="button"
      className="relative flex flex-col flex-shrink-0 gap-2 transition ease-linear w-[10rem] h-[22rem] sm:w-[15rem] sm:h-[28rem] items-center justify-start hover:border-[1px] hover:border-slate-200 transform duration-300 hover:-translate-y-1 hover:shadow-2xl hover:scale-105 group hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:rounded-md"
      onClick={handleClick}>
      <LazyImage
        alt="A poster"
        src={imgLink}
        className="flex-shrink-0 group-hover:saturate-150 border-[2px] border-slate-200 rounded-md"
        lazyLoadEnabled={true}
        lazyLoadOffset={50.}
        width={160.}
        height={240.}
        sm_width={240.}
        sm_height={352.}
        sm_mediaQuery="(max-width: 600px)"
        placeholderPath={Links.placeholderImage}
      />
      <p
        className={`${length(title) > 50
            ? "text-[0.7rem]"
            : "text-[0.95rem]"} break-words transform duration-300 group-hover:text-yellow-200 pt-[0.3rem] flex justify-center items-center text-center text-900`}>
        {title->string}
      </p>
      <Rating ratingValue={vote_average} />
      {Js.String2.length(releaseYear) == 4
        ? <div
            className="absolute top-[0.5rem] right-[0.5rem] text-[0.8rem] bg-700/60 text-slate-50 px-[4px] py-[1px] rounded-sm">
            {releaseYear->React.string}
          </div>
        : React.null}
    </button>
  }
}

@react.component
let make = () => {
  let (queryParam, setQueryParam) = UrlQueryParam.useQueryParams()

  let {movies, loading, error, loadData} = MoviesProvider.useMoviesContext()
  let movieList = Js.Option.getWithDefault([], movies.results)
  let currentPage = Js.Option.getWithDefault(0, movies.page)
  let totalPages = Js.Option.getWithDefault(0, movies.total_pages)

  let viewingTitleRef = React.useRef("")
  let isGenreRef = ref(false)

  React.useMemo1(() => {
    switch queryParam {
    | Category({display}) => {
        if Js.String2.toLowerCase(display) == "upcoming" {
          let msg = switch movies.dates {
          | Some(ds) =>
            switch (ds.maximum, ds.minimum) {
            | (Some(mx), Some(mi)) => `${display} (${mi} ~ ${mx})`
            | _ => display
            }
          | None => display
          }
          viewingTitleRef.current = msg
        } else {
          viewingTitleRef.current = display
        }
        DomBinding.setTitle(DomBinding.htmlDoc, display ++ " Movies")
        isGenreRef.contents = false
      }

    | Genre({display}) => {
        viewingTitleRef.current = display
        DomBinding.setTitle(DomBinding.htmlDoc, display ++ " Movies")
        isGenreRef.contents = true
      }

    | Search({query}) => {
        viewingTitleRef.current = `Search: '${query}'`
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
      loadData(
        ~apiParams=Category({name, display, page}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | Genre({id, name, display, page, sort_by}) =>
      loadData(
        ~apiParams=Genre({id, name, display, page, sort_by}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | Search({query, page}) =>
      loadData(~apiParams=Search({query, page}), ~signal=Fetch.AbortController.signal(controller))
    | _ => ()
    }
    Some(() => Fetch.AbortController.abort(controller, "Cancel the request"))
  })

  let loadPage = n => {
    switch queryParam {
    | Category({name, display, page}) => setQueryParam(Category({name, display, page: page + n}))
    | Genre({id, name, display, page, sort_by}) =>
      setQueryParam(Genre({id, name, display, page: page + n, sort_by}))
    | Search({query, page}) => setQueryParam(Search({query, page: page + n}))
    | _ => ()
    }
  }

  if Js.String2.length(error) > 0 {
    <ErrorDisplay errorMessage={error} />
  } else if loading {
    <Loading
      className="w-[6rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-green-500 fill-50 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
    />
  } else {
    <div className="flex flex-col bg-white">
      <div
        className="flex items-center p-1 pl-4 sticky top-[3.4rem] z-50 shadlow-md flex-shrink-0 bg-white border-t-[2px] border-slate-200">
        <div className="font-nav text-[1.2rem] text-500"> {viewingTitleRef.current->string} </div>
        <div className={`${isGenreRef.contents ? "flex" : "hidden"} justify-start ml-auto pr-4`}>
          <FilterBox />
        </div>
      </div>
      <div
        id="movie-list-here"
        className="w-full h-full flex flex-1 flex-wrap p-1 pt-4 gap-[1rem] sm:gap-[1.4rem] justify-center items-center px-[1rem] sm:px-[2rem] bg-white">
        {Belt.Array.length(movieList) == 0
          ? <div className="text-300 text-2xl"> {"Movies Not Found."->string} </div>
          : movieList
            ->Belt.Array.map(m =>
              <Poster
                key={Js.Int.toString(m.id)}
                id={m.id->Js.Int.toString}
                title={m.title}
                poster_path={m.poster_path}
                vote_average={m.vote_average}
                release_date={m.release_date}
              />
            )
            ->array}
      </div>
      <div className="flex gap-2 px-4 pt-[2rem]">
        {currentPage > 1
          ? <button
              type_="button"
              className="flex gap-2 px-4 py-2 border-[1px] border-300 bg-300 text-900 rounded hover:bg-400 hover:text-50 group"
              onClick={_ => loadPage(-1)}>
              <Heroicons.Solid.ArrowLeftIcon
                className="h-6 w-6 fill-klor-900 group-hover:fill-klor-50"
              />
              <span> {`Page ${Js.Int.toString(currentPage - 1)} `->string} </span>
            </button>
          : React.null}
        {currentPage < totalPages
          ? <button
              type_="button"
              className="flex gap-2 px-4 py-2 border-[1px] border-300 bg-300 text-900 rounded hover:bg-400 hover:text-50 group ml-auto"
              onClick={_ => loadPage(1)}>
              <span> {`Page ${Js.Int.toString(currentPage + 1)} `->string} </span>
              <Heroicons.Solid.ArrowRightIcon
                className="h-6 w-6 fill-klor-900 group-hover:fill-klor-50"
              />
            </button>
          : React.null}
      </div>
    </div>
  }
}
