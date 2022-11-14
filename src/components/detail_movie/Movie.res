let {string} = module(React)
@react.component
let make = () => {
  let {detail_movie, loading, error, loadDetailMovie} = MoviesProvider.useMoviesContext()
  let {videoPlayState, stop} = YoutubePlayerProvider.useVideoPlayerContext()
  let windowSize: Window.window_size = Window.useWindowSize()

  let (queryParam, _) = UrlQueryParam.useQueryParams()

  React.useMemo1(() => {
    switch detail_movie.title {
    | Some(t) => DomBinding.setTitle(DomBinding.htmlDoc, t)
    | None => DomBinding.setTitle(DomBinding.htmlDoc, "Bioscopes")
    }
  }, [detail_movie])

  React.useEffect0(() => {
    let controller = Fetch.AbortController.make()
    switch queryParam {
    | Movie({id, media_type}) =>
      loadDetailMovie(
        ~apiParams=Movie({id, media_type}),
        ~signal=Fetch.AbortController.signal(controller),
      )
    | _ => ()
    }
    Some(() => Fetch.AbortController.abort(controller, "Cancel the request"))
  })

  if Js.String2.length(error) > 0 {
    <ErrorDisplay errorMessage={error} />
  } else if loading {
    <Loading
      className="w-[6rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-green-500 fill-50 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
    />
  } else {
    open HeadlessUI
    <main className="flex border-t-[2px] border-slate-200">
      <div className="flex flex-col w-full h-full">
        <div id="hero_container" className="w-full">
          <Hero movie={detail_movie} />
        </div>
        <div id="movie_info_tab_container" className="w-full flex flex-col items-center justify-center pt-1">
          <Tab.Group>
            {selectedIndex => {
              <div className="flex flex-col w-full">
                <Tab.List className="flex w-full flex-nowrap items-center justify-around">
                  {_ => {
                    <>
                      <Tab
                        key={"overview"}
                        className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                        {props =>
                          <div
                            className={`${props.selected
                                ? "bg-300 text-900"
                                : ""} w-full h-full control-color flex items-center justify-center py-2`}>
                            {"OVERVIEW"->string}
                          </div>}
                      </Tab>
                      <Tab
                        key={"casts"}
                        className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                        {props =>
                          <div
                            className={`${props.selected
                                ? "bg-300 text-900"
                                : ""} w-full h-full control-color flex items-center justify-center py-2`}>
                            {"CASTS"->string}
                          </div>}
                      </Tab>
                      <Tab
                        key={"videos"}
                        className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                        {props =>
                          <div
                            className={`${props.selected
                                ? "bg-300 text-900"
                                : ""} w-full h-full control-color flex items-center justify-center py-2`}>
                            {"VIDEOS"->string}
                          </div>}
                      </Tab>
                      <Tab
                        key={"photos"}
                        className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                        {props =>
                          <div
                            className={`${props.selected
                                ? "bg-300 text-900"
                                : ""} w-full h-full control-color flex items-center justify-center py-2`}>
                            {"PHOTOS"->string}
                          </div>}
                      </Tab>
                    </>
                  }}
                </Tab.List>
                <Tab.Panels className="pt-1">
                  {props => {
                    <>
                      <Tab.Panel key="overview-panel">
                        {props => {
                          <div className="flex w-full p-2">
                            <StorylinePanel movie={detail_movie} />
                          </div>
                        }}
                      </Tab.Panel>
                      <Tab.Panel key="casts-panel">
                        {props => {
                          <div className="flex w-full p-2">
                            <Casts movie={detail_movie} />
                          </div>
                        }}
                      </Tab.Panel>
                      <Tab.Panel key="videos-panel">
                        {props => {
                          <div className="flex w-full p-2">
                            <VideoPanel movie={detail_movie} />
                          </div>
                        }}
                      </Tab.Panel>
                      <Tab.Panel key="photos-panel">
                        {props => {
                          <div className="flex w-full p-2">
                            <PhotosPanel movie={detail_movie} />
                          </div>
                        }}
                      </Tab.Panel>
                    </>
                  }}
                </Tab.Panels>
              </div>
            }}
          </Tab.Group>
          <div>
            <MoreLikeThis movie={detail_movie} />
          </div>
        </div>
      </div>
      <ModalDialog
        isOpen={videoPlayState.playing}
        onClose={_ => stop()}
        className="relative z-50"
        panelClassName="w-full h-full transform overflow-hidden transition-all">
        <div onClick={_ => stop()}>
          <Heroicons.Outline.XIcon
            className="absolute z-50 top-0 right-4 w-8 h-8 p-2 border-2 border-slate-400 fill-white stroke-white hover:bg-slate-500 rounded-full bg-slate-900"
          />
        </div>
        <YoutubePlayer
          url={videoPlayState.url}
          playing={videoPlayState.playing}
          controls={true}
          width={`${(windowSize.width - 32)->Js.Int.toString}px`}
          height={`${(windowSize.height - 32)->Js.Int.toString}px`}
        />
      </ModalDialog>
    </main>
  }
}
