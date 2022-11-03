let {string} = module(React)

@react.component
let make = () => {
  let (queryParam, setQueryParam) = UrlQueryParam.useQueryParams()

  let {movies, loadMovies} = MoviesProvider.useMoviesContext()

  React.useEffect1(() => {
      switch queryParam {
          |Category({name, page}) => loadMovies(~apiParams=Category({name, page}))
          |Genre({id,name, page, sort_by}) => loadMovies(~apiParams=Genre({id, name, page, sort_by}))
          | _ => ()
      }
    None
  }, [])

  <div id="movie-list-here" className="w-full h-[100vh] flex flex-col bg-100">
    {switch queryParam {
    | Category(c) => c.name->string
    | Genre(g) => g.name->string
    | _ => "oops"->string
    }}
    <button className="p-4 bg-300" onClick={_ => setQueryParam(UrlQueryParam.Movie(7))}>
      {"movie 7"->string}
    </button>
      {<>
        {movies.results
        ->Belt.Array.map(m => {
          <div key={m.id->Belt.Int.toString}> {m.title->React.string} </div>
        })
        ->React.array}
      </>}
  </div>
}
