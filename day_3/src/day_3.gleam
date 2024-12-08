import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp.{type Match}
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let input = simplifile.read("./input.txt")
  case input {
    Ok(val) -> {
      let res = parse_input(val)
      let pt1 = res |> list.fold(0, fn(a, b) { a + b }) |> int.to_string
      let pt2 = res |> fn(_a) { "a" }
      io.println("Pt1: " <> pt1 <> " Pt2: " <> pt2)
    }
    Error(_) -> io.println("KO!")
  }
}

fn parse_input(input_string: String) -> List(Int) {
  let input = string.split(input_string, on: "\n") |> string.join("")
  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  let results = regexp.scan(with: re, content: input)
  results
  |> list.map(fn(match: Match) {
    case match {
      regexp.Match(_, [option.Some(a), option.Some(b)]) ->
        [int.parse(a), int.parse(b)]
        |> result.values
        |> int.product
      _ -> 0
    }
  })
}
