let {string, int, float, array} = module(React)

type video_config = {
  url: string,
  playing: bool,
}

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
    let {play} = YoutubePlayerProvider.useVideoPlayerContext()
    let vkey = Util.getOrEmptyString(video.key)

    let onClick = e => {
      ReactEvent.Mouse.preventDefault(e)
      play(Links.getYoutubeVideoLink(vkey))
    }

    <>
      {!Util.isEmptyString(vkey)
        ? <div className="flex relative items-center justify-center">
            {!loaded
              ? <div
                  className={`absolute top-[50px] w-full h-full flex flex-col items-center justify-center`}>
                  <Loading
                    className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
                  />
                </div>
              : React.null}
            <div className="relative flex-inline" role="button" onClick>
              <img
                alt="Poster"
                className
                src={Links.getYoutubeImageLink(vkey)}
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
                <Heroicons.Solid.PlayIcon
                  className="h-8 w-8 fill-klor-transparent stroke-white group-hover:fill-klor-400"
                />
              </div>
            </div>
          </div>
        : React.null}
    </>
  }
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let videos = getVideos(~movie)

  if Util.isEmptyArray(videos) {
    <NotAvailable thing={"videos"} />
  } else {
    <ul
      className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-2 justify-center w-full list-none">
      {videos
      ->Belt.Array.map(video =>
        <li key={Util.getOrEmptyString(video.key)}>
          <VideoImage video className="w-full border-[2px] border-slate-200 rounded-md" />
        </li>
      )
      ->array}
    </ul>
  }
}
