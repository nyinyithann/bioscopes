let {string, int, float, array} = module(React)

type credit = {
  id: int,
  title: string,
  name: string,
  character: string,
  department: string,
  job: string,
  episode_count: int,
  date: Js.Date.t,
  media_type: string,
}

let y3000 = Js.Date.fromString("3000-12-31")

let getDateOr3000 = (stew: PersonModel.cast) => {
  let getOrY3000 = (date: string) => {
    try {
      Js.Date.fromString(date)
    } catch {
    | _ => y3000
    }
  }
  switch (Util.getOrEmptyString(stew.release_date), Util.getOrEmptyString(stew.first_air_date)) {
  | ("", "") => y3000
  | (rd, "") => getOrY3000(rd)
  | ("", fd) => getOrY3000(fd)
  | (_, _) => y3000
  }
}

let toCredit = (stew: PersonModel.cast): credit => {
  id: Util.getOrIntZero(stew.id),
  title: Util.getOrEmptyString(stew.title),
  name: Util.getOrEmptyString(stew.name),
  character: Util.getOrEmptyString(stew.character),
  department: Util.getOrEmptyString(stew.department),
  job: Util.getOrEmptyString(stew.job),
  episode_count: Util.getOrIntZero(stew.episode_count),
  media_type: Util.getOrEmptyString(stew.media_type),
  date: getDateOr3000(stew),
}

module CreditItem = {
  @react.component
  let make = (~credit: credit) => {
    let childItem =
      <ul className="flex w-full p-1 list-none text-900 px-4 py-2">
        <li className="w-[5rem]">
          {(
            credit.date == y3000 ? "-" : credit.date->Js.Date.getFullYear->Js.Float.toString
          )->string}
        </li>
        <li className="flex w-full">
          <p className="w-full text-900">
            {`${credit.media_type == "movie" ? `${credit.title}` : `${credit.name}`}`->string}
            {credit.episode_count > 0
              ? <span className="pl-1 text-[0.9rem] text-800/90">
                  {`(${credit.episode_count->Js.Int.toString} episode)`->string}
                </span>
              : React.null}
            {credit.character != ""
              ? <span className="pl-1 text-[0.9rem] text-800/90 dark:text-slate-400">
                  {`as ${credit.character}`->string}
                </span>
              : React.null}
            {credit.job != ""
              ? <span className="pl-1 text-[0.9rem] text-800/90 dark:text-slate-400">
                  {`as ${credit.job}`->string}
                </span>
              : React.null}
          </p>
        </li>
      </ul>

    if credit.media_type == "movie" {
      open Webapi.Url
      let param: UrlQueryParam.movie_tv_param = {
        id: credit.id->Js.Int.toString,
        media_type: credit.media_type,
      }
      let seg =
        `/movie?` ++
        UrlQueryParam.Converter_movie_tv_param.stringfy(. param)
        ->URLSearchParams.make
        ->URLSearchParams.toString
      <a href={seg} rel="noopener noreferrer" className="hover:text-200"> {childItem} </a>
    } else {
      childItem
    }
  }
}

module CreditGroup = {
  @react.component
  let make = (~creditGroup) => {
    <div className="flex flex-col w-full">
      <div className="flex flex-col w-full divide-y divide-200 dark:dark-divide">
        {creditGroup
        ->Belt.Array.mapWithIndex((i, (_, credits)) => {
          credits
          ->Belt.Array.map(credit =>
            <div
              key={credit.id->Js.Int.toString}
              className={`${mod(i, 2) == 0
                  ? "bg-50 dark:bg-slate-700"
                  : "bg-100 dark:bg-slate-800/40"}`}>
              <CreditItem credit />
            </div>
          )
          ->array
        })
        ->array}
      </div>
    </div>
  }
}

@react.component
let make = (~person: PersonModel.person) => {
  open HeadlessUI
  let creditGroupsRef = React.useRef([])
  React.useMemo1(() => {
    open Belt
    let castList: array<credit> =
      person.combined_credits
      ->Option.map(c => {
        Js.Option.getWithDefault([], c.cast)->Array.map(toCredit)
      })
      ->Option.getWithDefault([])

    let castGroup =
      castList
      ->JsArray2Ex.groupBy(x => {"year": x.date->Js.Date.getFullYear, "dept": x.department})
      ->Js.Array2.sortInPlaceWith(((xd, _), (yd, _)) => xd < yd ? 1 : xd > yd ? -1 : 0)

    let crewList: array<credit> =
      person.combined_credits
      ->Option.map(c => {
        Js.Option.getWithDefault([], c.crew)->Array.map(toCredit)
      })
      ->Option.getWithDefault([])

    let crewGroups =
      crewList
      ->JsArray2Ex.groupBy(x => {"year": x.date->Js.Date.getFullYear, "dept": x.department})
      ->Js.Array2.sortInPlaceWith(((xkey, _), (ykey, _)) =>
        xkey["year"] < ykey["year"] ? 1 : xkey["year"] > ykey["year"] ? -1 : 0
      )

    creditGroupsRef.current =
      Array.concat(castGroup, crewGroups)->JsArray2Ex.groupBy(((key, _)) => key["dept"])
  }, [person])

  let tabStyle = "flex flex-col items-start justify-start w-full h-full outline-none ring-0 px-1"

  let getTabHeaderStyle = selected => {
    let base = "w-full h-full flex items-start justify-start py-2 border-b-2 border-b-100 text-600  dark:dark-sub-tab-button"
    selected ? base ++ " border-b-500 font-semibold dark:dark-sub-tab-selected" : base
  }

  <div className="flex flex-col w-full gap-4 px-2 dark:dark-bg">
    <div
      id="credit_info_tab_container" className="w-full flex flex-col items-center justify-center">
      <Tab.Group>
        {selectedIndex => {
          <div className="flex flex-col w-full">
            <Tab.List className="flex w-full flex-nowrap items-start justify-start">
              {_ => {
                <div className="flex flex-col w-full items-start justify-start">
                  {creditGroupsRef.current
                  ->JsArray2Ex.chunkBySize(4)
                  ->Belt.Array.map(x =>
                    <div className="flex w-full">
                      {x
                      ->Belt.Array.map(((key, _)) => {
                        let headerText = key == "" ? "Acting" : key
                        <Tab key={key} className={tabStyle}>
                          {props =>
                            <div className={getTabHeaderStyle(props.selected)}>
                              {`${headerText}`->string}
                            </div>}
                        </Tab>
                      })
                      ->array}
                    </div>
                  )
                  ->array}
                </div>
              }}
            </Tab.List>
            <Tab.Panels className="pt-1">
              {props => {
                creditGroupsRef.current
                ->Belt.Array.map(((_, creditGroup)) =>
                  <Tab.Panel key="all-credits-panel">
                    {props => {
                      <div className="flex w-full px-1">
                        <CreditGroup creditGroup />
                      </div>
                    }}
                  </Tab.Panel>
                )
                ->array
              }}
            </Tab.Panels>
          </div>
        }}
      </Tab.Group>
    </div>
  </div>
}
