let {string, array} = module(React)
open MovieModel
let filter_data = [popularity, vote_average, original_title, release_date]
let selectedRef = ref(popularity)

@react.component
let make = () => {
  open HeadlessUI
  let (queryParam, setQueryParam) = UrlQueryParam.useQueryParams()

  React.useMemo1(() => {
    switch queryParam {
    | UrlQueryParam.Genre({sort_by}) =>
      switch filter_data->Belt.Array.getBy(x => x.id == sort_by) {
      | Some(x) => selectedRef.contents = x
      | None => ()
      }
    | _ => ()
    }
  }, [queryParam])

  let onChange = v => {
    selectedRef.contents = v

    switch queryParam {
    | Genre({id, name, display, page}) =>
      setQueryParam(UrlQueryParam.Genre({id, name, display, page, sort_by: v.id}))
    | _ => ()
    }
  }

  <div
    className="w-[10rem] flex items-center justify-center text-[0.9rem] rounded bg-200 text-700 py-1 px-2 outline-none ring-0 hover:bg-300">
    <Listbox value={selectedRef.contents} onChange>
      <Listbox.Button
        className="relative flex w-full h-full items-center justify-center cursor-pointer ring-0 outline-none">
        <span className="block truncate"> {selectedRef.contents.name->string} </span>
        <div className="ml-auto">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            className="w-6 h-6">
            <path
              fillRule="evenodd"
              d="M11.47 4.72a.75.75 0 011.06 0l3.75 3.75a.75.75 0 01-1.06 1.06L12 6.31 8.78 9.53a.75.75 0 01-1.06-1.06l3.75-3.75zm-3.75 9.75a.75.75 0 011.06 0L12 17.69l3.22-3.22a.75.75 0 111.06 1.06l-3.75 3.75a.75.75 0 01-1.06 0l-3.75-3.75a.75.75 0 010-1.06z"
              clipRule="evenodd"
            />
          </svg>
        </div>
      </Listbox.Button>
      <Listbox.Options
        className="absolute mt-[11.2rem] w-[10rem] rounded bg-200 py-2 outline-none ring-0">
        {filter_data
        ->Belt.Array.map(item =>
          <Listbox.Option key={item.id} value={item} className="flex w-full">
            {({active, selected}) => {
              <div className={`${active ? "bg-300" : ""} flex w-full pl-2 p-1`}>
                {selected
                  ? <Heroicons.Solid.CheckIcon className="h-6 w-6 fill-klor-500" />
                  : <span className="block h-6 w-6" />}
                <span className={` w-full pl-4`}> {item.name->string} </span>
              </div>
            }}
          </Listbox.Option>
        )
        ->array}
      </Listbox.Options>
    </Listbox>
  </div>
}
