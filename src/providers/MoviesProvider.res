type state = {
  apiParams: UrlQueryParam.query_param,
  movies: MovieModel.movielist,
  loading: bool,
  error: string,
}

type action =
  | Loading(UrlQueryParam.query_param)
  | Error(string)
  | Success(MovieModel.movielist)

let emptyMovieList = {
  MovieModel.page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
}

let initialState = {
  apiParams: Category({name: "popular", page: 1}),
  movies: emptyMovieList,
  loading: false,
  error: "",
}

type context_value = {
  movies: MovieModel.movielist,
  loading: bool,
  error: string,
  loadMovies: (~apiParams: UrlQueryParam.query_param) => unit,
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

let loadMoviesInternal = (dispatch, ~apiParams: UrlQueryParam.query_param) => {
  let apiPath = switch apiParams {
  | Category({name, page}) =>
    `${MovieAPI.apiBaseUrl}/${MovieAPI.apiVersion}/movie/${name}?page=${Js.Int.toString(page)}`
  | Genre({id, page, sort_by}) =>
    `${MovieAPI.apiBaseUrl}/${MovieAPI.apiVersion}/discover/movie?with_genres=${string_of_int(
        id,
      )}&page=${Js.Int.toString(page)}&sort_by=${sort_by}`
  | _ => ""
  }

  let callback = json => {
    switch MovieModel.MovieListDecoder.decode(. ~json) {
    | Ok(ml) => dispatch(Success(ml))
    | Error(msg) => {
        Js.log(msg)
        dispatch(Error(msg))
    }
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

let useMoviesContext = () => React.useContext(MoviesContext.context)
