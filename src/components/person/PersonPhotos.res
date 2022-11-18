let {string, int, float, array} = module(React)

@react.component
let make = (~person: PersonModel.person) => {
  let photosRef = React.useRef([])

  React.useMemo1(() => {
    open Belt
    photosRef.current =
      person.images
      ->Option.map(x => x.profiles)
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
  }, [person])

  <div className="flex w-full items-center justify-center p-2">
    <PhotosViewer photos={photosRef.current} />
  </div>
}
