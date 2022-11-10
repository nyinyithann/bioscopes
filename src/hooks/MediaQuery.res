open DomBinding

let getMatchMedia = query => Webapi.Dom.Window.matchMedia(Webapi.Dom.window, query)
let matchMedia = query => matches(getMatchMedia(query))

let useMediaQuery = (query: string): bool => {
  let (matches, setMatches) = React.useState(_ => matchMedia(query))

  let handleChange = _ => setMatches(_ => matchMedia(query))

  React.useEffect1(() => {
    setMatches(_ => matchMedia(query))

    let matchMediaQueryList = getMatchMedia(query)
    matchMediaQueryList->addEventListener("change", handleChange)

    Some(() => matchMediaQueryList->removeEventListener("change", handleChange))
  }, [query])

  matches
}
