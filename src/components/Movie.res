module Hero = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie) => {
    let getOrEmptyString = x => Js.Option.getWithDefault("", x)
    let imgPath = Links.getHeroImage(getOrEmptyString(movie.poster_path))
    let (loaded, setLoaded) = React.useState(_ => false)
    let (err, setErr) = React.useState(_ => false)
    <div className="flex relative w-full">
      <img
        alt="Poster"
        className="w-[24rem] h-[36rem]"
        src={imgPath}
        onLoad={_ => setLoaded(_ => true)}
        onError={e => {
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

  <main className="flex p-4 border-t-[2px] border-slate-200">
    <div className="flex w-full h-[80rem]">
      <div className="w-[50%] bg-red-500 h-20" />
      <div className="w-[50%] bg-400 h-20" />
    </div>
    /* <Hero movie={detail_movie} /> */
  </main>
}
