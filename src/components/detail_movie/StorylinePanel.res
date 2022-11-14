let {string, int, float, array} = module(React)

module Pair = {
  @react.component
  let make = (~title, ~value) => {
    Util.isEmptyString(value)
      ? React.null
      : <dl className="flex w-full">
          <dt className="w-1/3 overflow-ellipsis"> {Util.toStringElement(title)} </dt>
          <dd className="w-2/3 overflow-ellipsis"> {Util.toStringElement(value)} </dd>
        </dl>
  }
}

let getDirectorIdAndName = (movie: DetailMovieModel.detail_movie) => {
  open Belt
  try {
    movie.credits
    ->Option.flatMap(c =>
      c.crew->Option.flatMap(crews =>
        crews->Array.getBy(
          crew => Option.getWithDefault(crew.job, "")->Js.String2.toLowerCase == "director",
        )
      )
    )
    ->Option.flatMap(d => Some((Option.getWithDefault(d.id, 0), Option.getWithDefault(d.name, ""))))
    ->Option.getExn
  } catch {
  | _ => (0, "")
  }
}

module DirectorLink = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie) => {
    let (id, name) = getDirectorIdAndName(movie)

    {
      id != 0
        ? <div className="flex w-full">
            <span className="w-1/3 overflow-ellipsis"> {Util.toStringElement("Director")} </span>
            <span className="w-2/3 overflow-ellipsis"> {Util.toStringElement(name)} </span>
          </div>
        : React.null
    }
  }
}

let getSpokenLanguages = (movie: DetailMovieModel.detail_movie) => {
  open Belt
  let spls =
    movie.spoken_languages
    ->Option.flatMap(sls => sls->Array.map(sl => sl.name->Option.getWithDefault(""))->Some)
    ->Option.getWithDefault([])
    ->Array.reduce("", (x, y) => x ++ ", " ++ y)
  Js.String2.startsWith(spls, ", ") ? Js.String2.substr(spls, ~from=2) : spls
}

let getProductionCompanies = (movie: DetailMovieModel.detail_movie) => {
  open Belt
  let names =
    movie.production_companies
    ->Option.flatMap(cmps => cmps->Array.map(cmp => cmp.name->Option.getWithDefault(""))->Some)
    ->Option.getWithDefault([])
    ->Array.reduce("", (x, y) => x ++ ", " ++ y)
  Js.String2.startsWith(names, ", ") ? Js.String2.substr(names, ~from=2) : names
}

let getGenres = (movie: DetailMovieModel.detail_movie) => {
  open Belt
  switch movie.genres {
  | Some(gns) => gns->Array.map(g => (g.id, g.name))
  | None => []
  }
}

module GenreLinks = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie) => {
    let links = getGenres(movie)
    let (_, setQueryParam) = UrlQueryParam.useQueryParams()

    {
      Util.isEmptyArray(links)
        ? React.null
        : <div className="flex w-full">
            <span className="w-1/3 overflow-ellipsis"> {Util.toStringElement("Genres")} </span>
            <div className="w-2/3 overflow-ellipsis flex flex-wrap items-center gap-2">
              {links
              ->Belt.Array.map(((id, name)) =>
                <span
                  key={Util.itos(id)}
                  onClick={e => {
                    ReactEvent.Mouse.preventDefault(e)
                    setQueryParam(
                      Genre({id, name, display: name, page: 1, sort_by: MovieModel.popularity.id}),
                    )
                  }}
                  className="span-link">
                  {Util.toStringElement(name)}
                </span>
              )
              ->array}
            </div>
          </div>
    }
  }
}

@react.component
let make = (~movie: DetailMovieModel.detail_movie) => {
  let sotryline = Util.getOrEmptyString(movie.overview)->Util.toStringElement
  let releasedDate = switch movie.release_date {
  | Some(x) =>
    try {
      Js.Date.fromString(x)->DomBinding.toLocaleString(
        "en-GB",
        {"day": "numeric", "month": "long", "year": "numeric"},
      )
    } catch {
    | _ => ""
    }
  | None => ""
  }

  let runtime = switch movie.runtime {
  | Some(x) if x == 0. => ""
  | Some(x) => {
      let t = int_of_float(x)
      `${(t / 60)->Util.itos}h ${mod(t, 60)->Util.itos}min`
    }

  | None => ""
  }
  let budget = Util.getOrFloatZero(movie.budget)->DomBinding.flotToLocaleString("en-GB")
  let revenue = Util.getOrFloatZero(movie.revenue)->DomBinding.flotToLocaleString("en-GB")
  let status = Util.getOrEmptyString(movie.status)
  let imdbId =
    movie.external_ids
    ->Belt.Option.flatMap(x => Some(Util.getOrEmptyString(x.imdb_id)))
    ->Util.getOrEmptyString
  let twitterId =
    movie.external_ids
    ->Belt.Option.flatMap(x => Some(Util.getOrEmptyString(x.twitter_id)))
    ->Util.getOrEmptyString
  let facebookId =
    movie.external_ids
    ->Belt.Option.flatMap(x => Some(Util.getOrEmptyString(x.facebook_id)))
    ->Util.getOrEmptyString
  let insgagramId =
    movie.external_ids
    ->Belt.Option.flatMap(x => Some(Util.getOrEmptyString(x.instagram_id)))
    ->Util.getOrEmptyString
  let website = movie.homepage->Util.getOrEmptyString

  let getFirstPosterImage = (~movie: DetailMovieModel.detail_movie) => {
    open Belt
    movie.images
    ->Option.map(imgs => imgs.posters)
    ->Option.getWithDefault(Some([]))
    ->Option.getWithDefault([])
    ->Array.get(0)
  }

  <div className="flex w-full pl-2 pt-6">
    <div
      className="hidden md:flex pr-8 items-start md:items-center md:justify-center justify-start">
      {switch getFirstPosterImage(~movie) {
      | Some(img) =>
        <LazyImageLite
          alt="poster image"
          placeholderPath={Links.placeholderImage}
          src={Links.getPosterImage_W370_H556_bestv2Link(Util.getOrEmptyString(img.file_path))}
          className="h-full border-slate-200 rounded-md shadow-gray-300 shadow-md md:min-w-[20rem] w-auto"
          lazyHeight={456.}
          lazyOffset={50.}
        />
      | None => React.null
      }}
    </div>
    <div className="flex flex-col w-full prose">
      <div className="flex flex-col w-full gap-1">
        <span className="text-[1.2rem] font-semibold text-900"> {"Storyline"->string} </span>
        <span className="break-words w-full flex"> sotryline </span>
      </div>
      <div className="flex flex-col w-full pt-4">
        <Pair title={"Released"} value={releasedDate} />
        <Pair title={"Runtime"} value={runtime} />
        <DirectorLink movie />
        {Util.getOrFloatZero(movie.budget) == 0.
          ? React.null
          : <Pair title={"Budget"} value={`$${budget}`} />}
        {Util.getOrFloatZero(movie.revenue) == 0.
          ? React.null
          : <Pair title={"Revenue"} value={`$${revenue}`} />}
        <GenreLinks movie />
        <Pair title={"Status"} value={status} />
        <Pair title={"Language"} value={getSpokenLanguages(movie)} />
        <Pair title={"Production"} value={getProductionCompanies(movie)} />
      </div>
      <div className="flex w-full justify-start gap-[1.4rem] pt-4">
        <Twitter id={twitterId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
        <Facebook id={facebookId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
        <Instagram id={insgagramId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
        <Imdb id={imdbId} className="h-6 w-6 fill-klor-500 hover:fill-klor-900" />
        <WebsiteLink
          link={website} className="h-6 w-6 fill-klor-50 stroke-klor-500 hover:fill-klor-900"
        />
      </div>
    </div>
  </div>
}
