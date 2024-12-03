import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Eq, Gt, Lt}
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

fn parse_input(input: String) -> List(#(Int, Int)) {
  string.split(input, on: "\n")
  |> list.map(with: fn(line: String) {
    case string.split(line, on: "   ") {
      [loc1, loc2] -> #(
        int.parse(loc1) |> result.unwrap(0),
        int.parse(loc2) |> result.unwrap(0),
      )
      _ -> #(0, 0)
    }
  })
}

fn find_distances(input: List(#(Int, Int))) -> List(Int) {
  let left_list =
    list.sort(input, by: fn(ta: #(Int, Int), tb: #(Int, Int)) {
      let a = pair.first(ta)
      let b = pair.first(tb)
      case a, b {
        a, b if a > b -> Gt
        a, b if a < b -> Lt
        _, _ -> Eq
      }
    })
    |> list.map(fn(t: #(Int, Int)) { t.0 })

  let right_list =
    list.sort(input, by: fn(ta: #(Int, Int), tb: #(Int, Int)) {
      let a = pair.second(ta)
      let b = pair.second(tb)
      case a, b {
        a, b if a > b -> Gt
        a, b if a < b -> Lt
        _, _ -> Eq
      }
    })
    |> list.map(fn(t: #(Int, Int)) { t.1 })

  list.zip(left_list, right_list)
  |> list.map(fn(t: #(Int, Int)) { int.absolute_value(t.0 - t.1) })
}

fn find_total_distance(input: List(Int)) -> String {
  input
  |> list.fold(0, fn(acc, x) { acc + x })
  |> int.to_string
}
