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
      let pt1 =
        res |> calculate_reports_safety(with_tolerance: False) |> find_total
      let pt2 =
        res |> calculate_reports_safety(with_tolerance: True) |> find_total
      io.println(
        "Pt1: " <> int.to_string(pt1) <> " Pt2: " <> int.to_string(pt2),
      )
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

pub fn calculate_report_safety_with_tolerance(report: List(Int)) -> ReportStatus {
  list.index_map(report, fn(_, index) {
    list.index_fold(report, [], fn(acc, item, idx) {
      case index == idx {
        True -> acc
        False -> list.append(acc, [item])
      }
    })
    |> calculate_report_safety
  })
  |> list.any(fn(status) { status == StatusSafe })
  |> fn(all_safe) {
    case all_safe {
      True -> StatusSafe
      False -> StatusUnsafe
    }
  }
}

pub fn calculate_reports_safety(
  reports: List(List(Int)),
  with_tolerance has_tolerance: Bool,
) -> List(ReportStatus) {
  list.map(reports, with: fn(report: List(Int)) {
    case report, has_tolerance {
      [], _ -> StatusUnsafe
      [_], _ -> StatusUnsafe
      rep, False -> calculate_report_safety(rep)
      rep, True -> calculate_report_safety_with_tolerance(rep)
    }
  })
}

fn find_total(reports: List(ReportStatus)) -> Int {
  list.filter(reports, fn(status) { status == StatusSafe })
  |> list.length
}
