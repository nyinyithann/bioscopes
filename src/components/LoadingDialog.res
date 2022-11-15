@react.component
let make = (~isOpen, ~onClose) => {
  <ModalDialog
    isOpen
    onClose={onClose}
    className="z-50 relative"
    opacity={(#20: ModalDialog.dialog_opacity)}
    panelClassName="w-full h-full rounded">
    <div className="flex items-center h-8 px-2 rounded-full">
      <Loading
        className="w-[6rem] h-[3rem] stroke-[4px] p-[6px] stroke-slate-300 text-slate-600 dark:fill-slate-600 dark:stroke-slate-400 dark:text-900 m-auto"
      />
    </div>
  </ModalDialog>
}
