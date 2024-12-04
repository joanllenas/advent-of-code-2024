import gleam/dict
import gleam/function
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
    Ok(val) -> {
      let input = parse_input(val)
      let pt1 = input |> find_distances |> find_total
      let pt2 = input |> find_similarities |> find_total
      io.println("Pt1: " <> pt1 <> " Pt2: " <> pt2)
    }
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
  let #(a, b) =
    input
    |> pair.map_first(fn(positions) { list.sort(positions, by: int.compare) })
    |> pair.map_second(fn(positions) { list.sort(positions, by: int.compare) })

  list.zip(a, b)
  |> list.map(fn(t: #(Int, Int)) { int.absolute_value(t.0 - t.1) })
}

fn find_similarities(input: #(List(Int), List(Int))) -> List(Int) {
  let cache = dict.new()
  input.0
  |> list.map(fn(num: Int) {
    cache
    |> dict.get(num)
    |> result.lazy_unwrap(fn() {
      input.1 |> list.filter(fn(n) { n == num }) |> list.length
    })
    |> function.tap(fn(n) { dict.insert(cache, num, n) })
    |> fn(n) { n * num }
  })
}

fn find_total(input: List(Int)) -> String {
  input
  |> list.fold(0, fn(acc, x) { acc + x })
  |> int.to_string
}
