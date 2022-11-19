let {string, array} = module(React)

type person_viewmodel = {
  id: string,
  name: string,
  profileImagePath: string,
  biography: array<string>,
  knownFor: string,
  born: string,
  died: string,
  age: int,
  placeOfBirth: string,
  imdbId: string,
  twitterId: string,
  facebookId: string,
  instagramId: string,
  websiteLink: string,
}

let getImgElem = (src, height, imageLoaded, setImageLoaded) =>
  <img
    className={`transition duration-1000 ${imageLoaded
        ? "opacity-100"
        : "opacity-0"} pt-2 pr-4 pb-4 float-left w-auto`}
    src
    style={ReactDOM.Style.make(~height=Js.Int.toString(height) ++ "px", ())}
    alt="image"
    onLoad={_ => setImageLoaded(_ => true)}
    onError={e => {
      open ReactEvent.Media
      if target(e)["src"] !== Links.placeholderImage {
        target(e)["src"] = Links.placeholderImage
        target(e)["style"] = "height: 350px; width: 260px"
      }
    }}
  />

let getSocialLinks = person =>
  <div className="flex w-full justify-start gap-[1.4rem] pt-6">
    <Twitter id={person.twitterId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
    <Facebook id={person.facebookId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
    <Instagram id={person.instagramId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
    <Imdb id={person.imdbId} type_={"name"} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
    <WebsiteLink
      link={person.websiteLink} className="h-6 w-6 fill-klor-50 stroke-klor-500 hover:fill-klor-900"
    />
  </div>

let getAge = (person: PersonModel.person) => {
  let birthday = Util.getOrEmptyString(person.birthday)
  let deathday = Util.getOrEmptyString(person.deathday)

  let calcAge = (birthDay, zDay) => {
    try {
      let by = Js.Date.getFullYear(birthDay)
      let zy = Js.Date.getFullYear(zDay)
      let bMonth = Js.Date.getMonth(birthDay)
      let bDay = Js.Date.getDay(birthDay)
      let d_Month = Js.Date.getMonth(zDay)
      let d_Day = Js.Date.getDay(zDay)
      let age = int_of_float(zy -. by)
      if bMonth > d_Month || (bMonth == d_Month && bDay > d_Day) {
        age - 1
      } else {
        age
      }
    } catch {
    | _ => Js.Int.min
    }
  }

  if deathday != "" {
    let bDate = Js.Date.fromString(birthday)
    let d_Date = Js.Date.fromString(deathday)
    calcAge(bDate, d_Date)
  } else {
    let bDate = Js.Date.fromString(birthday)
    let c_Date = Js.Date.make()
    calcAge(bDate, c_Date)
  }
}

@react.component
let make = () => {
  open HeadlessUI
  let isMedium = MediaQuery.useMediaQuery("(max-width: 900px)")
  let isLg = MediaQuery.useMediaQuery("(max-width: 1200px)")
  let height = isMedium ? 280 : isLg ? 356 : 476

  let (imageLoaded, setImageLoaded) = React.useState(_ => false)
  let (queryParam, _) = UrlQueryParam.useQueryParams()
  let {loading, error, person, loadPerson, clearError} = MoviesProvider.useMoviesContext()
  let personVM = React.useRef(None)

  React.useEffect0(() => {
    let controller = Fetch.AbortController.make()
    switch queryParam {
    | Person({id}) =>
      loadPerson(~apiParams=Person({id: id}), ~signal=Fetch.AbortController.signal(controller))
    | _ => ()
    }
    Some(() => Fetch.AbortController.abort(controller, "Cancel the request"))
  })

  React.useMemo1(() => {
    open Belt
    if person.id != PersonModel.initial_invalid_id {
      let profilePath = Util.getOrEmptyString(person.profile_path)
      let profileImagePath =
        profilePath != "" ? Links.getPosterImage_W370_H556_bestv2Link(profilePath) : ""

      personVM.current = Some({
        id: person.id->Js.Int.toString,
        name: Js.Option.getWithDefault("🏃", person.name),
        profileImagePath,
        biography: Util.getOrEmptyString(person.biography)
        ->Js.String2.split("\n")
        ->Array.keep(x => x !== ""),
        knownFor: Util.getOrEmptyString(person.known_for_department),
        born: Util.toLocaleString(~date=person.birthday, ()),
        died: Util.toLocaleString(~date=person.deathday, ()),
        age: getAge(person),
        placeOfBirth: Util.getOrEmptyString(person.place_of_birth),
        imdbId: person.external_ids
        ->Option.map(x => Util.getOrEmptyString(x.imdb_id))
        ->Util.getOrEmptyString,
        twitterId: person.external_ids
        ->Option.map(x => Util.getOrEmptyString(x.twitter_id))
        ->Util.getOrEmptyString,
        facebookId: person.external_ids
        ->Belt.Option.map(x => Util.getOrEmptyString(x.facebook_id))
        ->Util.getOrEmptyString,
        instagramId: person.external_ids
        ->Belt.Option.map(x => Util.getOrEmptyString(x.instagram_id))
        ->Util.getOrEmptyString,
        websiteLink: person.homepage->Util.getOrEmptyString,
      })
    }
  }, [person])

  Document.useTitle(Util.getOrEmptyString(person.name))

  let onClose = arg =>
    if arg {
      clearError()
    }

  switch personVM.current {
  | Some(personVM) =>
    <main className="flex flex-col items-center justify-center w-full py-2">
      <Pulse show={loading} />
      <div>
        <p className="block lg:hidden font-nav font-semibold text-[1.4rem] pb-1 pl-4">
          {personVM.name->string}
        </p>
        <div className="block px-4 py-2">
          {getImgElem(personVM.profileImagePath, height, imageLoaded, setImageLoaded)}
          <div className="block lg:flex flex-col">
            <p className="hidden lg:block font-nav font-semibold text-[1.4rem] pb-2">
              {personVM.name->string}
            </p>
            {Belt.Array.map(personVM.biography, x =>
              <p
                key={Js.String2.slice(x, ~from=0, ~to_=32)}
                className="pb-2 prose w-auto md:w-[60vw]">
                {x->string}
              </p>
            )->array}
            <div className="flex flex-col items-start justify-start prose pt-6 w-[22rem]">
              {personVM.knownFor != ""
                ? <StorylinePanel.Pair title={"Known For"} value={personVM.knownFor} />
                : React.null}
              {personVM.born != ""
                ? personVM.died == "" && personVM.age != Js.Int.min
                    ? <StorylinePanel.Pair
                        title={"Born"}
                        value={`${personVM.born} (age ${personVM.age->Js.Int.toString})`}
                      />
                    : <StorylinePanel.Pair title={"Born"} value={personVM.born} />
                : React.null}
              {personVM.died != ""
                ? personVM.age != Js.Int.min
                    ? <StorylinePanel.Pair
                        title={"Died"}
                        value={`${personVM.died} (age ${personVM.age->Js.Int.toString})`}
                      />
                    : <StorylinePanel.Pair title={"Died"} value={personVM.died} />
                : React.null}
              {personVM.placeOfBirth != ""
                ? <StorylinePanel.Pair title={"Place of Birth"} value={personVM.placeOfBirth} />
                : React.null}
            </div>
            {!isMedium ? getSocialLinks(personVM) : React.null}
          </div>
          {isMedium ? getSocialLinks(personVM) : React.null}
        </div>
      </div>
      <div
        id="person_tab_container" className="w-full flex flex-col items-center justify-center pt-8">
        <Tab.Group>
          {selectedIndex => {
            <div className="flex flex-col w-full">
              <Tab.List className="flex w-full flex-nowrap items-center justify-around">
                {_ => {
                  <>
                    <Tab
                      key={"knownfor"}
                      className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                      {props =>
                        <div
                          className={`${props.selected
                              ? "bg-300 text-900"
                              : ""} w-full h-full control-color flex items-center justify-center py-2 font-semibold`}>
                          {"KNOWN FOR"->string}
                        </div>}
                    </Tab>
                    <Tab
                      key={"credits"}
                      className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                      {props =>
                        <div
                          className={`${props.selected
                              ? "bg-300 text-900"
                              : ""} w-full h-full control-color flex items-center justify-center py-2 font-semibold`}>
                          {"CREDITS"->string}
                        </div>}
                    </Tab>
                    <Tab
                      key={"photos"}
                      className="control-color flex flex-col items-center justify-center w-full h-full outline-none ring-0 border-r-[1px] border-300">
                      {props =>
                        <div
                          className={`${props.selected
                              ? "bg-300 text-900"
                              : ""} w-full h-full control-color flex items-center justify-center py-2 font-semibold`}>
                          {"PHOTOS"->string}
                        </div>}
                    </Tab>
                  </>
                }}
              </Tab.List>
              <Tab.Panels className="pt-1">
                {props => {
                  <>
                    <Tab.Panel key="knownfor-panel">
                      {props => {
                        <div className="flex w-full p-2">
                          <KnownFor person />
                        </div>
                      }}
                    </Tab.Panel>
                    <Tab.Panel key="credits-panel">
                      {props => {
                        <div className="flex w-full p-2">
                          <Credits person />
                        </div>
                      }}
                    </Tab.Panel>
                    <Tab.Panel key="photos-panel">
                      {props => {
                        <div className="flex w-full p-2">
                          <PersonPhotos person />
                        </div>
                      }}
                    </Tab.Panel>
                  </>
                }}
              </Tab.Panels>
            </div>
          }}
        </Tab.Group>
      </div>
      {Js.String2.length(error) > 0
        ? <ErrorDialog isOpen={Js.String2.length(error) > 0} errorMessage={error} onClose />
        : React.null}
    </main>

  | _ => <Pulse show={loading} />
  }
}
let make = React.memo(make)
