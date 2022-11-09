module Hero = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie) => {
    let getOrEmptyString = x => Js.Option.getWithDefault("", x)
    let imgPath = Links.getHeroImage(getOrEmptyString(movie.poster_path))
    let (loaded, setLoaded) = React.useState(_ => false)
    let (err, setErr) = React.useState(_ => false)

    <div className="flex relative">
    {!loaded
      ? <div
          className="absolute top-[20rem] w-full h-full flex flex-col items-center justify-center animate-pulse bg-50">
          <Loading
            className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
          />
        </div>
      : React.null }
      <img
        alt="Poster"
        className="w-full h-[40rem] sm:h-[70rem]"
        src={imgPath}
        onLoad={_ => setLoaded(_ => true)}
        onError={e => {
            DomBinding.pop("error")
            setErr(_ => true)

          open ReactEvent.Media
          if target(e)["src"] !== Links.placeholderImage {
            target(e)["src"] = Links.placeholderImage
          }
        }}
      />
    </div>
  }
}

let {string} = module(React)
@react.component
let make = (~id: option<string>) => {
  let {detail_movie, loading, error, loadDetailMovie} = MoviesProvider.useMoviesContext()

  React.useMemo1(() => {
    switch detail_movie.title {
    | Some(t) => DomBinding.setTitle(DomBinding.htmlDoc, t)
    | None => DomBinding.setTitle(DomBinding.htmlDoc, "Bioscopes")
    }
  }, [detail_movie])

  React.useEffect0(() => {
    switch id {
    | Some(n) =>
      let controller = Fetch.AbortController.make()
      loadDetailMovie(~apiParams=Movie(n), ~signal=Fetch.AbortController.signal(controller))
      Some(() => Fetch.AbortController.abort(controller, "Cancel the request"))
    | None => None
    }
  })

  if Js.String2.length(error) > 0 {
    <ErrorDisplay errorMessage={error} />
  } else if loading {
    <Loading
      className="w-[6rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-green-500 fill-50 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
    />
  } else {
  <main className="flex border-t-[2px] border-slate-200">
    <div className="flex md:hidden flex-col w-full h-full">
      <div className="w-full">
      <Hero movie={detail_movie}/>
      </div>
      <div className="w-full bg-green-100 h-40 border-2" />
    </div>
    /* desktop */
    <div className="hidden md:flex w-full h-[80rem]">
      <div className="w-2/5 bg-200 border-2" />
      <div className="w-3/5 bg-green-100 border-2" />
    </div>
  </main>
  }
}
