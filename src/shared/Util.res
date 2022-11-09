open Js.Option
let getOrEmptyString = x => getWithDefault("", x)
let getOrIntZero = x => getWithDefault(0, x)
let getOrFloatZero = x => getWithDefault(0., x)

let toStringElement = str => React.string(str)
let toIntElement = n => React.int(n)
let toFloatElement = n => React.float(n)

let itos = Js.Int.toString
let ftos = Js.Float.toString
let stoi = int_of_string
let stof = float_of_string

let isEmptyString = str => Js.String2.length(str) == 0
let isEmptyArray = arr => Js.Array2.length(arr) == 0
