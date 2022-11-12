let timeoutId = ref(None)
let valRef = ref("")

let useDebounce = (~delay: int, ~value: string) => {
  let (debouncedValue, setDebouncedValue) = React.useState(_ => value)

  let clearTimeout = () => {
    switch timeoutId.contents {
    | Some(id) => Js.Global.clearTimeout(id)
    | _ => ()
    }
  }

  React.useEffect2(() => {
    %debugger
    clearTimeout()
    timeoutId.contents = Js.Global.setTimeout(() => {
        %debugger
        setDebouncedValue(_ => value)
      }, delay)->Some

    Some(() => clearTimeout())
  }, (delay, value))
  
  debouncedValue
}
