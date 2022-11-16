@react.component
let make = (~isOpen, ~errorMessage, ~onClose: bool => unit) => {
  let onClick = e => {
    ReactEvent.Mouse.preventDefault(e)
    onClose(true)
  }

  let reload = _ => {
    RescriptReactRouter.push("/")
    DomBinding.reload()
  }

  <ModalDialog isOpen onClose className="relative z-50" panelClassName="w-full h-full">
    <div className="flex flex-col w-full items-center bg-red-400 border-2 border-red-500 rounded">
      <div className="flex w-full items-center bg-red-400 h-8 px-2">
        <span className="mr-auto text-red-800"> {"Oops..."->React.string} </span>
        <button type_="button" className="ring-0 outline-none" onClick>
          <Heroicons.Outline.XIcon
            className="w-6 h-6 p-1 fill-red-100 stroke-red-200 hover:bg-red-700 rounded-full bg-red-900"
          />
        </button>
      </div>
      <div
        className="flex flex-col items-center justify-center min-w-[20rem] max-w-[22rem] p-2 bg-red-200 border-[1px] border-red-300 gap-2">
        <div
          className="block text-red-900 rounded p-2 m-auto text-left w-full line-clamp-6 break-all">
          {errorMessage->React.string}
        </div>
        <div
          className="flex flex-wrap items-center justify-center px-2 pt-2 text-red-500 border-t-[1px] border-t-red-900 w-full">
          <button
            type_="button"
            className="px-4 bg-slate-600 rounded-md py-2 text-900 hover:bg-slate-900 hover:text-50 dark:bg-slate-500 dark:text-slate-100 dark:hover:bg-slate-800"
            onClick={reload}>
            {"Go Home"->React.string}
          </button>
        </div>
      </div>
    </div>
  </ModalDialog>
}
