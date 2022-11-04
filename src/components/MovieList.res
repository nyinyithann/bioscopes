let {string, array} = module(React)

module Poster = {
  @react.component
  let make = (~title: option<string>, ~poster_path: option<string>) => {
    let imgLink = switch poster_path {
    | Some(p) => Links.getPosterImageW342Link(p)
    | None => ""
    }

    <button
      type_="button"
      className="flex flex-col flex-shrink-0 gap-2 transition ease-linear w-[9.5rem] h-[19rem] sm:w-[13rem] sm:h-[22rem] items-center justify-start hover:border-[1px] hover:border-slate-200 transform duration-300 hover:-translate-y-1 hover:shadow-2xl hover:scale-105 group
      hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:rounded-md"
      onClick={_ => Js.log("Hello")}>
      {Js.String2.length(imgLink) > 0
        ? <img
            alt="A poster" src={imgLink} className="w-[9.5rem] h-[14rem] sm:w-[13rem] sm:h-[18rem] flex-shrink-0 transform duration-300 group-hover:saturate-150"
          />
        : <div> {"placeholder here"->string} </div>}
      <p className="break-words text-[0.9rem] transform duration-300 group-hover:text-yellow-200
"> {Js.Option.getWithDefault("", title)->string} </p>
    </button>
  }
}

@react.component
let make = () => {
  let (queryParam, _) = UrlQueryParam.useQueryParams()

  let {movies, loading, error, loadMovies} = MoviesProvider.useMoviesContext()
  let movieList = Js.Option.getWithDefault([], movies.results)

  React.useEffect0(() => {
    switch queryParam {
    | Category({name, page}) => loadMovies(~apiParams=Category({name, page}))
    | Genre({id, name, page, sort_by}) => loadMovies(~apiParams=Genre({id, name, page, sort_by}))
    | _ => ()
    }
    None
  })
  
  if Js.String2.length(error) > 0 {
    <div> {"Error"->string} </div>
  } else if loading {
      <Loading
        className="w-[6rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-green-500 fill-50 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
      />
  } else {
      <div
        id="movie-list-here"
        className="w-full h-full flex flex-1 flex-wrap p-1 gap-[1rem] sm:gap-[3rem] justify-center items-center z-50 px-[2rem]">
        {movieList
        ->Belt.Array.map(m =>
            <Poster key={Js.Int.toString(m.id)} title={m.title} poster_path={m.poster_path} />
        )
        ->array}
      </div>
  }
}
