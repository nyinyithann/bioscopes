let {string} = module(React)

module AuthorLink = {
  @react.component
  let make = (~link: string, ~site: string, ~title: string) => {
    <div>
      <span className="text-600 font-general"> {`${site}:`->string} </span>
      <a href={link} target="blank" className="hover:cursor-pointer hover:text-600 text-400 pl-2">
        {title->string}
      </a>
    </div>
  }
}

module Bioscopes = {
  @react.component
  let make = () => {
    let onClick = e => {
      ReactEvent.Mouse.preventDefault(e)
      RescriptReactRouter.push("/")
    }
    <div
      role="button"
      className="text-base sm:text-xl md:text-2xl font-extrabold bg-gradient-to-r from-klor-400 via-klor-500 to-klor-400 text-yellow-200 flex items-center justify-start gap-2 py-[0.2rem] px-[0.6rem] rounded-full shadow-md shadow-klor-300"
      onClick>
      <Heroicons.Solid.CameraIcon className="h-3 w-3 pl-1" />
      {"BIOSCOPES"->React.string}
      <Heroicons.Solid.CameraIcon className="h-3 w-3 pr-1" />
    </div>
  }
}

@react.component
let make = () => {
  <div
    className="flex flex-col gap-2 text-600 font-sans text-center w-full h-screen items-center justify-center dark:text-slate-100">
    <div className="flex flex-col items-center justify-center -mt-40">
      <Bioscopes />
      <div className="flex flex-col gap-4 items-center justify-center md:text-2xl font-bold pt-4">
        <span>
          {"Built in "->React.string}
          <a
            target="_blank"
            href="https://rescript-lang.org/"
            rel="noopener"
            className="underline text-red-500 font-brand">
            {"ReScript"->React.string}
          </a>
        </span>
        <span>
          {"Data provided by "->React.string}
          <a
            target="_blank"
            href="https://www.themoviedb.org/"
            rel="noopener"
            className="underline font-brand">
            {"TMDB"->React.string}
          </a>
        </span>
      </div>
      <div className="pt-4">
        <a
          target="_blank"
          rel="noreferrer"
          className="text-800 underline text-xl md:text:xl text-center inline font-sans font-semibold"
          href="https://github.com/nyinyithann/rescript-react-webpack-tailwind-template">
          {"GitHub Repo"->string}
        </a>
      </div>
      <div className="pt-2 text-base">
        <div
          className="flex flex-col justify-center items-center font-normal  mt-4 pt-2 border-t border-200 dark:border-slate-400">
          <div className="w-24 h-24 relative">
            <img
              src="https://avatars.githubusercontent.com/u/156037"
              alt="mygithub"
              className="w-full h-full rounded-full border-4 border-300"
            />
            <span
              className="bg-900 rounded-full text-xs text-200 p-1 absolute right-1 -top-1 border-2 border-300 dark:bg-slate-500 dark:text-white">
              {"By"->string}
            </span>
          </div>
          <AuthorLink link="https://github.com/nyinyithann" title="@nyinyithann" site="GitHub" />
          <AuthorLink
            link="https://www.linkedin.com/in/nyinyithan/" title="@nyinyithann" site="LinkedIn"
          />
          <AuthorLink link="https://twitter.com/JazzTuyat" title="@JazzTuyat" site="Twitter" />
        </div>
      </div>
    </div>
  </div>
}
