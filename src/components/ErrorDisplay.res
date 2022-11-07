@react.component
let make = (~errorMessage) => {
  <div className="block text-red-600 bg-red-200 border-[1px] border-red-300 p-2 m-auto"> {errorMessage->React.string} </div>
}
