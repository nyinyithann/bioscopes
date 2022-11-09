let {string, int, float, array} = module(React)

module Pair = {
  @react.component
  let make = (~title, ~value) => {
    <div className="flex w-full">
      <span className="w-1/3 overflow-ellipsis"> {Util.toStringElement(title)} </span>
      <span className="w-2/3 overflow-ellipsis"> {Util.toStringElement(value)} </span>
    </div>
  }
}

module DirectorLink = {
  @react.component
  let make = (~movie: DetailMovieModel.detail_movie, ~onClick) => {
  /*   open Belt */
  /*   let director = */
  /*     movie.credits->Option.getExn */
  /*     ->Option.map(crews => */
  /*       crews->Array.getBy(crew => */
  /*         Option.getWithDefault(crew.job, "")->Js.String2.toLowerCase == "director" */
  /*       ) */
  /*     ) */
  /*     ->Option.getWithDefault(Some(({job: ""}: DetailMovieModel.crew))) */
  /*     ->Option.getWithDefault(({job: ""}: DetailMovieModel.crew)) */
  /*     %debugger */
  /**/
  /*   { */
  /*     Option.getWithDefault(director.job, "") != "" */
  /*       ? <div className="flex w-full"> */
  /*           <span className="w-1/3 overflow-ellipsis"> {Util.toStringElement("Director")} </span> */
  /*           <span className="w-2/3 overflow-ellipsis"> */
  /*             {Util.toStringElement(Option.getExn(director.job))} */
  /*           </span> */
  /*         </div> */
  /*       : React.null */
  /*   } */
  /* } */
      <></>
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
  | Some(x) => {
      let t = int_of_float(x)
      `${(t / 60)->Util.itos}h ${mod(t, 60)->Util.itos}min`
    }

  | None => ""
  }

  /* let director = switch movie.crews { */
  /* | Some(cs) => { */
  /* switch cs -> Belt.Array.getBy(x => Js.String2.toLowerCase(x.Job) == "") */
  /* } */
  /* | None => "" */
  /* } */

  <div className="flex flex-col w-full">
    <div className="flex flex-col w-full gap-1">
      <span className="text-[1.2rem] font-semibold"> {Util.toStringElement("Storyline")} </span>
      <span className="prose break-words"> sotryline </span>
    </div>
    <div className="flex flex-col w-full prose pt-4">
      <Pair title={"Released"} value={releasedDate} />
      <Pair title={"Runtime"} value={runtime} />
      <DirectorLink movie onClick={() => ()}/>
    </div>
  </div>
}
