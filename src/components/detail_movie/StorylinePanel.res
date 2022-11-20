let {string, int, float, array} = module(React)

type overview = {
  storyline: string,
  releasedDate: string,
  runtime: string,
  budget: string,
  revenue: string,
  status: string,
  imdbId: string,
  twitterId: string,
  facebookId: string,
  instagramId: string,
  websiteLink: string,
  directorId: int,
  directorName: string,
  genreLinks: array<(int, string)>,
  spokenLanguages: string,
  productionCompanies: string,
}

let getFirstPosterImage = (~movie: DetailMovieModel.detail_movie) => {
  open Belt
  movie.images
  ->Option.map(imgs => imgs.posters)
  ->Option.getWithDefault(Some([]))
  ->Option.getWithDefault([])
  ->Array.get(0)
}

let labelStyle = "w-[12rem] flex items-center bg-50 pl-1 pr-2 rounded-r-full mb-1 dark:dark-bg-label"

module Pair = {
  @react.component
  let make = (~title, ~value) => {
    Util.isEmptyString(value)
      ? React.null
      : <dl className="flex w-full gap-4">
          <dt className={labelStyle}> {Util.toStringElement(title)} </dt>
          <dd className="w-full"> {Util.toStringElement(value)} </dd>
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
  let make = (~id, ~name) => {
    open Webapi.Url
    let param: UrlQueryParam.person_param = {
      id: id->Js.Int.toString,
    }
    let seg =
      `/person?` ++
      UrlQueryParam.Converter_person_param.stringfy(. param)
      ->URLSearchParams.make
      ->URLSearchParams.toString

    {
      id != 0
        ? <div className="flex w-full gap-4">
            <span className={labelStyle}> {Util.toStringElement("Director")} </span>
            <a
              href={seg}
              className="w-full text-base font-normal span-link dark:dark-link"
              rel="noopener noreferrer">
              {Util.toStringElement(name)}
            </a>
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
  let make = (~links) => {
    let (_, setQueryParam) = UrlQueryParam.useQueryParams()

    {
      Util.isEmptyArray(links)
        ? React.null
        : <div className="flex w-full gap-4">
            <span className={labelStyle}> {Util.toStringElement("Genres")} </span>
            <div className="w-full flex flex-wrap items-center gap-2">
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
                  className="span-link dark:dark-link">
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
  let overviewRef = React.useRef(None)

  React.useMemo1(() => {
    let storyline = Util.getOrEmptyString(movie.overview)
    let releasedDate = Util.toLocaleString(~date=movie.release_date, ())

    let runtime = switch movie.runtime {
    | Some(x) if x == 0. => ""
    | Some(x) => {
        let t = int_of_float(x)
        `${(t / 60)->Util.itos}h ${mod(t, 60)->Util.itos}min`
      }

    | None => ""
    }

    let (directorId, directorName) = getDirectorIdAndName(movie)
    let budget = Util.getOrFloatZero(movie.budget)->DomBinding.floatToLocaleString("en-GB")
    let revenue = Util.getOrFloatZero(movie.revenue)->DomBinding.floatToLocaleString("en-GB")
    let status = Util.getOrEmptyString(movie.status)
    let imdbId =
      movie.external_ids
      ->Belt.Option.map(x => Util.getOrEmptyString(x.imdb_id))
      ->Util.getOrEmptyString
    let twitterId =
      movie.external_ids
      ->Belt.Option.map(x => Util.getOrEmptyString(x.twitter_id))
      ->Util.getOrEmptyString
    let facebookId =
      movie.external_ids
      ->Belt.Option.map(x => Util.getOrEmptyString(x.facebook_id))
      ->Util.getOrEmptyString
    let instagramId =
      movie.external_ids
      ->Belt.Option.map(x => Util.getOrEmptyString(x.instagram_id))
      ->Util.getOrEmptyString
    let websiteLink = movie.homepage->Util.getOrEmptyString
    let genreLinks = getGenres(movie)
    let spokenLanguages = getSpokenLanguages(movie)
    let productionCompanies = getProductionCompanies(movie)

    overviewRef.current = Some({
      storyline,
      releasedDate,
      runtime,
      budget,
      revenue,
      status,
      imdbId,
      twitterId,
      facebookId,
      instagramId,
      websiteLink,
      directorId,
      directorName,
      genreLinks,
      spokenLanguages,
      productionCompanies,
    })
  }, [movie])

  switch overviewRef.current {
  | Some(overview) =>
    <div className="flex w-full pl-2 pt-2 dark:dark-bg dark:dark-text">
      <div
        className="hidden md:flex pr-8 items-start md:items-center md:justify-center justify-start">
        {switch getFirstPosterImage(~movie) {
        | Some(img) => {
            let seg = Util.getOrEmptyString(img.file_path)
            if !Util.isEmptyString(seg) {
              <LazyImage
                alt="poster image"
                placeholderPath={Links.placeholderImage}
                src={Links.getPosterImage_W370_H556_bestv2Link(seg)}
                className="h-full border-slate-200 rounded-md shadow-gray-300 shadow-md md:min-w-[20rem] w-auto dark:dark-shadow"
                lazyHeight={456.}
                lazyOffset={50.}
              />
            } else {
              React.null
            }
          }

        | None => React.null
        }}
      </div>
      <div className="flex flex-col w-full prose dark:dark-bg dark:dark-text">
        <div className="flex flex-col w-full gap-1">
          <span className="text-[1.2rem] font-semibold text-900"> {"Storyline"->string} </span>
          <span className="break-words w-full flex"> {overview.storyline->string} </span>
        </div>
        <div className="flex flex-col w-full pt-4">
          <Pair title={"Released"} value={overview.releasedDate} />
          <Pair title={"Runtime"} value={overview.runtime} />
          <DirectorLink id={overview.directorId} name={overview.directorName} />
          {overview.budget != ""
            ? React.null
            : <Pair title={"Budget"} value={`$${overview.budget}`} />}
          {overview.revenue != ""
            ? React.null
            : <Pair title={"Revenue"} value={`$${overview.revenue}`} />}
          <GenreLinks links={overview.genreLinks} />
          <Pair title={"Status"} value={overview.status} />
          <Pair title={"Language"} value={overview.spokenLanguages} />
          <Pair title={"Production"} value={overview.productionCompanies} />
        </div>
        <div className="flex w-full justify-start gap-[1.4rem] pt-4">
          <Twitter
            id={overview.twitterId}
            className="h-6 w-6 fill-klor-500 hover:fill-klor-900 dark:dark-svg"
          />
          <Facebook
            id={overview.facebookId}
            className="h-6 w-6 fill-klor-500 hover:fill-klor-900 dark:dark-svg"
          />
          <Instagram
            id={overview.instagramId}
            className="h-6 w-6 fill-klor-500 hover:fill-klor-900 dark:dark-svg"
          />
          <Imdb
            id={overview.imdbId}
            type_={"title"}
            className="h-6 w-6 fill-klor-500 hover:fill-klor-900 dark:dark-svg"
          />
          <WebsiteLink
            link={overview.websiteLink}
            className="h-6 w-6 fill-klor-50 stroke-klor-500 hover:fill-klor-900 dark:dark-svg"
          />
        </div>
      </div>
    </div>
  | _ => React.null
  }
}
