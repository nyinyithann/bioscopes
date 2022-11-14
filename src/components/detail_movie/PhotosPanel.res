let {string, int, float, array} = module(React)

let getBackdropImages = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.images
  ->Option.map(imgs => imgs.backdrops)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
}

let getPosterImages = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.images
  ->Option.map(imgs => imgs.posters)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
}

module PhotoTitle = {
  @react.component
  let make = (~title, ~count) => {
    <div className="flex w-full gap-2 items-center font-sans text-900 pb-1">
      <span className="text-[0.9rem]"> {title->string} </span>
      <span className="text-[0.8rem]">
        {`${count->Js.Int.toString} ${count == 1 ? "image" : "images"}`->string}
      </span>
    </div>
  }
}

type photoslider_state = {
  isOpen: bool,
  currentIndex: int,
  imageUrls: array<string>,
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let isMobile = MediaQuery.useMediaQuery("(max-width: 600px)")
  let backdrops = getBackdropImages(~movie)
  let posters = getPosterImages(~movie)

  let windowSize: Window.window_size = Window.useWindowSize()
  let (photoSliderState, setPhotosliderState) = React.useState(_ => {
    isOpen: false,
    currentIndex: 0,
    imageUrls: [],
  })

  let slideBackdropImages = (currentImageIndex: int) => {
    setPhotosliderState(_ => {
      isOpen: true,
      currentIndex: currentImageIndex,
      imageUrls: backdrops->Belt.Array.keepMap(x =>
        switch x.file_path {
        | None => None
        | Some(path) => Some(Links.getOriginalBigImage(path))
        }
      ),
    })
  }

  let slidePosterImages = (currentImageIndex: int) => {
    setPhotosliderState(_ => {
      isOpen: true,
      currentIndex: currentImageIndex,
      imageUrls: posters->Belt.Array.keepMap(x =>
        switch x.file_path {
        | None => None
        | Some(path) => Some(Links.getOriginalBigImage(path))
        }
      ),
    })
  }

  let closePhotoslider = _ =>
    setPhotosliderState(_ => {
      isOpen: false,
      imageUrls: photoSliderState.imageUrls,
      currentIndex: 0,
    })

  if Util.isEmptyArray(backdrops) && Util.isEmptyArray(posters) {
    <NotAvailable thing={"photos"} />
  } else {
    <div className="flex flex-col w-full gap-8">
      {Util.isEmptyArray(backdrops)
        ? React.null
        : <div className="flex flex-col w-full">
            <PhotoTitle title="Backdrops" count={Belt.Array.length(backdrops)} />
            <ul
              className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center items-center w-full list-none">
              {backdrops
              ->Belt.Array.mapWithIndex((i, bd) =>
                <li
                  key={bd.file_path->Util.getOrEmptyString}
                  className="cursor-pointer"
                  onClick={_ => slideBackdropImages(i)}>
                  <LazyImageLite
                    alt="backdrop image"
                    placeholderPath={Links.placeholderImage}
                    src={Links.getPosterImageW533H300Bestv2Link(
                      bd.file_path->Util.getOrEmptyString,
                    )}
                    className="w-full h-full border-[2px] border-slate-200 rounded-md"
                    lazyHeight={isMobile ? 126. : 146.}
                    lazyOffset={50.}
                  />
                </li>
              )
              ->array}
            </ul>
          </div>}
      {Util.isEmptyArray(posters)
        ? React.null
        : <div className="flex flex-col w-full">
            <PhotoTitle title="Posters" count={Belt.Array.length(posters)} />
            <ul
              className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center items-center w-full">
              {posters
              ->Belt.Array.mapWithIndex((i, bd) =>
                <li
                  key={bd.file_path->Util.getOrEmptyString}
                  className="cursor-pointer"
                  onClick={_ => slidePosterImages(i)}>
                  <LazyImageLite
                    alt="poster image"
                    key={bd.file_path->Util.getOrEmptyString}
                    placeholderPath={Links.placeholderImage}
                    src={Links.getPosterImage_W370_H556_bestv2Link(
                      bd.file_path->Util.getOrEmptyString,
                    )}
                    className="w-full h-full border-[2px] border-slate-200 rounded-md"
                    lazyHeight={isMobile ? 280. : 356.}
                    lazyOffset={50.}
                  />
                </li>
              )
              ->array}
            </ul>
          </div>}
      <ModalDialog
        isOpen={photoSliderState.isOpen}
        onClose={closePhotoslider}
        className="relative z-50"
        panelClassName="w-full h-full transform overflow-hidden transition-all rounded-md bg-black">
        <div onClick={closePhotoslider}>
          <Heroicons.Outline.XIcon
            className="absolute z-50 top-2 right-2 w-8 h-8 p-2 border-2 border-slate-400 fill-white stroke-white hover:bg-slate-500 rounded-full bg-slate-900"
          />
        </div>
        <PhotosSlider
          currentImageIndex={photoSliderState.currentIndex}
          imageUrls={photoSliderState.imageUrls}
          width={windowSize.width - 48}
          height={windowSize.height - 48}
        />
      </ModalDialog>
    </div>
  }
}
