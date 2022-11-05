let {string, array} = module(React)

module Poster = {
  @react.component
  let make = (~title: option<string>, ~poster_path: option<string>, ~vote_average: option<float>) => {
    open Js.String2
    let imgLink = switch poster_path {
    | Some(p) => Links.getPosterImageW342Link(p)
    | None => ""
    }
    let title = Js.Option.getWithDefault("", title)
    <button
      type_="button"
      className="flex flex-col flex-shrink-0 gap-2 transition ease-linear w-[10rem] h-[22rem] sm:w-[15rem] sm:h-[28rem] items-center justify-start hover:border-[1px] hover:border-slate-200 transform duration-300 hover:-translate-y-1 hover:shadow-2xl hover:scale-105 group
      hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:rounded-md"
      onClick={_ => Js.log("Hello")}>
      {length(imgLink) > 0
        ? <img
            alt="A poster"
            src={imgLink}
            className="w-[10rem] h-[15rem] sm:w-[15rem] sm:h-[22rem] flex-shrink-0 transform duration-300 group-hover:saturate-150 border-[2px] border-slate-200 rounded-md"
          />
        : <div> {"placeholder here"->string} </div>}
      <p
        className={`${length(title) > 50
            ? "text-[0.7rem]"
            : "text-[0.95rem]"} break-words transform duration-300 group-hover:text-yellow-200`}>
        {title->string}
      </p>
      <Rating ratingValue={vote_average} />
    </button>
  }
}

@react.component
let make = () => {
  let (queryParam, _) = UrlQueryParam.useQueryParams()

  let {movies, loading, error, loadMovies} = MoviesProvider.useMoviesContext()
  let movieList = Js.Option.getWithDefault([], movies.results)

  let viewingTitleRef = React.useRef("")

  React.useEffect0(() => {
    switch queryParam {
    | Category({name, display, page}) => {
        viewingTitleRef.current = display
        DomBinding.setTitle(DomBinding.htmlDoc, display ++ " Movies")
        loadMovies(~apiParams=Category({name, display, page}))
      }

    | Genre({id, name, display, page, sort_by}) => {
        viewingTitleRef.current = display
        DomBinding.setTitle(DomBinding.htmlDoc, display ++ " Movies")
        loadMovies(~apiParams=Genre({id, name, display, page, sort_by}))
      }

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
    <div className="flex flex-col bg-white">
      <div
        className="font-nav text-[1.2rem] text-500 p-1 pl-4 sticky top-[3.4rem] z-50 shadlow-md flex-shrink-0 bg-white border-t-[2px] border-slate-200">
        {viewingTitleRef.current->string}
      </div>
      <div
        id="movie-list-here"
        className="w-full h-full flex flex-1 flex-wrap p-1 pt-4 gap-[1rem] sm:gap-[1.4rem] justify-center items-center px-[1rem] sm:px-[2rem] bg-white">
        {movieList
        ->Belt.Array.map(m =>
          <Poster key={Js.Int.toString(m.id)} title={m.title} poster_path={m.poster_path} vote_average={m.vote_average} />
        )
        ->array}
      </div>
    </div>
  }
}
