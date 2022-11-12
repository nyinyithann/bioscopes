@module("react-player/youtube") @react.component
external make: (
  ~url: string,
  ~playing: bool=?,
  ~loop: bool=?,
  ~controls: bool=?,
  ~volume: float=?,
  ~muted: bool=?,
  ~width: string=?,
  ~height: string=?,
  ~className: string=?,
  ~style: ReactDOM.Style.t=?,
) => React.element = "default"
