module OverlayLayer = {
  @react.component
  let make = (~className=?, ~enabled=?, ~children=?) => {
    let cn = `${Js.Option.getWithDefault("", className)} flex flex-col items-center justify-center"`
    Js.Option.getWithDefault(false, enabled)
      ? <div className={cn}> {Js.Option.getWithDefault(React.null, children)} </div>
      : <> {Js.Option.getWithDefault(React.null, children)} </>
  }
}

module LazyLoadWrapper = {
  @react.component
  let make = (~enabled, ~height, ~offset, ~children) => {
    <> {enabled ? <LazyLoad height offset> {children} </LazyLoad> : <> {children} </>} </>
  }
}

@react.component
let make = (
  ~overlayClass=?,
  ~overlayEnabled=?,
  ~lazyLoadEnabled=?,
  ~lazyLoadOffset=?,
  ~className=?,
  ~width=?,
  ~height=?,
  ~sm_width=?,
  ~sm_height=?,
  ~sm_mediaQuery=?,
  ~alt=?,
  ~placeholderPath,
  ~src,
) => {
  open Js.Option
  open Js.Float
  let (loaded, setLoaded) = React.useState(_ => false)
  let (err, setErr) = React.useState(_ => false)
  let isMobile = MediaQuery.useMediaQuery(getWithDefault("(max-width: 600px)", sm_mediaQuery))
  let cn = isMobile
    ? `w-[${getWithDefault(0., width)->toString}px] h-[${getWithDefault(
          0.,
          height,
        )->toString}px] ${getWithDefault("", className)}`
    : `w-[${getWithDefault(0., sm_width)->toString}px] h-[${getWithDefault(
          0.,
          sm_height,
        )->toString}px] ${getWithDefault("", className)}`
  let w = toString(isMobile ? getWithDefault(0., width) : getWithDefault(0., sm_width))
  let h = toString(isMobile ? getWithDefault(0., height) : getWithDefault(0., sm_height))
  let cn = `${err ? "object-fit" : "object-cover"} ${getWithDefault("", className)} ${cn}`
  let imgStyle = ReactDOM.Style.make(~width=`${w}px`, ~height=`${h}px`, ())
  <div className="flex relative">
    {!loaded
      ? <div
          className="absolute top-[calc(h /. 2.)] w-full h-full flex flex-col items-center justify-center animate-pulse bg-50">
          <Loading
            className="w-[8rem] h-[5rem] stroke-[0.2rem] p-3 stroke-klor-200 text-700 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900"
          />
        </div>
      : React.null}
    <OverlayLayer
      className={getWithDefault("", overlayClass)} enabled={getWithDefault(false, overlayEnabled)}>
      <LazyLoadWrapper
        enabled={getWithDefault(false, lazyLoadEnabled)}
        offset={getWithDefault(0., lazyLoadOffset)}
        height={isMobile ? getWithDefault(0., height) : getWithDefault(0., sm_height)}>
        <img
          className={cn}
          style={imgStyle}
          src
          ?alt
          onLoad={_ => setLoaded(_ => true)}
          onError={e => {
            setErr(_ => true)
            open ReactEvent.Media
            if target(e)["src"] !== placeholderPath {
              target(e)["src"] = placeholderPath
            }
          }}
        />
      </LazyLoadWrapper>
    </OverlayLayer>
  </div>
}
