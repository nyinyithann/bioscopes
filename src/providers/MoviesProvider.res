type state = {
  apiParams: UrlQueryParam.query_param,
  movies: MovieModel.movielist,
  detail_movie: DetailMovieModel.detail_movie,
  loading: bool,
  error: string,
}

type action =
  | Loading(UrlQueryParam.query_param)
  | Error(string)
  | SuccessMovies(UrlQueryParam.query_param, MovieModel.movielist)
  | SuccessDetailMovie(UrlQueryParam.query_param, DetailMovieModel.detail_movie)
  | Clear

let emptyMovieList: MovieModel.movielist = {
  dates: ?None,
  page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
}

let emptyDetailMovie: DetailMovieModel.detail_movie = {
  adult: ?None,
  backdrop_path: ?None,
  genre_ids: ?None,
  id: ?None,
  original_language: ?None,
  original_title: ?None,
  overview: ?None,
  popularity: ?None,
  poster_path: ?None,
  release_date: ?None,
  runtime: ?None,
  status: ?None,
  title: ?None,
  video: ?None,
  vote_average: ?None,
  vote_count: ?None,
  videos: ?None,
  backdrops: ?None,
  posters: ?None,
  casts: ?None,
  crews: ?None,
}

let initialState = {
  apiParams: Category({name: "popular", display: "Popular", page: 1}),
  movies: emptyMovieList,
  detail_movie: emptyDetailMovie,
  loading: false,
  error: "",
}

type context_value = {
  movies: MovieModel.movielist,
  detail_movie: DetailMovieModel.detail_movie,
  loading: bool,
  error: string,
  loadData: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  loadDetailMovie: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  apiParams: UrlQueryParam.query_param,
  clearMovies: unit => unit,
}

module MoviesContext = {
  let initialContextValue: context_value = {
    movies: emptyMovieList,
    detail_movie: emptyDetailMovie,
    loading: false,
    error: "",
    loadData: (~apiParams as _, ~signal as _) => (),
    loadDetailMovie: (~apiParams as _, ~signal as _) => (),
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
  | Error(msg) => {
      apiParams: state.apiParams,
      movies: state.movies,
      detail_movie: ?state.detail_movie,
      loading: false,
      error: msg,
    }
  | Loading(apiParams) => {
      apiParams,
      movies: state.movies,
      detail_movie: ?state.detail_movie,
      loading: true,
      error: "",
    }
  | SuccessMovies(apiParams, movies) => {
      apiParams,
      movies: {
        MovieModel.dates: ?movies.dates,
        page: ?movies.page,
        total_pages: ?movies.total_pages,
        total_results: ?movies.total_results,
        results: ?movies.results,
      },
      detail_movie: emptyDetailMovie,
      loading: false,
      error: "",
    }
  | SuccessDetailMovie(apiParams, detailMovie) => {
      apiParams,
      movies: emptyMovieList,
      detail_movie: detailMovie,
      loading: false,
      error: "",
    }
  | Clear => {
      apiParams: state.apiParams,
      movies: emptyMovieList,
      detail_movie: emptyDetailMovie,
      loading: false,
      error: "",
    }
  }
}

let getApiPath = apiParams => {
  open Links
  open UrlQueryParam

  switch apiParams {
  | Category({name, page}) =>
    `${apiBaseUrl}/${apiVersion}/movie/${name}?page=${Js.Int.toString(page)}`
  | Genre({id, page, sort_by}) =>
    `${apiBaseUrl}/${apiVersion}/discover/movie?with_genres=${string_of_int(
        id,
      )}&page=${Js.Int.toString(page)}&sort_by=${sort_by}`
  | Search({query, page}) =>
    `${apiBaseUrl}/${apiVersion}/search/movie?query=${query}&page=${Js.Int.toString(page)}`
  | Movie(id) =>
    `${apiBaseUrl}/${apiVersion}/movie/${id}?language=en-US&append_to_response=videos,credits,images,external_ids,release_dates&include_image_language=en`
  | _ => ""
  }
}

let loadDataInternal = (dispatch, ~apiParams: UrlQueryParam.query_param, ~signal) => {
  let apiPath = getApiPath(apiParams)

  let callback = result => {
    switch result {
    | Ok(json) =>
      switch MovieModel.MovieListDecoder.decode(. ~json) {
      | Ok(ml) => dispatch(SuccessMovies(apiParams, ml))
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
  MovieAPI.getData(~apiPath, ~callback, ~signal, ())->ignore
}

let loadDetailMovieInternal = (dispatch, ~apiParams: UrlQueryParam.query_param, ~signal) => {
  let apiPath = getApiPath(apiParams)

  let callback = result => {
    switch result {
    | Ok(json) =>
      switch DetailMovieModel.Decoder.decode(. ~json) {
      | Ok(dm) => dispatch(SuccessDetailMovie(apiParams, dm))
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
  MovieAPI.getData(~apiPath, ~callback, ~signal, ())->ignore
}
@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  let loadData = React.useMemo1(() => loadDataInternal(dispatch), [dispatch])
  let loadDetailMovie = React.useMemo1(() => loadDetailMovieInternal(dispatch), [dispatch])

  let value = {
    movies: state.movies,
    detail_movie: state.detail_movie,
    loading: state.loading,
    error: state.error,
    loadData,
    loadDetailMovie,
    apiParams: state.apiParams,
    clearMovies: () => dispatch(Clear),
  }
  <MoviesContext.Provider value> children </MoviesContext.Provider>
}

let useMoviesContext = () => React.useContext(MoviesContext.context)
