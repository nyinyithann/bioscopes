type dialog_opacity = [
  | #0
  | #5
  | #10
  | #20
  | #25
  | #30
  | #40
  | #50
  | #60
  | #70
  | #80
  | #90
  | #95
  | #100
]
@react.component
let make = (
  ~isOpen,
  ~onClose,
  ~className=?,
  ~panelClassName=?,
  ~opacity: dialog_opacity=#100,
  ~children=?,
) => {
  open HeadlessUI
  <Transition show={isOpen}>
    <Dialog ?className onClose>
      <Transition.Child
        enter="ease-out duration-300"
        enterFrom="opacity-0"
        enterTo="opacity-100"
        leave="ease-in duration-300"
        leaveFrom="opacity-100"
        leaveTo="opacity-0">
        <div className="fixed inset-0 bg-black bg-opacity-40" />
        <div className={`fixed inset-0 bg-black bg-opacity-${(opacity :> int)->Js.Int.toString}`} />
      </Transition.Child>
      <div className="fixed inset-0 overflow-y-auto">
        <div className="flex min-h-full items-center justify-center p-4 text-center">
          <Transition.Child
            enter="ease-out duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="ease-in duration-300"
            leaveFrom="opacity-100"
            leaveTo="opacity-0">
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
/* <div className={`fixed inset-0 bg-black bg-opacity-${(opacity :> int)->Js.Int.toString}`} /> */
