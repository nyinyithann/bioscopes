let {string, array} = module(React)

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let (queryParam, setQueryParam) = UrlQueryParam.useQueryParams()

  let {recommendedMovies, loading, error, loadRecommendedMovies} = MoviesProvider.useMoviesContext()
  let movieList = Js.Option.getWithDefault([], recommendedMovies.results)
  let currentPage = Js.Option.getWithDefault(0, recommendedMovies.page)
  let totalPages = Js.Option.getWithDefault(0, recommendedMovies.total_pages)

  /* React.useEffect1(() => { */
  /*   let controller = Fetch.AbortController.make() */
  /*     loadRecommendedMovies(~movieId = 663712, ~page=1, ~signal=Fetch.AbortController.signal(controller)) */
  /*   /* switch movie.id { */ */
  /*   /* | Some(movieId) => */ */
  /*   /*   loadRecommendedMovies(~movieId, ~page=1, ~signal=Fetch.AbortController.signal(controller)) */ */
  /*   /* | _ => () */ */
  /*   /* } */ */
  /*   /* Some(() => Fetch.AbortController.abort(controller, "Cancel the request")) */ */
  /*     None */
  /* }, [movie]) */

  if Js.String2.length(error) > 0 {
    <ErrorDisplay errorMessage={error} />
  } else if loading {
    <Loading
      className="w-[6rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-green-500 fill-50 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
    />
  } else {
    <div className="flex flex-col bg-white">
      <div
        id="movie-list-here"
        className="w-full h-full flex flex-1 flex-wrap p-1 pt-4 gap-[1rem] sm:gap-[1.4rem] justify-center items-center px-[1rem] sm:px-[2rem] bg-white">
        {Belt.Array.length(movieList) == 0
          ? <div className="text-300 text-2xl"> {"Movies Not Found."->string} </div>
          : movieList
            ->Belt.Array.map(m =>
              <MovieList.Poster
                key={Js.Int.toString(m.id)}
                id={m.id->Js.Int.toString}
                title={m.title}
                media_type={m.media_type}
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
              onClick={_ => ()}>
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
              onClick={_ => ()}>
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
