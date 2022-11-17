let useTitle = title => {
  let prevTitle = React.useRef(DomBinding.getTitle(DomBinding.htmlDoc))

  React.useEffect1(() => {
    DomBinding.setTitle(DomBinding.htmlDoc, title)
    Some(() => DomBinding.setTitle(DomBinding.htmlDoc, prevTitle.current))
  }, [title])
}
