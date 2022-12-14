let {string, int, float, array} = module(React)

type photo = {
  id: string,
  url: string,
  type_: [#backdrop | #poster],
}

type photoslider_state = {
  isOpen: bool,
  currentIndex: int,
  imageUrls: array<string>,
}

module PhotoTitle = {
  @react.component
  let make = (~title, ~count) => {
    <div className="flex w-full gap-2 items-center font-sans text-900 pb-1">
      <span className="text-[1rem]"> {title->string} </span>
      <span className="text-[0.85rem]">
        {`${count->Js.Int.toString} ${count == 1 ? "image" : "images"}`->string}
      </span>
    </div>
  }
}

@react.component
let make = (~photos: array<photo>, ~title: option<string>=?) => {
  open Belt
  let isMobile = MediaQuery.useMediaQuery("(max-width: 600px)")
  let (backdrops, posters) = photos->Array.partition(x => x.type_ == #backdrop)

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
      imageUrls: backdrops->Belt.Array.map(x => x.url),
    })
  }

  let slidePosterImages = (currentImageIndex: int) =>
    setPhotosliderState(_ => {
      isOpen: true,
      currentIndex: currentImageIndex,
      imageUrls: posters->Belt.Array.map(x => x.url),
    })

  let closePhotoslider = _ =>
    setPhotosliderState(_ => {
      isOpen: false,
      imageUrls: photoSliderState.imageUrls,
      currentIndex: 0,
    })

  if Util.isEmptyArray(backdrops) && Util.isEmptyArray(posters) {
    <NotAvailable thing={"photos"} />
  } else {
    <div className="flex flex-col w-full gap-8 dark:dark-bg">
      {Util.isEmptyArray(backdrops)
        ? React.null
        : <div className="flex flex-col w-full dark:dark-text dark:dark-bg">
            <PhotoTitle
              title={`${Util.isEmptyString(Util.getOrEmptyString(title))
                  ? "Backdrops"
                  : `${Util.getOrEmptyString(title)}`}`}
              count={Belt.Array.length(backdrops)}
            />
            <ul
              className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center items-center w-full list-none dark:dark-bg">
              {backdrops
              ->Belt.Array.mapWithIndex((i, bd) => {
                <li
                  key={bd.id}
                  className="cursor-pointer dark:dark-bg"
                  onClick={_ => slideBackdropImages(i)}>
                  <LazyImage
                    alt="backdrop image"
                    placeholderPath={Links.placeholderImage}
                    src={bd.url}
                    className="w-full h-full border-[2px] border-slate-200 rounded-md dark:dark-border-all dark:dark-shadow"
                    lazyHeight={isMobile ? 126. : 146.}
                    lazyOffset={50.}
                  />
                </li>
              })
              ->array}
            </ul>
          </div>}
      {Util.isEmptyArray(posters)
        ? React.null
        : <div className="flex flex-col w-full">
            <PhotoTitle
              title={`${Util.isEmptyString(Util.getOrEmptyString(title))
                  ? "Posters"
                  : `${Util.getOrEmptyString(title)}`}`}
              count={Belt.Array.length(posters)}
            />
            <ul
              className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center items-center w-full dark:dark-bg">
              {posters
              ->Belt.Array.mapWithIndex((i, bd) => {
                <li
                  key={bd.id}
                  className="cursor-pointer dark:dark-bg"
                  onClick={_ => slidePosterImages(i)}>
                  <LazyImage
                    alt="poster image"
                    placeholderPath={Links.placeholderImage}
                    src={bd.url}
                    className="w-full h-full border-[2px] border-slate-200 rounded-md dark:dark-border-all dark:dark-bg dark:dark-shadow"
                    lazyHeight={isMobile ? 260. : 336.}
                    lazyOffset={50.}
                  />
                </li>
              })
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
