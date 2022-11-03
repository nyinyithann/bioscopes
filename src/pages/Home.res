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
    <Transition show={sidebarOpenRef.contents}>
      <Dialog
        className="relative"
        onClose={_ => {
          sidebarOpenRef.contents = true
          setSidebarOpen(_ => true)
        }}>
        <div className="fixed inset-0 flex">
          <Transition.Child
            enter="transition ease-in-out duration-300 transform"
            enterFrom="-translate-x-full"
            enterTo="translate-x-0"
            leave="transition ease-in-out duration-300 transform"
            leaveFrom="translate-x-0"
            leaveTo="-translate-x-full">
            <Dialog.Panel
              className="relative flex h-full w-[16rem] flex-1 flex-col shadow-md shadow-gray-400 pt-2">
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
            </Dialog.Panel>
          </Transition.Child>
          <div className="w-14 flex-shrink-0" />
        </div>
      </Dialog>
    </Transition>
    <div id="navbar-main-data-container" className="flex flex-1 flex-col h-screen">
      <div className={`${sidebarOpenRef.contents ? "ml-[16rem]" : ""}`}>
        <div
          id="navbar"
          className="sticky top-0 z-10 flex h-16 flex-shrink-0 bg-white md:shadow-white shadow-slate-300 shadow-md">
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
              className="h-8 w-8 fill-400 hover:fill-indigo-500 fill-yellow-900 rounded-r-full py-1 bg-gradient-to-br from-rose-50 to-yellow-100"
            />
          </button>
          <div id="search-colorswatch-container" className="flex flex-1 justify-between px-4">
            <div
              id="search-container"
              className="relative w-full text-slate-500 focus-within:text-slate-600 flex items-center">
              <div className="pointer-events-none absolute inset-y-0 left-1 flex items-center">
                <Heroicons.Solid.SearchIcon className="h-5 w-5" />
              </div>
              <input
                id="search-field"
                className="block w-full pl-8 pr-3 text-gray-900 placeholder-slate-400 outline-none ring-0 border-b-[1px] border-b-slate-200 focus:placeholder-slate-500 focus:outline-none focus:ring-0 focus:border-b-slate-300 border-t-0 border-x-0 sm:text-sm"
                placeholder="Search"
                type_="search"
                name="search"
              />
            </div>
            <div id="colorswatch-container" className="ml-4 flex items-center md:ml-6">
              <button>
                <Heroicons.Solid.SunIcon className="h-5 w-5 fill-klor-400 hover:fill-klor-600" />
              </button>
              <button>
                <Heroicons.Solid.MoonIcon className="h-5 w-5 fill-klor-400 hover:fill-klor-600" />
              </button>
              <GithubButton />
            </div>
          </div>
        </div>
        <div id="main-data-container" className="w-full h-[calc(100vh-4rem)] flex flex-1 p-4">
          <div className="flex flex-1 h-full w-full overflow-y-auto z-40">
            <MoviesProvider> {component} </MoviesProvider>
          </div>
        </div>
      </div>
    </div>
  </div>
}
