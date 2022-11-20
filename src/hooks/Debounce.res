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
    clearTimeout()
    timeoutId.contents = Js.Global.setTimeout(() => {
        setDebouncedValue(_ => value)
      }, delay)->Some

    Some(() => clearTimeout())
  }, (delay, value))

  debouncedValue
}
