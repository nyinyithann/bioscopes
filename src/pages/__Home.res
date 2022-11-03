module MovieList = {
  @react.component
  let make = () => {
    let (count, setCount) = React.useState(_ => 1)
    open MoviesProvider
    let {movies, loadMovies} = useMoviesContext()

    let genreCallback = json => {
      switch GenreModel.GenreDecoder.decode(. ~json) {
      | Ok(genreList) => Js.log(genreList.genres)
      | Error(msg) => Js.log(msg)
      }
    }

    React.useEffect1(() => {
      loadMovies(~apiParams=Category({name: "popular", page: count}))

      MovieAPI.getGenres(~callback=genreCallback, ())->ignore

      None
    }, [count])

    <div className="w-full flex flex-col items-start justify-start pt-20">
      <button
        type_="button"
        className="p-2 bg-300"
        onClick={e => {
          ReactEvent.Mouse.preventDefault(e)
          setCount(prev => prev + 1)
        }}>
        {"More"->React.string}
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
}

@react.component
let make = () => {
  <div className="flex flex-col items-center justify-center">
    <MoviesProvider>
      <MovieList />
    </MoviesProvider>
  </div>
}
