let {string, array} = module(React)

let toMovie = (~cast: PersonModel.cast) => {
  {
    MovieModel.id: Util.getOrIntZero(cast.id),
    poster_path: ?cast.poster_path,
    media_type: ?cast.media_type,
    title: ?cast.title,
    vote_average: ?cast.vote_average,
    release_date: ?cast.release_date,
  }
}

@react.component
let make = (~person: PersonModel.person) => {
  open Belt
  let (movies, setMovies) = React.useState(_ => [])
  React.useMemo1(() => {
    let castList =
      person.combined_credits
      ->Option.map(c => c.cast->Option.map(cc => cc))
      ->Option.getWithDefault(Some([]))
      ->Option.getWithDefault([])
      ->Array.keepMap(c =>
        if Util.getOrEmptyString(c.media_type) == "movie" {
          Some(toMovie(~cast=c))
        } else {
          None
        }
      )

    setMovies(_ => castList )
  }, [person])

  <div className="flex flex-col items-center justify-center bg-white">
    <ul
      className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-y-4 gap-2 justify-center items-start w-full relative">
      {movies
      ->Belt.Array.map(movie => {
        <li key={movie.id->Js.Int.toString ++ Util.getOrEmptyString(movie.title)}>
          <MovieList.Poster movie />
        </li>
      })
      ->array}
    </ul>
  </div>
}
