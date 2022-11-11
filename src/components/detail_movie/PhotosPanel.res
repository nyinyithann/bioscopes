let {string, int, float, array} = module(React)

let getBackdropImages = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.images
  ->Option.map(videos => videos.backdrops)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
}

let getPosterImages = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.images
  ->Option.map(videos => videos.posters)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
}

module PhotoTitle = {
  @react.component
  let make = (~title, ~count) => {
    <div className="flex w-full gap-2 items-center font-sans text-900 pb-1">
      <span className="text-[0.9rem]"> {title->string} </span>
      <span className="text-[0.8rem]"> {`${count->Js.Int.toString} ${count == 1 ? "image" : "images"}`->string} </span>
    </div>
  }
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let backdrops = getBackdropImages(~movie)
  let posters = getPosterImages(~movie)
  if Util.isEmptyArray(backdrops) && Util.isEmptyArray(posters) {
    <NotAvailable thing={"photos"} />
  } else {
    <div className="flex flex-col w-full gap-8">
      {Util.isEmptyArray(backdrops)
        ? React.null
        : <div className="flex flex-col w-full">
            <PhotoTitle title="Backdrops" count={Belt.Array.length(backdrops)} />
            <div
              className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-2 justify-center items-center w-full">
              {backdrops
              ->Belt.Array.map(bd =>
                <LazyImageLite
                  alt="backdrop image"
                  key={bd.file_path->Util.getOrEmptyString}
                  placeholderPath={Links.placeholderImage}
                  src={Links.getPosterImageW533H300Bestv2Link(bd.file_path->Util.getOrEmptyString)}
                  className="w-full h-[9.75rem] border-[2px] border-slate-200 rounded-md"
                  lazyHeight={156.}
                  lazyOffset={50.}
                />
              )
              ->array}
            </div>
          </div>}
      {Util.isEmptyArray(posters)
        ? React.null
        : <div className="flex flex-col w-full">
            <PhotoTitle title="Posters" count={Belt.Array.length(posters)} />
            <div
              className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center items-center w-full">
              {posters
              ->Belt.Array.map(bd =>
                <LazyImageLite
                  alt="poster image"
                  key={bd.file_path->Util.getOrEmptyString}
                  placeholderPath={Links.placeholderImage}
                  src={Links.getPosterImage_W370_H556_bestv2Link(
                    bd.file_path->Util.getOrEmptyString,
                  )}
                  className="w-full h-[22rem] border-[2px] border-slate-200 rounded-md"
                  lazyHeight={356.}
                  lazyOffset={50.}
                />
              )
              ->array}
            </div>
          </div>}
    </div>
  }
}
