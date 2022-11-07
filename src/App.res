let {string, useState} = module(React)

@react.component
let make = () => {
  open ReactBinding
  let lazyHome = React.createElement(
    Lazy.lazy_(() =>
      Lazy.import_("./pages/Home.js")->Js.Promise.then_(
        comp => Js.Promise.resolve({"default": comp["make"]}),
        _,
      )
    ),
    {"id": None},
  )

  let lazyAbout = React.createElement(
    Lazy.lazy_(() =>
      Lazy.import_("./pages/About.js")->Js.Promise.then_(
        comp => Js.Promise.resolve({"default": comp["make"]}),
        _,
      )
    ),
    {"id": None},
  )

  let url = RescriptReactRouter.useUrl()
  let component = switch url.path {
  | list{}
  | list{"genre"}
  | list{"search"}
  | list{"movie", ..._}
  | list{"person", ..._} =>
    <SuspensionLoader> lazyHome </SuspensionLoader>
  | list{"about"} => <SuspensionLoader> lazyAbout </SuspensionLoader>
  | _ => <NotFound />
  }

  let (theme, setTheme) = ThemeHook.useTheme("theme-gray")
  <ThemeSwitchProvider value=setTheme>
    <div className={`${theme} flex flex-col`}>
      <ErrorBoundary>
        <div className="h-screen bg-white dark:bg-slate-500">
          <div> {component} </div>
        </div>
      </ErrorBoundary>
    </div>
  </ThemeSwitchProvider>
}
