@val external htmlDoc: Dom.document = "window.document"
@set external setTitle: (Dom.document, string) => unit = "title"

@get external matches: Webapi.Dom.Window.mediaQueryList => bool = "matches"
let checkMediaQuery = query => matches(Webapi.Dom.Window.matchMedia(Webapi.Dom.window, query))

@send external alert: (Webapi.Dom.Window.t, string) => unit = "alert"
