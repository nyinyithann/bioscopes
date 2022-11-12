@react.component
let make = (~isOpen, ~onClose, ~className=?, ~panelClassName=?, ~children=?) => {
  open HeadlessUI
  <Transition show={isOpen}>
    <Dialog ?className onClose>
      <Transition.Child
        enter="ease-out duration-300"
        enterFrom="opacity-0"
        enterTo="opacity-100"
        leave="ease-in duration-200"
        leaveFrom="opacity-100"
        leaveTo="opacity-0">
        <div className="fixed inset-0 bg-black bg-opacity-100" />
      </Transition.Child>
      <div className="fixed inset-0 overflow-y-auto">
        <div className="flex min-h-full items-center justify-center p-4 text-center">
          <Transition.Child
            enter="ease-out duration-300"
            enterFrom="opacity-0 scale-95"
            enterTo="opacity-100 scale-100"
            leave="ease-in duration-200"
            leaveFrom="opacity-100 scale-100"
            leaveTo="opacity-0 scale-95">
            <Dialog.Panel className={`w-full h-full ${Util.getOrEmptyString(panelClassName)}`}>
              {switch children {
              | Some(ch) => ch
              | _ => React.null
              }}
            </Dialog.Panel>
          </Transition.Child>
        </div>
      </div>
    </Dialog>
  </Transition>
}
