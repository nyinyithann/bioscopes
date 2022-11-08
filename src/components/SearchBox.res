@get external getValue: Dom.element => string = "value"
@set external setValue: (Dom.element, string) => unit = "value"

@react.component
let make = () => {
  let (queryParam, setQueryParam) = UrlQueryParam.useQueryParams()
  let inputRef = React.useRef(Js.Nullable.null)

  React.useEffect2(() => {
    switch queryParam {
    | Search({query}) =>
      switch Js.Nullable.toOption(inputRef.current) {
      | Some(elem) => setValue(elem, query)
      | None => ()
      }
    | _ => ()
    }
    None
  }, (queryParam, inputRef.current))

  let handleKeyDown = e => {
    open ReactEvent.Keyboard
    if key(e) == "Enter" {
      preventDefault(e)
      switch Js.Nullable.toOption(inputRef.current) {
      | Some(elem) => setQueryParam(UrlQueryParam.Search({query: getValue(elem), page: 1}))

      | None => ()
      }
    }
  }

  <div
    id="search-container"
    className="relative w-[12rem] sm:w-[24rem] md:w-[28rem] text-slate-500 focus-within:text-slate-600 flex items-center">
    <div className="pointer-events-none absolute inset-y-0 left-1 flex items-center">
      <Heroicons.Solid.SearchIcon className="h-5 w-5" />
    </div>
    <input
      id="search-field"
      className="block w-full rounded-md pl-[2rem] text-gray-900 placeholder-slate-400 outline-none ring-0 border-0 bg-200 hover:bg-300 focus:bg-300 focus:border-[1px] focus:border-slate-100 focus:placeholder-slate-500 focus:outline-none focus:ring-0 sm:text-sm"
      ref={ReactDOM.Ref.domRef(inputRef)}
      placeholder="Search"
      type_="search"
      name="search"
      maxLength={128}
      onKeyDown={handleKeyDown}
    />
  </div>
}
