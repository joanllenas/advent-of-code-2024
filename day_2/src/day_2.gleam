import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let input = simplifile.read("./input.txt")
  case input {
    Ok(val) -> {
      let res = parse_input(val)
      let pt1 = res |> calculate_reports_safety |> find_total
      let pt2 = "TODO"
      io.println("Pt1: " <> int.to_string(pt1) <> " Pt2: " <> pt2)
    }
    Error(_) -> io.println("KO!")
  }
}

fn parse_input(input: String) -> List(List(Int)) {
  let append_int = fn(num: String, levels: List(Int)) {
    levels
    |> list.append([int.parse(num) |> result.unwrap(0)])
  }
  string.split(input, on: "\n")
  |> list.fold([], with: fn(acc, report: String) {
    list.append(acc, [
      string.split(report, on: " ")
      |> list.fold([], with: fn(levels, level: String) {
        append_int(level, levels)
      }),
    ])
  })
}

pub type ReportStatus {
  StatusSafe
  StatusUnsafe
}

fn diffs(report: List(Int)) -> List(Int) {
  report
  |> list.window_by_2()
  |> list.map(fn(tuple) { tuple.1 - tuple.0 })
}

pub fn calculate_report_safety(report: List(Int)) -> ReportStatus {
  let diffs = diffs(report)
  let all_increasing = diffs |> list.all(fn(n) { n > 0 })
  let all_decreasing = diffs |> list.all(fn(n) { n < 0 })
  let diffs_within_bounds =
    diffs
    |> list.all(fn(n) {
      int.absolute_value(n) >= 1 && int.absolute_value(n) <= 3
    })
  let is_safe = { all_increasing || all_decreasing } && diffs_within_bounds
  case is_safe {
    True -> StatusSafe
    False -> StatusUnsafe
  }
}

pub fn calculate_reports_safety(reports: List(List(Int))) -> List(ReportStatus) {
  list.map(reports, with: fn(report: List(Int)) {
    case report {
      [] -> StatusUnsafe
      [_] -> StatusUnsafe
      rep -> calculate_report_safety(rep)
    }
  })
}

fn find_total(reports: List(ReportStatus)) -> Int {
  list.filter(reports, fn(status) { status == StatusSafe })
  |> list.length
}
