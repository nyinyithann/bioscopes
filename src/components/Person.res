let {string} = module(React)
@react.component
let make = (~id: option<string>) => {
  <div> {("Person " ++ Js.Option.getExn(id))->string} </div>
}
