let {string} = module(React)
@react.component
let make = (~id:option<string>) => {
  <div> {("Movie " ++ Js.Option.getExn(id) )->string} </div>
}
