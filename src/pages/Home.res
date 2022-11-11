let {string} = module(React)

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

module Bioscopes = {
  @react.component
  let make = () => {
    let onClick = e => {
      ReactEvent.Mouse.preventDefault(e)
      RescriptReactRouter.push("/about")
    }
    <div
      role="button"
      className="text-base sm:text-lg md:text-xl w-full font-extrabold bg-gradient-to-r from-teal-400 via-indigo-400 to-blue-400 text-yellow-200 flex items-center justify-start gap-2 py-[0.2rem] px-[0.6rem] rounded-full shadow-md shadow-klor-300"
      onClick>
      <Heroicons.Solid.CameraIcon className="h-3 w-3 pl-1" />
      {"BIOSCOPES"->React.string}
      <Heroicons.Solid.CameraIcon className="h-3 w-3 pr-1" />
    </div>
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

  | list{"movie"} => <SuspensionLoader> lazyMovie </SuspensionLoader>

  | list{"person"} => <SuspensionLoader> lazyPerson </SuspensionLoader>
  | _ => <div> {"Todo: To create a proper component to display message"->string} </div>
  }

  <div className="flex flex-col w-full h-full">
    <div className="h-auto flex flex-col z-50">
      <div id="navbar" className="flex w-full bg-white sticky top-0 z-50 h-14 flex-shrink-0">
        <div className="hidden sm:flex pl-4 m-auto pr-4">
          <Bioscopes />
        </div>
        <div
          id="search-colorswatch-container"
          className="flex flex-1 pl-4 items-center justify-between sm:justify-end gap-2">
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
}
