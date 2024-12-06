import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
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

pub type SequenceType {
  Increment(Int)
  Decrement(Int)
  First(Int)
  Neither
}

pub fn calculate_report_safety(report: List(Int)) -> ReportStatus {
  list.fold_until(report, Neither, fn(previous, current) {
    case previous {
      Neither -> Continue(First(current))

      First(prev)
        if current > prev && current - prev >= 1 && current - prev <= 3
      -> Continue(Increment(current))

      First(prev)
        if current < prev && prev - current >= 1 && prev - current <= 3
      -> Continue(Decrement(current))

      Increment(prev)
        if current > prev && current - prev >= 1 && current - prev <= 3
      -> Continue(Increment(current))

      Decrement(prev)
        if current < prev && prev - current >= 1 && prev - current <= 3
      -> Continue(Decrement(current))

      _ -> {
        Stop(Neither)
      }
    }
  })
  |> fn(res: SequenceType) {
    case res {
      Neither -> StatusUnsafe
      _ -> StatusSafe
    }
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
