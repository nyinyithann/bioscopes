type api_params =
  | Category({type_: string, page: int})
  | Genre({id: int, page: int, sorty_by: string})
  | Search({query: string, page: int})
  | Recommendation({movieId: int, page: int})
  | WithCast({castId: int, page: int, sorty_by: string})

type state = {
  apiParams: api_params,
  movies: MovieModel.movielist,
  loading: bool,
  error: string,
}

type action =
  | Loading(api_params)
  | Error(string)
  | Success(MovieModel.movielist)

let emptyMovieList = {
  MovieModel.page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
}

let initialState = {
  apiParams: Category({type_: "popular", page: 1}),
  movies: emptyMovieList,
  loading: false,
  error: "",
}

type context_value = {
  movies: MovieModel.movielist,
  loading: bool,
  error: string,
  loadMovies: (~apiParams: api_params) => unit,
}

module MoviesContext = {
  let initialContextValue: context_value = {
    movies: emptyMovieList,
    loading: false,
    error: "",
    loadMovies: (~apiParams as _) => (),
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

let reducer = (state: state, action) => {
  switch action {
  | Error(msg) => {apiParams: state.apiParams, movies: state.movies, loading: false, error: msg}
  | Loading(apiParams) => {apiParams, movies: state.movies, loading: true, error: ""}
  | Success(movies) => {apiParams: state.apiParams, movies, loading: false, error: ""}
  }
}

let loadMoviesInternal = (dispatch, ~apiParams: api_params) => {
  let apiPath = switch apiParams {
  | Category({type_, page}) =>
    `${MovieAPI.apiBaseUrl}/${MovieAPI.apiVersion}/movie/${type_}?page=${Js.Int.toString(page)}`
  | _ => ""
  }

  let callback = json => {
    switch MovieModel.MovieListDecoder.decode(. ~json) {
    | Ok(ml) => dispatch(Success(ml))
    | Error(msg) => dispatch(Error(msg))
    }
  }
  dispatch(Loading(apiParams))
  MovieAPI.getMovies(~apiPath, ~callback, ())->ignore
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  let loadMovies = React.useMemo1(() => loadMoviesInternal(dispatch), [dispatch])

  let value = {
    movies: state.movies,
    loading: state.loading,
    error: state.error,
    loadMovies,
  }
  <MoviesContext.Provider value> children </MoviesContext.Provider>
}

let usePopularMovies = () => React.useContext(MoviesContext.context)
