@react.component
let make = (~show: bool) => {
  if show {
    <div className="flex w-full items-center justify-center p-2 pt-8 gap-6 dark:dark-bg">
      <div
        className="flex items-center justify-center p-1 h-[1.2rem] w-[1.2rem] rounded-full bg-200 animate-ping">
        <span className="h-[0.5rem] w-[0.5rem] rounded-full bg-red-500" />
      </div>
      <div
        className="flex items-center justify-center p-1 h-[1.2rem] w-[1.2rem] rounded-full bg-200 animate-ping">
        <span className="h-[0.5rem] w-[0.5rem] rounded-full bg-yellow-500" />
      </div>
      <div
        className="flex items-center justify-center p-1 h-[1.2rem] w-[1.2rem] rounded-full bg-200 animate-ping">
        <span className="h-[0.5rem] w-[0.5rem] rounded-full bg-green-500" />
      </div>
    </div>
  } else {
    React.null
  }
}
