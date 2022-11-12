type video_play_state = {
  url: string,
  playing: bool,
}
type video_player_context_value = {
  videoPlayState: video_play_state,
  play: string => unit,
  stop: unit => unit,
}

type video_play_action =
  | Play(string)
  | Stop

let initialState = {
  url: "",
  playing: false,
}

module VideoPlayerContext = {
  let initialContextValue: video_player_context_value = {
    videoPlayState: initialState,
    play: _ => (),
    stop: () => (),
  }

  let context = React.createContext(initialContextValue)
  module Provider = {
    let provider = React.Context.provider(context)
    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

let reducer = (_: video_play_state, action: video_play_action) => {
  switch action {
  | Play(url) => {url, playing: true}
  | Stop => {url: "", playing: false}
  }
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  let playCallback = React.useCallback1(url => dispatch(Play(url)), [dispatch])
  let stopCallback = React.useCallback1(() => dispatch(Stop), [dispatch])

  let value: video_player_context_value = {
    videoPlayState: state,
    play: playCallback,
    stop: stopCallback,
  }
  <VideoPlayerContext.Provider value> children </VideoPlayerContext.Provider>
}

let useVideoPlayerContext = () => React.useContext(VideoPlayerContext.context)
