import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import gleam/regexp.{type Match}
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  case simplifile.read("./input.txt") {
    Ok(input) -> {
      let pt1 = part1(input) |> list.fold(0, int.add) |> int.to_string
      let pt2 = part2(input) |> list.fold(0, int.add) |> int.to_string
      io.println("Pt1: " <> pt1 <> " Pt2: " <> pt2)
    }
    Error(_) -> io.println("KO!")
  }
}

fn part1(input_string: String) -> List(Int) {
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

type Token {
  Do
  Dont
  Mul(Int, Int)
}

type Mode {
  AddMode
  DontAddMode
}

fn mul_matcher(input: String) -> option.Option(#(Int, Token)) {
  let assert Ok(re) = regexp.from_string("^mul\\((\\d+),(\\d+)\\)")
  let res = regexp.scan(with: re, content: input)
  case res {
    [regexp.Match(matched, [option.Some(a), option.Some(b)]), ..] ->
      #(int.parse(a) |> result.unwrap(0), int.parse(b) |> result.unwrap(0))
      |> fn(tuple) {
        option.Some(#(string.length(matched), Mul(tuple.0, tuple.1)))
      }
    _ -> option.None
  }
}

fn do_matcher(input: String) -> option.Option(#(Int, Token)) {
  let assert Ok(re) = regexp.from_string("^do\\(\\)")
  let res = regexp.scan(with: re, content: input)
  case res {
    [regexp.Match(matched, []), ..] ->
      option.Some(#(string.length(matched), Do))
    _ -> option.None
  }
}

// returns #(consumed length, matched token)
fn dont_matcher(input: String) -> option.Option(#(Int, Token)) {
  let assert Ok(re) = regexp.from_string("^don't\\(\\)")
  let res = regexp.scan(with: re, content: input)
  case res {
    [regexp.Match(matched, []), ..] ->
      option.Some(#(string.length(matched), Dont))
    _ -> option.None
  }
}

fn part2(input_string: String) -> List(Int) {
  let input =
    string.split(input_string, on: "\n")
    |> string.join("")
  let stream = input |> string.split("")

  let matchers = [mul_matcher, do_matcher, dont_matcher]

  let #(_, tokens) =
    stream
    |> list.index_fold(
      #(0, [Do]),
      fn(acc: #(Int, List(Token)), _: String, index: Int) {
        case acc {
          // skip until the consumed length index is reached
          #(current_index, _) if current_index > index -> acc
          // try all matchers and consume input
          #(current_index, tokens) -> {
            let match: option.Option(#(Int, Token)) =
              matchers
              |> list.fold_until(option.None, fn(opt, matcher) {
                case matcher(string.drop_start(input, index + 1)) {
                  option.Some(match_tuple) ->
                    list.Stop(option.Some(match_tuple))
                  _ -> list.Continue(opt)
                }
              })
            case match {
              option.Some(match_tuple) ->
                match_tuple
                |> pair.map_first(fn(consumed_length) {
                  current_index + consumed_length
                })
                |> pair.map_second(fn(token) { list.append(tokens, [token]) })
              option.None -> acc
            }
          }
        }
      },
    )

  // calculate
  tokens
  |> list.fold(#(AddMode, []), fn(acc, cur_token) {
    let #(mode, muls) = acc
    case mode, cur_token {
      AddMode, Mul(a, b) -> #(AddMode, list.append(muls, [a * b]))
      _, Do -> #(AddMode, muls)
      _, _ -> #(DontAddMode, muls)
    }
  })
  |> pair.second
}
