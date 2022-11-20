let {string} = module(React)

open ReactBinding
let lazyMovieList = React.createElement(
  Lazy.lazy_(() =>
    Lazy.import_("../components/movie_list/MovieList.js")->Js.Promise.then_(
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
    Lazy.import_("../components/person/Person.js")->Js.Promise.then_(
      comp => Js.Promise.resolve({"default": comp["make"]}),
      _,
    )
  ),
  (),
)

module NavLink = {
  @react.component
  let make = (~title: string) => {
    let onClick = e => {
      ReactEvent.Mouse.preventDefault(e)
      RescriptReactRouter.push("/")
    }
    <button
      type_="button"
      className="flex gap-1 items-center justify-center p-1 group rounded-full sm:rounded-md ring-0 outline-none bg-200 hover:bg-300 text-[1.1rem] font-semibold"
      onClick>
      <Heroicons.Solid.HomeIcon className="w-6 h-6 fill-klor-900" />
      <div className="hidden sm:flex flex-col items-end justify-end pt-[0.4rem] pr-2">
        <span className="text-900 m-auto"> {title->React.string} </span>
      </div>
    </button>
  }
}

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  let component = switch url.path {
  | list{}
  | list{"genre"}
  | list{"search"} =>
    <SuspensionLoader> lazyMovieList </SuspensionLoader>
  | list{"movie"} =>
    <SuspensionLoader>
      <YoutubePlayerProvider> lazyMovie </YoutubePlayerProvider>
    </SuspensionLoader>
  | list{"person"} => <Person />
  | _ => <NotFound />
  }

  <div className="flex flex-col w-full h-full">
    <div className="h-auto flex w-full flex-col z-50 relative">
      <div
        id="navbar"
        className="flex items-center w-full bg-white sticky top-0 z-50 h-14 flex-shrink-0 shadow-md bg-clip-padding backdrop-filter backdrop-blur-xl bg-opacity-50">
        <div className="pl-2 mr-auto">
          <NavLink title={"Home"} />
        </div>
        <div
          id="search-colorswatch-container"
          className="flex w-full items-center px-2 sm:items-end md:w-[30rem]">
          <SearchBox />
        </div>
        <div id="colorswatch-container" className="flex items-center justify-center gap-2 pr-2">
          <ThemeMenu />
          <GithubButton />
        </div>
      </div>
      <div className="z-30 bg-white">
        <MoviesProvider> {component} </MoviesProvider>
      </div>
      <footer className="h-8" />
      <div
        className="z-50 m:right-[18.5rem] fixed bottom-[1rem] right-[1rem] flex flex-none shrink-0 items-center justify-center rounded-full hover:cursor-pointer hover:outline-none hover:ring-0 md:bottom-[1.3rem] active:ring-0 active:outline-none">
        <ScrollToTop />
      </div>
    </div>
  </div>
}

let make = React.memo(make)
