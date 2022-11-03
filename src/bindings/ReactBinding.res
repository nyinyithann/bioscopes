module Suspense = {
  @module("react") @react.component
  external make: (~fallback: React.element, ~children: React.element, unit) => React.element =
    "Suspense"
}

type lazy_props = {"id": option<string>}
module Lazy = {
  @val external import_: string => Js.Promise.t<{"make": React.component<lazy_props>}> = "import"

  @module("react")
  external lazy_: (unit => Js.Promise.t<{"default": React.component<lazy_props>}>) => React.component<
    lazy_props,
  > = "lazy"
}
