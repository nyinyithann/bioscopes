@react.component
let make = (
  ~className=?,
  ~placeholderPath,
  ~alt=?,
  ~src,
  ~lazyHeight: float,
  ~lazyOffset: float,
) => {
  let (loaded, setLoaded) = React.useState(_ => false)
  let lh = Js.Float.toString(lazyHeight /. 2.) ++ "px"

  <div className="flex relative items-center justify-center">
    {!loaded
      ? <div
          className={`absolute top-[${lh}] w-full h-full flex flex-col items-center justify-center animate-pulse bg-50`}>
          <Loading
            className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
          />
        </div>
      : React.null}
    <LazyLoad height={lazyHeight} offset={lazyOffset}>
      <img
        ?className
        src
        ?alt
        onLoad={_ => setLoaded(_ => true)}
        onError={e => {
          open ReactEvent.Media
          if target(e)["src"] !== placeholderPath {
            target(e)["src"] = placeholderPath
          }
        }}
      />
    </LazyLoad>
  </div>
}
