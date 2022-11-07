type state = {
  apiParams: UrlQueryParam.query_param,
  movies: MovieModel.movielist,
  loading: bool,
  error: string,
}

type action =
  | Loading(UrlQueryParam.query_param)
  | Error(string)
  | Success(UrlQueryParam.query_param, MovieModel.movielist)
  | Clear

let emptyMovieList: MovieModel.movielist = {
  dates: ?None,
  page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
}

let initialState = {
  apiParams: Category({name: "popular", display: "Popular", page: 1}),
  movies: emptyMovieList,
  loading: false,
  error: "",
}

type context_value = {
  movies: MovieModel.movielist,
  loading: bool,
  error: string,
  loadMovies: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  apiParams: UrlQueryParam.query_param,
  clearMovies: unit => unit,
}

module MoviesContext = {
  let initialContextValue: context_value = {
    movies: emptyMovieList,
    loading: false,
    error: "",
    loadMovies: (~apiParams as _, ~signal as _) => (),
    apiParams: initialState.apiParams,
    clearMovies: () => (),
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
  | Success(apiParams, movies) => {
      apiParams,
      movies: {
        MovieModel.dates: ?movies.dates,
        page: ?movies.page,
        total_pages: ?movies.total_pages,
        total_results: ?movies.total_results,
        results: ?movies.results,
      },
      loading: false,
      error: "",
    }

  | Clear => {apiParams: state.apiParams, movies: emptyMovieList, loading: false, error: ""}
  }
}

let loadMoviesInternal = (dispatch, ~apiParams: UrlQueryParam.query_param, ~signal) => {
  open Links
  let apiPath = switch apiParams {
  | Category({name, page}) =>
    `${apiBaseUrl}/${apiVersion}/movie/${name}?page=${Js.Int.toString(page)}`
  | Genre({id, page, sort_by}) =>
    `${apiBaseUrl}/${apiVersion}/discover/movie?with_genres=${string_of_int(
        id,
      )}&page=${Js.Int.toString(page)}&sort_by=${sort_by}`
  | Search({query, page}) =>
    `${apiBaseUrl}/${apiVersion}/search/movie?query=${query}&page=${Js.Int.toString(page)}`
  | _ => ""
  }

  let callback = result => {
    switch result {
    | Ok(json) =>
      switch MovieModel.MovieListDecoder.decode(. ~json) {
      | Ok(ml) => dispatch(Success(apiParams, ml))

      | Error(msg) => dispatch(Error(msg))
      }
    | Error(json) =>
      switch MovieModel.MovieErrorDecoder.decode(. ~json) {
      | Ok(e) => {
          let errors = Belt.Array.reduce(Js.Option.getWithDefault([], e.errors), ". ", (a, b) =>
            b ++ a
          )
          dispatch(Error(errors))
        }

      | _ => dispatch(Error("Unexpected error occured while reteriving movie data."))
      }
    }
  }

  dispatch(Loading(apiParams))
  MovieAPI.getMovies(~apiPath, ~callback, ~signal, ())->ignore
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
    apiParams: state.apiParams,
    clearMovies: () => dispatch(Clear),
  }
  <MoviesContext.Provider value> children </MoviesContext.Provider>
}

let useMoviesContext = () => React.useContext(MoviesContext.context)
