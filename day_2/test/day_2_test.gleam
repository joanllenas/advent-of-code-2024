import day_2 as exercise
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn report1_test() {
  exercise.calculate_report_safety([7, 6, 4, 2, 1])
  |> should.equal(exercise.StatusSafe)
}

pub fn report2_test() {
  exercise.calculate_report_safety([1, 2, 7, 8, 9])
  |> should.equal(exercise.StatusUnsafe)
}

pub fn report3_test() {
  exercise.calculate_report_safety([9, 7, 6, 2, 1])
  |> should.equal(exercise.StatusUnsafe)
}

pub fn report4_test() {
  exercise.calculate_report_safety([1, 3, 2, 4, 5])
  |> should.equal(exercise.StatusUnsafe)
}

pub fn report5_test() {
  exercise.calculate_report_safety([8, 6, 4, 4, 1])
  |> should.equal(exercise.StatusUnsafe)
}

pub fn report6_test() {
  exercise.calculate_report_safety([1, 3, 6, 7, 9])
  |> should.equal(exercise.StatusSafe)
}

// --------------------
//
//  with tolerance
//
// --------------------

pub fn report_with_tolerance_1_test() {
  exercise.calculate_report_safety_with_tolerance([7, 6, 4, 2, 1])
  |> should.equal(exercise.StatusSafe)
}

pub fn report_with_tolerance_2_test() {
  exercise.calculate_report_safety_with_tolerance([1, 2, 7, 8, 9])
  |> should.equal(exercise.StatusUnsafe)
}

pub fn report_with_tolerance_3_test() {
  exercise.calculate_report_safety_with_tolerance([9, 7, 6, 2, 1])
  |> should.equal(exercise.StatusUnsafe)
}

pub fn report_with_tolerance_4_test() {
  exercise.calculate_report_safety_with_tolerance([1, 3, 2, 4, 5])
  |> should.equal(exercise.StatusSafe)
}

pub fn report_with_tolerance_5_test() {
  exercise.calculate_report_safety_with_tolerance([8, 6, 4, 4, 1])
  |> should.equal(exercise.StatusSafe)
}

pub fn report_with_tolerance_6_test() {
  exercise.calculate_report_safety_with_tolerance([1, 3, 6, 7, 9])
  |> should.equal(exercise.StatusSafe)
}
