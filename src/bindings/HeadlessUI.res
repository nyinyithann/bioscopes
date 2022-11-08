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
    ~children: React.element=?,
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
      ~children: React.element=?,
    ) => React.element = "Child"
  }
}

module Listbox = {
  @module("@headlessui/react") @react.component
  external make: (
    @as("as") ~as_: 'a=?,
    ~disabled: bool=?,
    ~value: 'v=?,
    ~defaultValue: 'v=?,
    ~by: ('v, 'v) => bool=?,
    ~onChange: 'v => unit=?,
    ~horizontal: bool=?,
    ~name: string=?,
    ~multiple: bool=?,
    ~className: string=?,
    ~children: React.element,
  ) => React.element = "Listbox"

  module Button = {
    @module("@headlessui/react") @scope("Listbox") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: React.element=?,
    ) => React.element = "Button"
  }

  module Options = {
    @module("@headlessui/react") @scope("Listbox") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~static: bool=?,
      ~unmount: bool=?,
      ~className: string=?,
      ~children: React.element,
    ) => React.element = "Options"
  }

  module Option = {
    type render_props = {active: bool, selected: bool, disabled: bool}
    @module("@headlessui/react") @scope("Listbox") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~value: 'v=?,
      ~disabled: bool=?,
      ~className: string=?,
      ~children: render_props => React.element,
    ) => React.element = "Option"
  }
}

module Tab = {
  type render_props = {selected: bool}
  @module("@headlessui/react") @react.component
  external make: (
    @as("as") ~as_: 'a=?,
    ~disabled: bool=?,
    ~className: string=?,
    ~children: render_props => React.element,
  ) => React.element = "Tab"

  module Group = {
    type render_props = {selectedIndex: int}
    @module("@headlessui/react") @scope("Tab") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~defaultValue: int=?,
      ~selectedIndex: int=?,
      ~onChange: int => unit=?,
      ~vertical: bool=?,
      ~manual: bool=?,
      ~className: string=?,
      ~children: render_props => React.element,
    ) => React.element = "Group"
  }

  module List = {
    type render_props = {selectedIndex: int}
    @module("@headlessui/react") @scope("Tab") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: render_props => React.element,
    ) => React.element = "List"
  }
  
  module Panels = {
    type render_props = {selectedIndex: int}
    @module("@headlessui/react") @scope("Tab") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: render_props => React.element,
    ) => React.element = "Panels"
  }
  
  module Panel = {
    type render_props = {selectedIndex: int}
    @module("@headlessui/react") @scope("Tab") @react.component
    external make: (
      @as("as") ~as_: 'a=?,
      ~className: string=?,
      ~children: render_props => React.element,
    ) => React.element = "Panel"
  }
}
