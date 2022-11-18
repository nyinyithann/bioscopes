let {string, int, float, array} = module(React)

open Belt

let getBackdrops = (movie: DetailMovieModel.detail_movie) =>
  movie.images
  ->Option.map(imgs => imgs.backdrops)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
  ->Array.keepMap(x => {
    let filePath = Util.getOrEmptyString(x.file_path)
    if filePath != "" {
      Some({
        PhotosViewer.id: filePath,
        url: Links.getPosterImageW533H300Bestv2Link(filePath),
        type_: #backdrop,
      })
    } else {
      None
    }
  })

let getPosters = (movie: DetailMovieModel.detail_movie) =>
  movie.images
  ->Option.map(imgs => imgs.posters)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
  ->Array.keepMap(x => {
    let filePath = Util.getOrEmptyString(x.file_path)
    if filePath != "" {
      Some({
        PhotosViewer.id: filePath,
        url: Links.getPosterImage_W370_H556_bestv2Link(filePath),
        type_: #poster,
      })
    } else {
      None
    }
  })

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let photosRef = React.useRef([])

  React.useMemo1(() => {
    photosRef.current = Array.concat(getBackdrops(movie), getPosters(movie))
  }, [movie])

  <div className="flex w-full items-center justify-center p-2">
    <PhotosViewer photos={photosRef.current} />
  </div>
}
