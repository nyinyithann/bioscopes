let {string} = module(React)

let sidebarOpenRef = ref(true)

@react.component
let make = () => {
  open HeadlessUI
  let (sidebarOpen, setSidebarOpen) = React.useState(_ => sidebarOpenRef.contents)

  React.useMemo0(() => {
    sidebarOpenRef.contents = DomBinding.checkMediaQuery("(min-width: 600px)")
  })

  React.useEffect1(() => {
    sidebarOpenRef.contents = sidebarOpen
    None
  }, [sidebarOpen])

  open ReactBinding
  let lazyMovieList = React.createElement(
    Lazy.lazy_(() =>
      Lazy.import_("../components/MovieList.js")->Js.Promise.then_(
        comp => Js.Promise.resolve({"default": comp["make"]}),
        _,
      )
    ),
    {"id": None},
  )

  let getLazyMovie = (id: string) =>
    React.createElement(
      Lazy.lazy_(() =>
        Lazy.import_("../components/Movie.js")->Js.Promise.then_(
          comp => Js.Promise.resolve({"default": comp["make"]}),
          _,
        )
      ),
      {"id": Some(id)},
    )

  let getLazyPerson = (id: string) =>
    React.createElement(
      Lazy.lazy_(() =>
        Lazy.import_("../components/Person.js")->Js.Promise.then_(
          comp => Js.Promise.resolve({"default": comp["make"]}),
          _,
        )
      ),
      {"id": Some(id)},
    )

  let url = RescriptReactRouter.useUrl()
  let component = switch url.path {
  | list{}
  | list{"genre"}
  | list{"search"} =>
    <SuspensionLoader> lazyMovieList </SuspensionLoader>
  | list{"movie", id} => <SuspensionLoader> {getLazyMovie(id)} </SuspensionLoader>
  | list{"person", id} => <SuspensionLoader> {getLazyPerson(id)} </SuspensionLoader>
  | _ => <div> {"Todo: To create a proper component to display message"->string} </div>
  }

  <div>
    <div className="w-[12rem] sm:w-[14rem] md:w-[16rem]">
      <Transition show={sidebarOpenRef.contents}>
        <div className="relative z-40 w-[12rem] sm:w-[14rem] md:w-[16rem]">
          <div className="fixed inset-0 flex w-[12rem] sm:w-[14rem] md:w-[16rem] bg-white">
            <Transition.Child
              enter="transition ease-in-out duration-300 transform"
              enterFrom="-translate-x-full"
              enterTo="translate-x-0"
              leave="transition ease-in-out duration-300 transform"
              leaveFrom="translate-x-0"
              leaveTo="-translate-x-full">
              <div
                className="relative flex h-full w-[12rem] sm:w-[14rem] md:w-[16rem] flex-1 flex-col border-r-[1px] border-r-slate-100  shadow-md pt-2">
                <Transition.Child
                  enter="ease-in-out duration-300"
                  enterFrom="opacity-0"
                  enterTo="opacity-100"
                  leave="ease-in-out duration-300"
                  leaveFrom="opacity-100"
                  leaveTo="opacity-0">
                  <div
                    className="absolute top-0 right-0 pt-2 w-[14rem] sm:w-[14rem] md:w-[16rem]"
                  />
                </Transition.Child>
                <GenreList />
              </div>
            </Transition.Child>
          </div>
        </div>
      </Transition>
    </div>
    <div
      className={`${sidebarOpenRef.contents
          ? "ml-[12rem] sm:ml-[14rem] md:ml-[16rem]"
          : ""} flex flex-1 flex-col h-full`}>
      <div className="w-full flex flex-col flex-1 bg-white">
        <div className="h-auto w-auto flex flex-col z-50">
          <div id="navbar" className="sticky top-0 z-50 flex h-14 flex-shrink-0 bg-white">
            <button
              type_="button"
              className={`${sidebarOpenRef.contents ? "hidden" : "block"} px-4 outline-none`}
              onClick={_ => {
                sidebarOpenRef.contents = true
                setSidebarOpen(_ => true)
              }}>
              <span className="sr-only"> {"Open Sidebar"->string} </span>
              <Heroicons.Solid.MenuIcon
                className="h-8 w-8 fill-400 hover:fill-yellow-100 bg-gradient-to-tr from-teal-400 to-blue-400 text-yellow-300 rounded p-1"
              />
            </button>
            <button
              type_="button"
              className={`${sidebarOpenRef.contents ? "block" : "hidden"} pr-4 outline-none`}
              onClick={_ => {
                sidebarOpenRef.contents = false
                setSidebarOpen(_ => false)
              }}>
              <span className="sr-only"> {"Close sidebar"->string} </span>
              <Heroicons.Solid.XIcon
                className="h-8 w-8 fill-400 hover:fill-klor-600 fill-klor-400 rounded-r-full py-1 bg-100"
              />
            </button>
            <div
              id="search-colorswatch-container"
              className="flex flex-1 items-center justify-end gap-2">
              <div
                id="search-container"
                className="relative w-[12rem] sm:w-[24rem] md:w-[28rem] text-slate-500 focus-within:text-slate-600 flex items-center">
                <div className="pointer-events-none absolute inset-y-0 left-1 flex items-center">
                  <Heroicons.Solid.SearchIcon className="h-5 w-5" />
                </div>
                <input
                  id="search-field"
                  className="block w-full rounded-md pl-[2rem] text-gray-900 placeholder-slate-400 outline-none ring-0 border-0 bg-100 focus:bg-200 focus:border-[1px] focus:border-slate-100 focus:placeholder-slate-500 focus:outline-none focus:ring-0 sm:text-sm"
                  placeholder="Search"
                  type_="search"
                  name="search"
                />
              </div>
              <div
                id="colorswatch-container"
                className="pr-8 place-items-start flex items-center gap-2 z-[50]">
                <ThemeMenu />
                <GithubButton />
              </div>
            </div>
          </div>
          <div className="pt-1 z-30 bg-white"> {component} </div>
          <footer className="h-8" />
        </div>
      </div>
    </div>
  </div>
}
