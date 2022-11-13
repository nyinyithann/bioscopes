let {int, string} = module(React)

type state = {
    url : string,
    index: int
}

let baseBtnClass = "flex items-center justify-center bg-white bg-opacity-20 backdrop-blur-lg drop-shadow-lg p-2 group"

@react.component
let make = (~imageUrls: array<string>, ~currentImageIndex: int, ~width: int, ~height: int) => {
    let getCurrentUrl = () => 
        try { Belt.Array.getExn(imageUrls, currentImageIndex)
    } catch { | _ => "" }
    let (state, setState) = React.useState(_ => { url : "" , index : currentImageIndex })
  let style = ReactDOM.Style.make(
    ~width=Js.Int.toString(width) ++ "px",
    ~height=Js.Int.toString(height) ++ "px",
    (),
  )
  <div className="flex flex-col" style>
    <div className="bg-blue-500 h-10" />
    <div className="flex items-end justify-center p-2 gap-2 mt-auto">
      <div className="flex items-center justify-center p-2 rounded-t-full bg-200 self-baseline">
        <button type_="button" className={`${baseBtnClass} rounded-l-full`}>
          <Heroicons.Solid.ArrowNarrowLeftIcon className="w-6 h-6 fill-klor-500" />
        </button>
        <span className="rounded-md px-6 py-2"> {"1/6"->string} </span>
        <button type_="button" className={`${baseBtnClass} rounded-r-full`}>
          <Heroicons.Solid.ArrowNarrowRightIcon className="w-6 h-6 fill-klor-500" />
        </button>
      </div>
    </div>
  </div>
}
