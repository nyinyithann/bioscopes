let {string} = module(React)

type theme = {color: string, name: string}
type theme_category = {category: string, themes: array<theme>}
let themeList: array<theme_category> = [
  {
    category: "gray",
    themes: [
      {color: "#000000", name: "dark"},
      {color: "#94A3B8", name: "theme-slate"},
      {color: "#A3A3A3", name: "theme-neutral"},
      {color: "#cccccc", name: "theme-lightgray"},
    ],
  },
  {
    category: "rose",
    themes: [
      {color: "#FB7185", name: "theme-rose"},
      {color: "#F472B6", name: "theme-pink"},
      {color: "#ff9494", name: "theme-monalisa"},
      {color: "#cf9068", name: "theme-coffee"},
    ],
  },
  {
    category: "orange",
    themes: [
      {color: "#FB923C", name: "theme-orange"},
      {color: "#b2ad55", name: "theme-olive"},
      {color: "#FACC15", name: "theme-yellow"},
      {color: "#e8e121", name: "theme-sunflower"},
    ],
  },
  {
    category: "green",
    themes: [
      {color: "#4ADE80", name: "theme-green"},
      {color: "#34D399", name: "theme-emerald"},
      {color: "#2DD4BF", name: "theme-teal"},
      {color: "#A3E635", name: "theme-lime"},
    ],
  },
  {
    category: "blue",
    themes: [
      {color: "#60A5FA", name: "theme-blue"},
      {color: "#38BDF8", name: "theme-sky"},
      {color: "#22D3EE", name: "theme-cyan"},
      {color: "#a2b3d7", name: "theme-polo"},
    ],
  },
  {
    category: "indigo",
    themes: [
      {color: "#818CF8", name: "theme-indigo"},
      {color: "#A78BFA", name: "theme-violet"},
      {color: "#C084FC", name: "theme-purple"},
      {color: "#E879F9", name: "theme-fuchsia"},
    ],
  },
]

module ColorButton = {
  @react.component
  let make = (~color, ~theme, ~onClick) => {
    React.cloneElement(
      <button
        type_="button"
        ariaLabel="color"
        className="flex h-8 w-8 items-center justify-center rounded-full p-1 shadow hover:ring-2 hover:ring-400 focus:shadow-600 focus:outline-none dark:shadow-xl dark:shadow-gray-800 md:h-6 md:w-6"
        style={ReactDOM.Style.make(~backgroundColor=color, ())}
        onClick
      />,
      {"data-theme": theme},
    )
  }
}
@react.component
let make = () => {
  let setTheme = React.useContext(ThemeSwitchProvider.themeSwitchContext)

  let onClick = React.useCallback1(e => {
    open ReactEvent.Mouse
    let theme = target(e)["getAttribute"](. "data-theme")
    setTheme(theme)
  }, [setTheme])

  open HeadlessUI
  open Belt
  <Menu className="relative z-50 flex items-center justify-center text-left">
    {<>
      <Menu.Button
        className="flex h-8 w-8 items-center justify-center rounded-full border-transparent bg-300 text-700 outline-none ring-0 hover:bg-400 hover:text-white dark:dark-button">
        <Heroicons.Solid.ColorSwatchIcon className="self-center w-5 h-5 text-900 dark:text-white" />
      </Menu.Button>
      <Menu.Items
        className="absolute right-14 top-9 mt-3 flex w-[12rem] origin-top-right flex-col rounded shadow-md border-[1px] focus:outline-none dark:border-[1px] dark:border-slate-500 dark:bg-slate-600 md:w-40 gap-[1rem] p-2 bg-200">
        {themeList
        ->Array.map(({category, themes}) => {
          <div key={category} className="z-10 flex items-center justify-center bg-200 gap-[1rem]">
            {themes
            ->Array.map(({color, name}) =>
              <Menu.Item key={name} className="flex flex-row items-center justify-center gap-2 p-1">
                <ColorButton color theme={name} onClick />
              </Menu.Item>
            )
            ->React.array}
          </div>
        })
        ->React.array}
      </Menu.Items>
    </>}
  </Menu>
}
