module Menu = {
  @module("@headlessui/react") @react.component
  external make: (
    @as("as") ~as_: 'a=?,
    ~children: React.element=?,
    ~className: string=?,
  ) => React.element = "Menu"

  module Button = {
    @module("@headlessui/react") @scope("Menu") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~children: React.element=?,
      ~className: string=?,
    ) => React.element = "Button"
  }

  module Items = {
    @module("@headlessui/react") @scope("Menu") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~children: React.element=?,
      ~className: string=?,
      ~static: bool=?,
      ~unmount: bool=?,
    ) => React.element = "Items"
  }

  module Item = {
    @module("@headlessui/react") @scope("Menu") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~children: React.element=?,
      ~className: string=?,
      ~disabled: bool=?,
      ~active: bool=?,
    ) => React.element = "Item"
  }
}

module Dialog = {
  @module("@headlessui/react") @react.component
  external make: (
    @as("as") ~as_: 'a=?,
    @as("open") ~open_: bool=?,
    ~initialFocus: React.ref<React.element>=?,
    ~static: bool=?,
    ~unmount: bool=?,
    ~onClose: bool => unit=?,
    ~className: string=?,
    ~children: React.element=?,
  ) => React.element = "Dialog"

  module Panel = {
    @module("@headlessui/react") @scope("Dialog") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: React.element=?,
    ) => React.element = "Panel"
  }

  module Title = {
    @module("@headlessui/react") @scope("Dialog") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: React.element=?,
    ) => React.element = "Title"
  }

  module Description = {
    @module("@headlessui/react") @scope("Dialog") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: React.element=?,
    ) => React.element = "Description"
  }

  module Overlay = {
    @module("@headlessui/react") @scope("Dialog") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: React.element=?,
    ) => React.element = "Overlay"
  }
}

module Transition = {
  @module("@headlessui/react") @react.component
  external make: (
    ~show: bool=?,
    @as("as") ~as_: 'a=?,
    ~appear: bool=?,
    ~unmount: bool=?,
    ~enter: string=?,
    ~enterFrom: string=?,
    ~enterTo: string=?,
    ~entered: string=?,
    ~leave: string=?,
    ~leaveFrom: string=?,
    ~leaveTo: string=?,
    ~beforeEnter: unit => unit=?,
    ~afterEnter: unit => unit=?,
    ~beforeLeave: unit => unit=?,
    ~afterLeave: unit => unit=?,
    ~className: string=?,
    ~children: React.element=?
  ) => React.element = "Transition"


  module Child = {
    @module("@headlessui/react") @scope("Transition") @react.component
    external make: (
      ~show: bool=?,
      @as("as") ~as_: 'a=?,
      ~appear: bool=?,
      ~unmount: bool=?,
      ~enter: string=?,
      ~enterFrom: string=?,
      ~enterTo: string=?,
      ~entered: string=?,
      ~leave: string=?,
      ~leaveFrom: string=?,
      ~leaveTo: string=?,
      ~beforeEnter: unit => unit=?,
      ~afterEnter: unit => unit=?,
      ~beforeLeave: unit => unit=?,
      ~afterLeave: unit => unit=?,
      ~className: string=?,
      ~children: React.element=?
    ) => React.element = "Child"
  }
}
