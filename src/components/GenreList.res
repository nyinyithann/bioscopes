type state =
  | Loading
  | Error(string)
  | Success(array<GenreModel.genre>)

let cache = ref(Js.Dict.empty())

let staticItems = [
  {
    "id": -1,
    "name": "Popular",
    "dataName": "popular",
    "icon": <Heroicons.Solid.HeartIcon className="w-3 h-3" />,
  },
  {
    "id": -2,
    "name": "Top Rated",
    "dataName": "top_rated",
    "icon": <Heroicons.Solid.TrendingUpIcon className="w-3 h-3" />,
  },
  {
    "id": -3,
    "name": "Upcoming",
    "dataName": "upcoming",
    "icon": <Heroicons.Solid.TruckIcon className="w-3 h-3" />,
  },
]

module Title = {
  @react.component
  let make = (~name: string) => {
    <div className="w-full font-nav text-lg border-b-[1px] pl-4 pb-1 border-b-indigo-100 text-500">
      {name->React.string}
    </div>
  }
}

module GenreLink = {
  @react.component
  let make = (
    ~id: int,
    ~name: string,
    ~dataName: option<string>=?,
    ~icon: option<React.element>=?,
    ~onClick,
  ) => {
    let (queryParam, _) = UrlQueryParam.useQueryParams()
    let hl = "bg-gradient-to-r from-teal-400 to-blue-400 text-yellow-200"
    let highligh = switch queryParam {
    | Category(c) if c.name == Js.Option.getWithDefault("", dataName) => hl
    | Genre(g) if g.id == id => hl
    | _ => ""
    }

    React.cloneElement(
      <button
        type_="button"
        className={`${highligh} text-base text-left active:to-blue-500 transition duration-150 ease-linear pl-[3rem] py-1 flex gap-2 items-center hover:bg-gradient-to-r hover:from-teal-400 hover:to-blue-400 hover:text-yellow-200 snap-start`}
        onClick>
        {switch icon {
        | Some(x) => x
        | None => <Heroicons.Solid.FilmIcon className="w-3 h-3" />
        }}
        {name->React.string}
      </button>,
      {
        "data-id": id,
        "data-display": name,
        "data-name": switch dataName {
        | Some(n) => n
        | None => name
        },
      },
    )
  }
}

@react.component
let make = () => {
  let (state, setState) = React.useState(_ => Loading)
  let (_, setQueryParam) = UrlQueryParam.useQueryParams()

  React.useEffect0(() => {
    let genreCallback = json => {
      switch GenreModel.GenreDecoder.decode(. ~json) {
      | Ok(genreList) =>
        Js.Dict.set(cache.contents, "genres", genreList.genres)
        setState(_ => Success(genreList.genres))
      | Error(msg) => setState(_ => Error(msg))
      }
    }
    let controller = Fetch.AbortController.make()
    switch Js.Dict.get(cache.contents, "genres") {
    | Some(genres) => setState(_ => Success(genres))
    | None =>
      MovieAPI.getGenres(
        ~callback=genreCallback,
        ~signal=Fetch.AbortController.signal(controller),
        (),
      )->ignore
    }

    Some(() => Fetch.AbortController.abort(controller, "Cancel the request"))
  })

  let onClick = React.useCallback0(e => {
    open ReactEvent.Mouse
    let dataId = target(e)["getAttribute"](. "data-id")
    let dataName = target(e)["getAttribute"](. "data-name")
    let dataDisplay = target(e)["getAttribute"](. "data-display")
    switch int_of_string_opt(dataId) {
    | Some(id) if id < 0 => setQueryParam(Category({name: dataName, display: dataDisplay, page: 1}))
    | Some(id) if id > 0 =>
      setQueryParam(
        Genre({id, name: dataName, display: dataDisplay, page: 1, sort_by: "popularity.desc"}),
      )
    | None | _ => ()
    }
  })

  <div className="flex flex-col items-start justify-center z-50">
    <div className="flex font-brand w-full items-center justify-center pb-4 gap-2">
      <div
        className="text-xl sm:text-2xl rounded-full font-extrabold bg-gradient-to-r from-teal-400 via-indigo-400 to-blue-400 text-yellow-200 flex items-center justify-center gap-2 py-[0.4rem]">
        <Heroicons.Solid.CameraIcon className="h-3 w-3 pl-1" />
        {"BIOSCOPES"->React.string}
        <Heroicons.Solid.CameraIcon className="h-3 w-3 pr-1" />
      </div>
    </div>
    {switch state {
    | Loading =>
      <Loading
        className="w-[4rem] h-[3rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
      />
    | Error(msg) =>
      <div className="flex flex-wrap w-full px-1 text-red-400">
        {React.string("Error occured while loaind genres: " ++ msg)}
      </div>
    | Success(genres) =>
      <div className="w-full">
        <div className="flex flex-col w-full">
          <Title name="Discover" />
          <div className="pt-1 w-full flex flex-col">
            {staticItems
            ->Belt.Array.map(x => {
              <GenreLink
                key={x["dataName"]}
                id={x["id"]}
                name={x["name"]}
                dataName={x["dataName"]}
                icon={x["icon"]}
                onClick
              />
            })
            ->React.array}
          </div>
        </div>
        <div className="flex flex-col w-full">
          <Title name="Genres" />
          <div className="pt-1 flex flex-col items-start justify-start h-[60vh] md:h-[68vh]">
            <div
              className="w-full flex flex-col overflow-y-auto scrollbar-thin scrollbar-thumb-slate-200 scrollbar-thumb-rounded snap-y">
              {genres
              ->Belt.Array.map(x => {
                <GenreLink key={x.id->Js.Int.toString} id={x.id} name={x.name} onClick />
              })
              ->React.array}
            </div>
          </div>
        </div>
      </div>
    }}
  </div>
}
