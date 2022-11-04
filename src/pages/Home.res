let {string} = module(React)

let sidebarOpenRef = ref(true)

@react.component
let make = () => {
  open HeadlessUI
  let (sidebarOpen, setSidebarOpen) = React.useState(_ => sidebarOpenRef.contents)

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
    <div className="w-[18rem] z-0">
      <Transition show={sidebarOpenRef.contents}>
        <div className="relative w-[16rem]">
          <div className="fixed inset-0 flex w-[16rem] z-0">
            <Transition.Child
              enter="transition ease-in-out duration-300 transform"
              enterFrom="-translate-x-full"
              enterTo="translate-x-0"
              leave="transition ease-in-out duration-300 transform"
              leaveFrom="translate-x-0"
              leaveTo="-translate-x-full">
              <div
                className="relative flex h-full w-[16rem] flex-1 flex-col shadow-md shadow-gray-100 pt-2">
                <Transition.Child
                  enter="ease-in-out duration-300"
                  enterFrom="opacity-0"
                  enterTo="opacity-100"
                  leave="ease-in-out duration-300"
                  leaveFrom="opacity-100"
                  leaveTo="opacity-0">
                  <div className="absolute top-0 right-0 pt-2" />
                </Transition.Child>
                <GenreList />
              </div>
            </Transition.Child>
          </div>
        </div>
      </Transition>
    </div>
    <div className="flex flex-1 flex-col h-full z-50 bg-white">
      <div className={`${sidebarOpenRef.contents ? "ml-[16rem]" : ""}`}>


      

        <div className="w-full flex flex-col flex-1 bg-red-500">
          <div className="h-auto w-auto flex flex-col">
            <div
              id="navbar"
              className="sticky top-0 z-40 flex h-16 flex-shrink-0 bg-white shadow-gray-100 shadow-md">
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
                  className="h-8 w-8 fill-400 hover:fill-slate-600 fill-slate-400 rounded-r-full py-1 bg-gradient-to-br from-slate-50 to-gray-100"
                />
              </button>
              <div id="search-colorswatch-container" className="flex flex-1 justify-between px-4">
                <div
                  id="search-container"
                  className="relative w-[14rem] md:w-[26rem] text-slate-500 focus-within:text-slate-600 flex items-center m-auto">
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
                <div id="colorswatch-container" className="ml-4 flex items-center md:ml-6">
                  <button>
                    <Heroicons.Solid.SunIcon
                      className="h-5 w-5 fill-klor-400 hover:fill-klor-600"
                    />
                  </button>
                  <button>
                    <Heroicons.Solid.MoonIcon
                      className="h-5 w-5 fill-klor-400 hover:fill-klor-600"
                    />
                  </button>
                  <GithubButton />
                </div>
              </div>
            </div>
            <div className="pt-[2rem]">
              <MoviesProvider> {component} </MoviesProvider>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
}
