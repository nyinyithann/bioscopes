module Suspense = {
  @module("react") @react.component
  external make: (~fallback: React.element, ~children: React.element, unit) => React.element =
    "Suspense"
}

type props = {"id": option<string>}
module Lazy = {
  @val external import_: string => Js.Promise.t<{"make": React.component<props>}> = "import"

  @module("react")
  external lazy_: (unit => Js.Promise.t<{"default": React.component<props>}>) => React.component<
    props,
  > = "lazy"
}
