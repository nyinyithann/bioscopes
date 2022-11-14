type state = {
  apiParams: UrlQueryParam.query_param,
  movies: MovieModel.movielist,
  recommendedMovies: MovieModel.movielist,
  detail_movie: DetailMovieModel.detail_movie,
  loading: bool,
  error: string,
}

type action =
  | Loading(UrlQueryParam.query_param)
  | Error(string)
  | SuccessMovies(UrlQueryParam.query_param, MovieModel.movielist)
  | SuccessDetailMovie(UrlQueryParam.query_param, DetailMovieModel.detail_movie)
  | SuccessRecommendedMovies(MovieModel.movielist)
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
  genres: ?None,
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
  credits: ?None,
  images: ?None,
}

let initialState = {
  apiParams: Category({name: "popular", display: "Popular", page: 1}),
  movies: emptyMovieList,
  recommendedMovies: emptyMovieList,
  detail_movie: emptyDetailMovie,
  loading: false,
  error: "",
}

type context_value = {
  movies: MovieModel.movielist,
  recommendedMovies: MovieModel.movielist,
  detail_movie: DetailMovieModel.detail_movie,
  loading: bool,
  error: string,
  loadMovies: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  loadDetailMovie: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  loadRecommendedMovies : (~movieId : int, ~page : int, ~signal: Fetch.AbortSignal.t) => unit,
  apiParams: UrlQueryParam.query_param,
  clearMovies: unit => unit,
}

module MoviesContext = {
  let initialContextValue: context_value = {
    movies: emptyMovieList,
    recommendedMovies: emptyMovieList,
    detail_movie: emptyDetailMovie,
    loading: false,
    error: "",
    loadMovies: (~apiParams as _, ~signal as _) => (),
    loadDetailMovie: (~apiParams as _, ~signal as _) => (),
    loadRecommendedMovies: (~movieId as _, ~page as _, ~signal as _) => (),
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
      recommendedMovies: state.recommendedMovies,
      detail_movie: ?state.detail_movie,
      loading: false,
      error: msg,
    }
  | Loading(apiParams) => {
      apiParams,
      movies: state.movies,
      recommendedMovies: state.recommendedMovies,
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
      recommendedMovies: emptyMovieList,
      detail_movie: emptyDetailMovie,
      loading: false,
      error: "",
    }
  | SuccessDetailMovie(apiParams, detailMovie) => {
      apiParams,
      movies: emptyMovieList,
      recommendedMovies: emptyMovieList,
      detail_movie: detailMovie,
      loading: false,
      error: "",
    }
  | SuccessRecommendedMovies(movies) => {
      apiParams: UrlQueryParam.Void("recommended_movies"),
      movies: emptyMovieList,
      recommendedMovies: {
        MovieModel.dates: ?None,
        page: ?movies.page,
        total_pages: ?movies.total_pages,
        total_results: ?movies.total_results,
        results: ?movies.results,
      },
      detail_movie: state.detail_movie,
      loading: false,
      error: "",
    }
  | Clear => {
      apiParams: state.apiParams,
      movies: emptyMovieList,
      recommendedMovies: emptyMovieList,
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
    `${apiBaseUrl}/${apiVersion}/search/multi?query=${query}&page=${Js.Int.toString(page)}`
  | Movie({id, media_type}) =>
    `${apiBaseUrl}/${apiVersion}/${media_type}/${id}?language=en-US&append_to_response=videos,credits,images,external_ids,release_dates&include_image_language=en`
  | _ => ""
  }
}

let loadMovieInternal = (dispatch, ~apiParams: UrlQueryParam.query_param, ~signal) => {
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

let loadRecommendedMoviesInternal = (dispatch, ~movieId : int, ~page : int, ~signal) => {
    %debugger
  open Links
  let apiPath = `${apiBaseUrl}/${apiVersion}/movie/${movieId->Js.Int.toString}/recommendations?api_key=${Env.apiKey}&page=${page->Js.Int.toString}`

  let callback = result => {
      %debugger
    switch result {
    | Ok(json) =>
      switch MovieModel.MovieListDecoder.decode(. ~json) {
      | Ok(ml) => dispatch(SuccessRecommendedMovies(ml))
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
      | _ => dispatch(Error("Unexpected error occured while reteriving recommended movie data."))
      }
    }
  }

  dispatch(Loading(Void("recommended_movies")))
  %debugger
  MovieAPI.getData(~apiPath, ~callback, ~signal, ())->ignore
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  let loadMovies = React.useMemo1(() => loadMovieInternal(dispatch), [dispatch])
  let loadDetailMovie = React.useMemo1(() => loadDetailMovieInternal(dispatch), [dispatch])
  let loadRecommendedMovies = React.useMemo1(() => loadRecommendedMoviesInternal(dispatch), [dispatch])

  let value = {
    movies: state.movies,
    recommendedMovies: state.recommendedMovies,
    detail_movie: state.detail_movie,
    loading: state.loading,
    error: state.error,
    loadMovies,
    loadDetailMovie,
    loadRecommendedMovies,
    apiParams: state.apiParams,
    clearMovies: () => dispatch(Clear),
  }
  <MoviesContext.Provider value> children </MoviesContext.Provider>
}

let useMoviesContext = () => React.useContext(MoviesContext.context)
