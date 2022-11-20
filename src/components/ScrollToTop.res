let {string, array} = module(React)

@react.component
let make = () => {
  let (isVisible, setVisibility) = React.useState(_ => false)

  let toggleVisibility = _ => {
    if Webapi.Dom.Window.pageYOffset(Webapi__Dom.window) > 300. {
      setVisibility(_ => true)
    } else {
      setVisibility(_ => false)
    }
  }

  let getVisibility = isVisible => {
    isVisible
      ? ReactDOM.Style.make(~visibility="visible", ())
      : ReactDOM.Style.make(~visibility="hidden", ())
  }

  let up = () => {
    Webapi.Dom.Window.scrollToWithOptions(
      Webapi.Dom.window,
      {
        "behavior": "smooth",
        "top": 0.,
        "left": 0.,
      },
    )
  }

  let clickToTop = e => {
    ReactEvent.Mouse.preventDefault(e)
    up()
  }

  let touchToTop = e => {
    ReactEvent.Touch.preventDefault(e)
    up()
  }

  React.useEffect0(() => {
    Webapi.Dom.Window.addEventListener(Webapi.Dom.window, "scroll", toggleVisibility)
    Some(
      () => {
        Webapi.Dom.Window.removeEventListener(Webapi.Dom.window, "scroll", toggleVisibility)
      },
    )
  })

  <button
    type_="button"
    onClick={clickToTop}
    onTouchStart={touchToTop}
    className="z-50 flex w-auto gap-2 justify-center p-[0.8rem] group rounded-full ring-0 outline-none bg-white bg-opacity-40 backdrop-blur-lg drop-shadow-lg hover:bg-opacity-80 hover:cursor-pointer shadow-md shadow-slate-100  dark:shadow-slate-700"
    style={getVisibility(isVisible)}>
    <Heroicons.Solid.ArrowUpIcon className="w-6 h-6 fill-klor-900" />
  </button>
}
