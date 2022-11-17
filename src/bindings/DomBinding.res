@val external htmlDoc: Dom.document = "window.document"
@set external setTitle: (Dom.document, string) => unit = "title"
@get external getTitle: (Dom.document) => string = "title"

@get external matches: Webapi.Dom.Window.mediaQueryList => bool = "matches"

@send
external addEventListener: (
  Webapi.Dom.Window.mediaQueryList,
  string,
  Webapi.Dom.Event.t => unit,
) => unit = "addEventListener"

@send
external removeEventListener: (
  Webapi.Dom.Window.mediaQueryList,
  string,
  Webapi.Dom.Event.t => unit,
) => unit = "removeEventListener"

@send external alert: (Webapi.Dom.Window.t, string) => unit = "alert"
let pop = msg => alert(Webapi.Dom.window, msg)

@send external toLocaleString: (Js.Date.t, string, {..}) => string = "toLocaleString"
@send external floatToLocaleString: (float, string) => string = "toLocaleString"

let getWindowInnerHeight = () => Webapi.Dom.Window.innerHeight(Webapi__Dom.window)
let getWindowInnerWidth = () => Webapi.Dom.Window.innerWidth(Webapi__Dom.window)

@val @scope(("window", "location")) external reload: unit => unit = "reload"
