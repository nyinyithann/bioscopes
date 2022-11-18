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

  let handleChange = e => {
    ReactEvent.Form.preventDefault(e)
    let v = ReactEvent.Form.target(e)["value"]
    if v == "" {
      switch queryParam {
      | Search(_) =>
        setQueryParam(UrlQueryParam.Category({name: "popular", display: "Popular", page: 1}))
      | _ => ()
      }
    }
  }

  <div
    id="search-container"
    className="relative text-slate-500 focus-within:text-slate-600 flex items-center w-full">
    <div className="pointer-events-none absolute inset-y-0 left-1 flex items-center">
      <Heroicons.Solid.SearchIcon className="h-5 w-5 fill-klor-400" />
    </div>
    <input
      id="search-field"
      className="block w-full pl-[2rem] placeholder-klor-400 outline-none ring-0 border-t-0 border-r-0 border-l-0 border-b-[1px] border-b-400 hover:border-b-500 focus:placeholder-slate-500 focus:outline-none focus:ring-0 text-900 active:ring-0 active:outline-none rounded-md"
      ref={ReactDOM.Ref.domRef(inputRef)}
      placeholder="Search"
      type_="search"
      name="search"
      maxLength={64}
      onChange={handleChange}
      onKeyDown={handleKeyDown}
    />
  </div>
}
