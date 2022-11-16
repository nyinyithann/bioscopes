type state = {
  apiParams: UrlQueryParam.query_param,
  movies: MovieModel.movielist,
  detail_movie: DetailMovieModel.detail_movie,
  recommendedMovies: MovieModel.movielist,
  loading: bool,
  error: string,
}

type action =
  | Loading(UrlQueryParam.query_param)
  | Error(string)
  | SuccessMovies(UrlQueryParam.query_param, MovieModel.movielist)
  | SuccessDetailMovie(
      UrlQueryParam.query_param,
      DetailMovieModel.detail_movie,
      MovieModel.movielist,
    )
  | SuccessRecommendedMovies(MovieModel.movielist)
  | ClearError
  | ClearAll

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
  detail_movie: emptyDetailMovie,
  recommendedMovies: emptyMovieList,
  loading: false,
  error: "",
}

type context_value = {
  movies: MovieModel.movielist,
  detail_movie: DetailMovieModel.detail_movie,
  recommendedMovies: MovieModel.movielist,
  loading: bool,
  error: string,
  loadMovies: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  loadDetailMovie: (~apiParams: UrlQueryParam.query_param, ~signal: Fetch.AbortSignal.t) => unit,
  loadRecommendedMovies: (~movieId: int, ~page: int, ~signal: Fetch.AbortSignal.t) => unit,
  apiParams: UrlQueryParam.query_param,
  clearError: unit => unit,
  clearAll: unit => unit,
}

module MoviesContext = {
  let initialContextValue: context_value = {
    movies: emptyMovieList,
    detail_movie: emptyDetailMovie,
    recommendedMovies: emptyMovieList,
    loading: false,
    error: "",
    loadMovies: (~apiParams as _, ~signal as _) => (),
    loadDetailMovie: (~apiParams as _, ~signal as _) => (),
    loadRecommendedMovies: (~movieId as _, ~page as _, ~signal as _) => (),
    apiParams: initialState.apiParams,
    clearError: () => (),
    clearAll: () => (),
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
      detail_movie: state.detail_movie,
      recommendedMovies: state.recommendedMovies,
      loading: false,
      error: msg,
    }
  | Loading(apiParams) => {
      apiParams,
      movies: state.movies,
      detail_movie: state.detail_movie,
      recommendedMovies: state.recommendedMovies,
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
        results: Belt.Array.concat(
          Js.Option.getWithDefault([], state.movies.results),
          Js.Option.getWithDefault([], movies.results),
        ),
      },
      detail_movie: emptyDetailMovie,
      recommendedMovies: emptyMovieList,
      loading: false,
      error: "",
    }
  | SuccessRecommendedMovies(recommendedMovies) => {
      apiParams: Void("recommendedMovies"),
      movies: emptyMovieList,
      detail_movie: state.detail_movie,
      recommendedMovies: {
        page: ?recommendedMovies.page,
        total_pages: ?recommendedMovies.total_pages,
        total_results: ?recommendedMovies.total_results,
        results: Belt.Array.concat(
          Js.Option.getWithDefault([], state.recommendedMovies.results),
          Js.Option.getWithDefault([], recommendedMovies.results)->Belt.Array.sliceToEnd(1),
        ),
      },
      loading: false,
      error: "",
    }
  | SuccessDetailMovie(apiParams, detailMovie, recommendedMovies) => {
      apiParams,
      movies: emptyMovieList,
      detail_movie: detailMovie,
      recommendedMovies,
      loading: false,
      error: "",
    }
  | ClearError => {
      apiParams: state.apiParams,
      movies: state.movies,
      detail_movie: state.detail_movie,
      recommendedMovies: state.recommendedMovies,
      loading: false,
      error: "",
    }
  | ClearAll => {
      apiParams: state.apiParams,
      movies: emptyMovieList,
      detail_movie: emptyDetailMovie,
      recommendedMovies: emptyMovieList,
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
    `${apiBaseUrl}/${apiVersion}/movie/${name}?language=en-US&page=${Js.Int.toString(page)}`
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
  MovieAPI.getMovies(~apiPath, ~callback, ~signal, ())->ignore
}

let loadDetailMovieInternal = (dispatch, ~apiParams: UrlQueryParam.query_param, ~signal) => {
  open Links
  let apiPath = getApiPath(apiParams)
  let movieId = switch apiParams {
  | Movie({id}) => id
  | _ => ""
  }

  let rmPath = `${apiBaseUrl}/${apiVersion}/movie/${movieId}/recommendations?api_key=${Env.apiKey}&page=1`

  let callback = (r1, r2) => {
    switch (r1, r2) {
    | (Ok(j1), Ok(j2)) => {
        let detailMovie = DetailMovieModel.Decoder.decode(. ~json=j1)
        let recommendedMovies = MovieModel.MovieListDecoder.decode(. ~json=j2)
        switch (detailMovie, recommendedMovies) {
        | (Ok(dm), Ok(rm)) => dispatch(SuccessDetailMovie(apiParams, dm, rm))
        | (Ok(dm), Error(err)) => {
            dispatch(SuccessDetailMovie(apiParams, dm, emptyMovieList))
            dispatch(Error(err))
          }

        | (Error(err), Ok(rm)) => {
            dispatch(SuccessDetailMovie(apiParams, emptyDetailMovie, rm))
            dispatch(Error(err))
          }

        | (Error(err1), Error(err2)) => dispatch(Error(err1 ++ err2))
        }
      }

    | _ => dispatch(Error("Error occured while reteriving movie detail."))
    }
  }

  dispatch(Loading(apiParams))
  MovieAPI.getMultipleDataset2(~apiPaths=(apiPath, rmPath), ~callback, ~signal, ())->ignore
}

let loadRecommendedMoviesInternal = (dispatch, ~movieId: int, ~page: int, ~signal) => {
  open Links
  let apiPath = `${apiBaseUrl}/${apiVersion}/movie/${movieId->Js.Int.toString}/recommendations?api_key=${Env.apiKey}&page=${page->Js.Int.toString}`

  let callback = result => {
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

  MovieAPI.getMovies(~apiPath, ~callback, ~signal, ())->ignore
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  let loadMovies = React.useMemo1(() => loadMovieInternal(dispatch), [dispatch])
  let loadDetailMovie = React.useMemo1(() => loadDetailMovieInternal(dispatch), [dispatch])
  let loadRecommendedMovies = React.useMemo1(
    () => loadRecommendedMoviesInternal(dispatch),
    [dispatch],
  )

  let value = {
    movies: state.movies,
    detail_movie: state.detail_movie,
    recommendedMovies: state.recommendedMovies,
    loading: state.loading,
    error: state.error,
    loadMovies,
    loadDetailMovie,
    loadRecommendedMovies,
    apiParams: state.apiParams,
    clearAll: () => dispatch(ClearAll),
    clearError: () => dispatch(ClearError),
  }
  <MoviesContext.Provider value> children </MoviesContext.Provider>
}

let useMoviesContext = () => React.useContext(MoviesContext.context)
