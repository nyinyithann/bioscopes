let {string, int, float, array} = module(React)

let getVideos = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.videos
  ->Option.map(videos => videos.results)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
}

module VideoImage = {
  @react.component
  let make = (~video: DetailMovieModel.video, ~className) => {
    let (loaded, setLoaded) = React.useState(_ => false)
    let key = Util.getOrEmptyString(video.key)
    <>
      {!Util.isEmptyString(key)
        ? <>
            {!loaded
              ? <div
                  className={`absolute top-2 w-full h-full flex flex-col items-center justify-center`}>
                  <Loading
                    className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
                  />
                </div>
              : React.null}
            <div className="relative flex-inline">
              <img
                alt="Poster"
                className
                src={Links.getYoutubeImageLink(key)}
                onLoad={_ => setLoaded(_ => true)}
                onError={e => {
                  open ReactEvent.Media
                  if target(e)["src"] !== Links.placeholderImage {
                    target(e)["src"] = Links.placeholderImage
                  }
                }}
              />
              <div
                className="absolute top-0 left-0 bottom-0 right-0 flex items-center justify-center bg-50 bg-opacity-0 sm:bg-opacity-10 hover:bg-opacity-0 hover:cursor-pointer group">
                <Heroicons.Solid.PlayIcon className="h-12 w-12 fill-klor-100 stroke-white group-hover:fill-klor-300" />
              </div>
            </div>
          </>
        : React.null}
    </>
  }
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let videos = getVideos(~movie)
  <div className="flex flex-wrap flex-shrink-0 gap-4 w-full items-center justify-start">
    {videos
    ->Belt.Array.map(video =>
      <VideoImage
        key={Util.getOrEmptyString(video.key)} video className="w-full h-[16rem]"
      />
    )
    ->array}
  </div>
}
