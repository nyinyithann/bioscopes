@module("react-lazy-load") @react.component
external make: (
  ~children: React.element=?,
  ~offset: float=?,
  ~treshold: float=?,
  ~height: float=?,
  ~width: float=?,
  ~onContentVisible: unit => unit=?,
) => React.element = "default"
