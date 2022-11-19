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
    className="w-[8rem] flex items-center justify-center text-base rounded-md text-700 py-1 px-2 outline-none ring-0 hover:bg-300">
    <Listbox value={selectedRef.contents} onChange>
      <div className="w-full relative flex">
        <Listbox.Button
          className="flex w-full h-full items-center justify-center cursor-pointer ring-0 outline-none">
          <span className="flex m-auto truncate "> {selectedRef.contents.name->string} </span>
          <div className="ml-auto">
            <Heroicons.Solid.ChevronDownIcon className="w-4 h-4" />
          </div>
        </Listbox.Button>
        <Listbox.Options
          className="absolute top-[2rem] -left-10 w-[10rem] rounded bg-200 py-1 outline-none ring-0">
          {filter_data
          ->Belt.Array.map(item =>
            <Listbox.Option key={item.id} value={item} className="flex w-full">
              {({active, selected}) => {
                <div className={`${active ? "bg-300" : ""} flex w-full pl-2 items-center p-[1px]`}>
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
      </div>
    </Listbox>
  </div>
}
