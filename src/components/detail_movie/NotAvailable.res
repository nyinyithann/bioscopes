@react.component
let make = (~thing: string) => {
  <span className="block w-full text-base text-slate-400">
    {React.string(`No ${thing} available. 😕`)}
  </span>
}
