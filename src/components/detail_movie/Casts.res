let {string, int, float, array} = module(React)

let getCasts = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.credits
  ->Option.map(credits => credits.cast)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
}

let getCaptionElement = (cast: DetailMovieModel.cast) => {
  let name = Util.getOrEmptyString(cast.name)
  let character = Util.getOrEmptyString(cast.character)
  if Util.isEmptyString(name) && Util.isEmptyString(character) {
    React.null
  } else {
    <div className="flex flex-col w-full items-start justify-start">
      {Util.isEmptyString(name)
        ? React.null
        : <span className="text-900 text-base max-w-[20rem] text-left"> {name->string} </span>}
      {Util.isEmptyString(character)
        ? React.null
        : <span className="text-800 text-[0.85rem] max-w-[20rem] text-left">
            {character->string}
          </span>}
    </div>
  }
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let isMobile = MediaQuery.useMediaQuery("(max-width: 600px)")
  let (_, setQueryParam) = UrlQueryParam.useQueryParams()

  let castsRef = React.useRef([])
  React.useMemo1(() => {
    castsRef.current = getCasts(~movie)
}, [movie])

  if Util.isEmptyArray(castsRef.current) {
    <NotAvailable thing={"casts"} />
  } else {
    <ul
      className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center w-full list-none items-start">
      {castsRef.current
      ->Belt.Array.map(cast => {
        let id = Util.getOrIntZero(cast.id)->Js.Int.toString
        let seg = cast.profile_path->Util.getOrEmptyString
          <li
            key={id}
            className="cursor-pointer flex flex-col w-full gap-2"
            role="button"
            onClick={e => {
              open ReactEvent.Mouse
              preventDefault(e)
              setQueryParam(UrlQueryParam.Person({id: id}))
            }}>
            <LazyImage
              alt="backdrop image"
              placeholderPath={Links.placeholderImage}
              src={Links.getPosterImage_W370_H556_bestv2Link(seg)}
              className="w-full border-2 border-slate-200 rounded-md h-full"
              lazyHeight={isMobile ? 280. : 356.}
              lazyOffset={50.}
            />
            {getCaptionElement(cast)}
          </li>
      })
      ->array}
    </ul>
  }
}
