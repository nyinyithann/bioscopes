let {string} = module(React)

let sidebarOpenRef = ref(false)
let willNavTransparent = ref(false)

@react.component
let make = () => {
  open HeadlessUI
  let (sidebarOpen, setSidebarOpen) = React.useState(_ => sidebarOpenRef.contents)

  React.useEffect0(() => {
    sidebarOpenRef.contents = MediaQuery.matchMedia("(min-width: 600px)")
    None
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
    (),
  )

  let lazyMovie = React.createElement(
    Lazy.lazy_(() =>
      Lazy.import_("../components/detail_movie/Movie.js")->Js.Promise.then_(
        comp => Js.Promise.resolve({"default": comp["make"]}),
        _,
      )
    ),
    (),
  )

  let lazyPerson = React.createElement(
    Lazy.lazy_(() =>
      Lazy.import_("../components/Person.js")->Js.Promise.then_(
        comp => Js.Promise.resolve({"default": comp["make"]}),
        _,
      )
    ),
    (),
  )

  let url = RescriptReactRouter.useUrl()
  let component = switch url.path {
  | list{}
  | list{"genre"}
  | list{"search"} => {
      willNavTransparent.contents = false
      <SuspensionLoader> lazyMovieList </SuspensionLoader>
    }

  | list{"movie"} => {
      willNavTransparent.contents = true
      <SuspensionLoader> lazyMovie </SuspensionLoader>
    }

  | list{"person"} => <SuspensionLoader> lazyPerson </SuspensionLoader>
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
                className="relative flex h-full w-[12rem] sm:w-[14rem] md:w-[16rem] flex-1 flex-col border-r-[1px] border-r-slate-200 shadow-2xl shadow-slate-300 pt-2">
                <Transition.Child
                  enter="ease-in-out duration-300"
                  enterFrom="opacity-0"
                  enterTo="opacity-100"
                  leave="ease-in-out duration-300"
                  leaveFrom="opacity-100"
                  leaveTo="opacity-0">
                  <div
                    className="absolute top-0 right-0 pt-2 w-[14rem] sm:w-[14rem] md:w-[16rem] z-40 bg-gradient-to-t from-green-300 via-klor-100 to-slate-50"
                  />
                </Transition.Child>
                <div className="relative w-full">
                  <button
                    type_="button"
                    className={`${sidebarOpenRef.contents
                        ? "block"
                        : "hidden"} pr-4 outline-none absolute right-[-0.8rem] top-[0.3rem]`}
                    onClick={_ => {
                      sidebarOpenRef.contents = false
                      setSidebarOpen(_ => false)
                    }}>
                    <span className="sr-only"> {"Close sidebar"->string} </span>
                    <Heroicons.Solid.XIcon
                      className="h-8 w-8 fill-400 hover:fill-yellow-200 fill-yellow-300 rounded-full py-1 bg-transparent"
                    />
                  </button>
                  <GenreList />
                </div>
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
        <div className="h-auto flex flex-col z-50">
          /* <div */
          /* id="navbar" */
          /* className={`${willNavTransparent.contents */
          /* ? "bg-transparent" */
          /* : "bg-white"} sticky top-0 z-50 flex h-14 flex-shrink-0`}> */
          <div id="navbar" className="bg-white sticky top-0 z-50 flex h-14 flex-shrink-0">
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
            <div
              id="search-colorswatch-container"
              className="flex flex-1 items-center justify-end gap-2">
              <SearchBox />
              <div
                id="colorswatch-container"
                className="pr-4 place-items-start flex items-center gap-2 z-[50]">
                <ThemeMenu />
                <GithubButton />
              </div>
            </div>
          </div>
          <div className="z-30 bg-white"> {component} </div>
          <footer className="h-8" />
        </div>
      </div>
    </div>
  </div>
}
