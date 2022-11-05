module FullStar = {
  @react.component
  let make = (~className=?) => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      enableBackground="new 0 0 24 24"
      ?className
      viewBox="0 0 24 24">
      <g>
        <path
          d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21 12 17.27z"
        />
      </g>
    </svg>
  }
}

module HalfStar = {
  @react.component
  let make = (~className=?) => {
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" ?className>
      <path
        d="M22 9.24l-7.19-.62L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21 12 17.27 18.18 21l-1.63-7.03L22 9.24zM12 15.4V6.1l1.71 4.04 4.38.38-3.32 2.88 1 4.28L12 15.4z"
      />
    </svg>
  }
}

@react.component
let make = (~ratingValue: option<float>) => {
  let stars = React.useRef([])
  let fullStar = "w-6 h-6 fill-yellow-400 stroke-0"
  let halfStar = "w-6 h-6 fill-yellow-400 stroke-0"
  let noStar = "w-6 h-6 fill-gray-400 stroke-0"
  React.useMemo1(() => {
    let rv = Js.Option.getWithDefault(0.0, ratingValue)
    let n = rv /. 2.
    let fsc = Belt.Int.fromFloat(n)
    let (fract, _) = modf(rv)
    let hfc = fract >= 0.5 ? 1 : 0
    for i in 0 to fsc - 1 {
      Belt.Array.push(
        stars.current,
        <FullStar className={fullStar} key={((i + 10) * fsc)->string_of_int} />,
      )
    }
    for i in 0 to hfc - 1 {
      Belt.Array.push(
        stars.current,
        <HalfStar className={halfStar} key={((i + 1) * hfc)->string_of_int} />,
      )
    }
    for i in 0 to 4 {
      switch Belt.Array.get(stars.current, i) {
      | Some(_) => ()
      | None =>
        Belt.Array.push(
          stars.current,
          <FullStar className={noStar} key={(i * 100)->string_of_int} />,
        )
      }
    }
  }, [ratingValue])
  <div>
    <div className="flex"> {stars.current->React.array} </div>
  </div>
}
