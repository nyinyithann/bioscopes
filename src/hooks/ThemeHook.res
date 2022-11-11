let themeKey = "Bioscopes_theme_key"

let useTheme = defaultTheme => {
  open Dom.Storage2
  let (storedTheme, setStoredTheme) = React.useState(_ => {
    try {
      switch localStorage->getItem(themeKey) {
      | Some(v) => v
      | None => defaultTheme
      }
    } catch {
    | _ => defaultTheme
    }
  })

  let setTheme = themeName => {
    try {
      localStorage->setItem(themeKey, themeName)
      ignore(setStoredTheme(_prev => themeName))
    } catch {
    | _ => ()
    }
  }

  (storedTheme, setTheme)
}
