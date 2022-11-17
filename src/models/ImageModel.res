type image = {
  aspect_ratio?: float,
  height?: float,
  iso_639_1?: string,
  file_path?: string,
  vote_average?: float,
  vote_count?: int,
  width?: float,
}

module ImageDecoder = {
  open! JsonCombinators.Json.Decode

  let image = object(fields => {
    aspect_ratio: ?Marshal.to_opt(. fields, "aspect_ratio", float),
    iso_639_1: ?Marshal.to_opt(. fields, "iso_639_1", string),
    height: ?Marshal.to_opt(. fields, "height", float),
    width: ?Marshal.to_opt(. fields, "width", float),
    file_path: ?Marshal.to_opt(. fields, "file_path", string),
    vote_average: ?Marshal.to_opt(. fields, "vote_average", float),
    vote_count: ?Marshal.to_opt(. fields, "vote_count", int),
  })
}
