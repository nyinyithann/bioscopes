let {string} = module(React)

@react.component
let make = () => {
  open HeadlessUI
  let (sidebarOpen, setSidebarOpen) = React.useState(_ => false)

  <div>
    <Transition show={sidebarOpen}>
      <Dialog
        className="relative z-40 md:hidden"
        onClose={_ => setSidebarOpen(_ => true)}>
        <Transition.Child
          enter="transition-opacity ease-linear duration-300"
          enterFrom="opacity-0"
          enterTo="opacity-100"
          leave="transition-opacity ease-linear duration-300"
          leaveFrom="opacity-100"
          leaveTo="opacity-0">
          <div className="fixed inset-0 bg-gray-600 bg-opacity-75" />
        </Transition.Child>
        <div className="fixed inset-0 z-40 flex">
          <Transition.Child
            enter="transition ease-in-out duration-300 transform"
            enterFrom="-translate-x-full"
            enterTo="translate-x-0"
            leave="transition ease-in-out duration-300 transform"
            leaveFrom="translate-x-0"
            leaveTo="-translate-x-full">
            <Dialog.Panel
              className="relative flex h-full w-[16rem] flex-1 flex-col bg-white pt-5 pb-4">
              <Transition.Child
                enter="ease-in-out duration-300"
                enterFrom="opacity-0"
                enterTo="opacity-100"
                leave="ease-in-out duration-300"
                leaveFrom="opacity-100"
                leaveTo="opacity-0">
                <div className="absolute top-0 right-0 -mr-12 pt-2">
                  <button
                    type_="button"
                    className="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                    onClick={_ => setSidebarOpen(_ => false)}>
                    <span className="sr-only"> {"Close sidebar"->string} </span>
                    <Heroicons.Solid.XIcon className="h-6 w-6 text-white" />
                  </button>
                </div>
              </Transition.Child>
              <GenreList />
            </Dialog.Panel>
          </Transition.Child>
          <div className="w-14 flex-shrink-0" />
        </div>
      </Dialog>
    </Transition>
    
    <div
      id="desktop-sidebar-container"
      className="hidden md:fixed md:inset-y-0 md:flex md:flex-col md:w-[16rem] border-r-[1px] border-r-gray-100 shadow-md">
      <GenreList />
    </div>
    <div id="navbar-main-data-container" className="flex flex-1 flex-col h-screen md:pl-[16rem]">
      <div
        id="navbar"
        className="sticky top-0 z-10 flex h-16 flex-shrink-0 bg-white md:shadow-white shadow-slate-300 shadow-md">
        <button
          type_="button"
          className="px-4 outline-none md:hidden"
          onClick={_ => setSidebarOpen(_ => true)}>
          <span className="sr-only"> {"Open Sidebar"->string} </span>
          <Heroicons.Solid.MenuIcon className="h-6 w-6 fill-400 hover:fill-indigo-500" />
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
      <div id="main-data-container" className="w-full h-screen flex flex-1 p-4">
      <div id="movie-list-here" className="w-full h-full flex bg-100">
      {"hi"->React.string}
      </div>
      </div>
    </div>
  </div>
}
