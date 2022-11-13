let {int, string} = module(React)

type state = {
  url: string,
  index: int,
  leftAvailable: bool,
  rightAvailable: bool,
  loaded: bool,
}

let baseBtnClass = "flex items-center justify-center ring-0 outline-none bg-white bg-opacity-20 backdrop-blur-lg drop-shadow-lg p-1 group hover:bg-opacity-80"

let getLeftRightAvailability = (imgCount, index) => {
  (index > 0, index < imgCount)
}

@react.component
let make = (~imageUrls: array<string>, ~currentImageIndex: int, ~width: int, ~height: int) => {
  let getUrl = i =>
    try {
      Belt.Array.getExn(imageUrls, i)
    } catch {
    | _ => ""
    }

  let (lhs, rhs) = getLeftRightAvailability(Belt.Array.length(imageUrls), currentImageIndex)

  let (state, setState) = React.useState(_ => {
    url: getUrl(currentImageIndex),
    index: currentImageIndex,
    leftAvailable: lhs,
    rightAvailable: rhs,
    loaded: false,
  })

  let containerSize = ReactDOM.Style.make(
    ~width=Js.Int.toString(width - 16) ++ "px",
    ~height=Js.Int.toString(height) ++ "px",
    (),
  )

  let imgSize = ReactDOM.Style.make(
    ~width=Js.Int.toString(width) ++ "px",
    ~height=Js.Int.toString(height - 48) ++ "px",
    (),
  )

  let next = e => {
    ReactEvent.Mouse.preventDefault(e)
    let imgCount = Belt.Array.length(imageUrls)
    let nextIndex = state.index + 1
    if nextIndex < imgCount {
      let (lhs, rhs) = getLeftRightAvailability(imgCount, nextIndex)
      setState(_ => {
        url: getUrl(nextIndex),
        index: nextIndex,
        leftAvailable: lhs,
        rightAvailable: rhs,
        loaded: false,
      })
    }
  }

  let prev = e => {
    ReactEvent.Mouse.preventDefault(e)
    let imgCount = Belt.Array.length(imageUrls)
    let prevIndex = state.index - 1
    if prevIndex >= 0 {
      let (lhs, rhs) = getLeftRightAvailability(imgCount, prevIndex)
      setState(_ => {
        url: getUrl(prevIndex),
        index: prevIndex,
        leftAvailable: lhs,
        rightAvailable: rhs,
        loaded: false,
      })
    }
  }

  <div className="relative flex flex-col items-center justify-center" style={containerSize}>
    <div className="flex flex-col items-center justify-center">
      {!state.loaded
        ? <div
            className={`absolute top-[${Js.Int.toString(
                height / 2,
              )} ++ "px"] w-full h-full flex flex-col items-center justify-center animate-pulse bg-50`}>
            <Loading
              className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-white text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
            />
          </div>
        : React.null}
      <img
        style={imgSize}
        className="object-contain m-auto"
        src={state.url}
        onLoad={_ =>
          setState(prev => {
            url: prev.url,
            index: prev.index,
            leftAvailable: prev.leftAvailable,
            rightAvailable: prev.rightAvailable,
            loaded: true,
          })}
        onError={e => {
          open ReactEvent.Media
          if target(e)["src"] !== Links.placeholderImage {
            target(e)["src"] = Links.placeholderImage
          }
        }}
      />
    </div>
    <div
      className="flex items-center justify-center mt-auto z-50 p-[8px] rounded-t-2xl bg-white bg-opacity-20 backdrop-blur-lg drop-shadow-lg absolute bottom-0">
      <button
        type_="button"
        className={`${baseBtnClass} rounded-l-full`}
        disabled={!state.leftAvailable}
        onClick={prev}>
        <Heroicons.Solid.ArrowNarrowLeftIcon className="w-6 h-6 fill-klor-500" />
      </button>
      <span
        className="rounded-md px-6 py-2 text-white text-center w-[4rem] flex items-center justify-center">
        {`${(state.index + 1)->Js.Int.toString}/${Belt.Array.length(
            imageUrls,
          )->Js.Int.toString}`->string}
      </span>
      <button
        type_="button"
        className={`${baseBtnClass} rounded-r-full`}
        disabled={!state.rightAvailable}
        onClick={next}>
        <Heroicons.Solid.ArrowNarrowRightIcon className="w-6 h-6 fill-klor-500" />
      </button>
    </div>
  </div>
}
