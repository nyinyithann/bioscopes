let {string, int, float, array} = module(React)

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let (loaded, setLoaded) = React.useState(_ => false)

  let imgPath = Links.getHeroImage(Util.getOrEmptyString(movie.poster_path))
  let title = Util.getOrEmptyString(movie.title)
  let voteAverage = Util.getOrIntZero(movie.vote_count)->string_of_int
  let releaseYear = Util.getOrEmptyString(movie.release_date)->Js.String2.substring(~from=0, ~to_=4)
  let runtime = switch movie.runtime {
  | Some(x) => {
      let t = int_of_float(x)
      `${(t / 60)->Util.itos}h ${mod(t, 60)->Util.itos}min`
    }

  | None => ""
  }

  <div className="flex w-full relative">
    {!loaded
      ? <div
          className="absolute top-[20rem] w-full h-full flex flex-col items-center justify-center animate-pulse bg-50">
          <Loading
            className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
          />
        </div>
      : React.null}
    <div className="flex flex-col w-full">
      <img
        alt="Poster"
        className="w-full h-[36rem] sm:h-[70rem]"
        src={imgPath}
        onLoad={_ => setLoaded(_ => true)}
        onError={e => {
          open ReactEvent.Media
          if target(e)["src"] !== Links.placeholderImage {
            target(e)["src"] = Links.placeholderImage
          }
        }}
      />
      <div className="flex flex-col w-full p-[0.6rem] gap-2 text-900">
        <span className="font-nav text-[2rem]"> {title->string} </span>
        <div className="flex w-full gap-4">
          <Rating ratingValue={movie.vote_average} />
          <span> {`${voteAverage} Reviews`->string} </span>
        </div>
        <div className="flex w-full gap-4">
          <span> {releaseYear->string} </span>
          <span> {runtime->string} </span>
        </div>
      </div>
    </div>
  </div>
}
