type window_size = {
  width: int,
  height: int,
}

let useWindowSize = () => {
  let (windowSize, setWindowSize) = React.useState(_ => {width: 0, height: 0})

  let handleSize = React.useCallback1( _ => {
      Js.log(DomBinding.getWindowInnerWidth())
    setWindowSize(_ => {
      width: DomBinding.getWindowInnerWidth(),
      height: DomBinding.getWindowInnerHeight(),
    })
  }, [])

  React.useEffect1(() => {
    Webapi.Dom.Window.addEventListener(Webapi__Dom.window, "resize", handleSize)
    Some(() => Webapi.Dom.Window.removeEventListener(Webapi__Dom.window, "resize", handleSize))
  },[handleSize])

  React.useLayoutEffect1(() => {
    setWindowSize(_ => {
      width: DomBinding.getWindowInnerWidth(),
      height: DomBinding.getWindowInnerHeight(),
    })
    None
  }, [])

  windowSize
}
