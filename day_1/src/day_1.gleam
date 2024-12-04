import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let input = simplifile.read("./input.txt")
  case input {
    Ok(val) ->
      parse_input(val) |> find_distances |> find_total_distance |> io.println
    Error(_) -> io.println("KO!")
  }
}

fn parse_input(input: String) -> #(List(Int), List(Int)) {
  let append_int = fn(num: String, positions: List(Int)) {
    positions |> list.append([int.parse(num) |> result.unwrap(0)])
  }
  string.split(input, on: "\n")
  |> list.fold(#([], []), with: fn(acc, line: String) {
    case string.split(line, on: "   ") {
      [loc1, loc2] ->
        acc
        |> pair.map_first(append_int(loc1, _))
        |> pair.map_second(append_int(loc2, _))
      _ -> acc
    }
  })
}

fn find_distances(input: #(List(Int), List(Int))) -> List(Int) {
  let tuple =
    input
    |> pair.map_first(fn(positions) { list.sort(positions, by: int.compare) })
    |> pair.map_second(fn(positions) { list.sort(positions, by: int.compare) })

  list.zip(pair.first(tuple), pair.second(tuple))
  |> list.map(fn(t: #(Int, Int)) { int.absolute_value(t.0 - t.1) })
}

fn find_total_distance(input: List(Int)) -> String {
  input
  |> list.fold(0, fn(acc, x) { acc + x })
  |> int.to_string
}
