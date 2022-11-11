open DomBinding

let getMatchMedia = query => Webapi.Dom.Window.matchMedia(Webapi.Dom.window, query)
let matchMedia = query => matches(getMatchMedia(query))

let useMediaQuery = (query: string): bool => {
  let (matches, setMatches) = React.useState(_ => matchMedia(query))

  let handleChange = _ => setMatches(_ => matchMedia(query))

  React.useEffect1(() => {
    setMatches(_ => matchMedia(query))
    Webapi.Dom.Window.addEventListener(Webapi__Dom.window, "resize", handleChange)
    Some(() => Webapi.Dom.Window.removeEventListener(Webapi__Dom.window, "resize", handleChange))
  }, [query])

  matches
}
