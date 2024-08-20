import charty/api/database.{type FileList}
import charty/models/file.{File, create_file}
import gleam/dynamic
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleeunit/should
import simplifile
import sqlight

const test_db = "test.sqlite"

/// If I want to update the snap fixtures I can turn this to true and update them 
const schema_command = "PRAGMA table_info(dashboards);"

// create and check whether the database is created the right way
pub fn create_database_test() {
  let schema_decoder =
    dynamic.tuple6(
      dynamic.int,
      dynamic.string,
      dynamic.string,
      dynamic.int,
      dynamic.dynamic,
      dynamic.int,
    )
  database.create_tables(Some(test_db))
  use conn <- sqlight.with_connection(test_db)
  let schema = sqlight.query(schema_command, conn, [], schema_decoder)
  let fixture_location = "./fixtures/schema.txt"
  case schema {
    Ok(s) -> {
      let schema_string = schema_to_string(s)
      snap(
        got: schema_string,
        expected_location: fixture_location,
        update: False,
      )
    }
    Error(e) -> {
      io.debug("query failed")
      io.debug(e)
      should.fail()
    }
  }
}

pub fn insert_and_read_test() {
  database.create_tables(Some(test_db))
  let file_list = [
    create_file("test1.jpg"),
    create_file("test2.jpg"),
    create_file("test3.jpg"),
    create_file("test4.jpg"),
    create_file("test5.jpg"),
  ]
  let name = "test_dash"
  database.insert_dashboard1(name, file_list, Some(test_db))
  let all_dashes = database.read_all_dashs(Some(test_db))
  let fixture_location = "./fixtures/insert_and_read.txt"
  let all_dashes_string = all_dashes |> dashes_to_string
  snap(
    got: all_dashes_string,
    expected_location: fixture_location,
    update: True,
  )
  database.delete_by_name(name, Some(test_db))
  let after_delete = database.read_all_dashs(Some(test_db))
  let fixture_location = "./fixtures/after_delete.txt"
  let after_delete_string = after_delete |> dashes_to_string
  snap(
    got: after_delete_string,
    expected_location: fixture_location,
    update: True,
  )
}

fn snap(
  got got: String,
  expected_location expected_location: String,
  update update: Bool,
) {
  let read_res = simplifile.read(expected_location)
  case read_res {
    Ok(expected) -> {
      case update {
        True -> {
          io.debug(got)
          io.print("\n===\n")
          io.debug(expected)
          let assert Ok(Nil) =
            simplifile.write(to: expected_location, contents: got)
          Nil
        }
        False -> Nil
      }
      should.equal(got, expected)
    }
    Error(e) -> {
      io.debug("error reading fixture file")
      io.debug(e)
      Nil
    }
  }
}

fn dashes_to_string(dashes: List(#(Int, String, FileList))) {
  dashes
  |> list.map(fn(a) {
    let #(id, name, files) = a
    int.to_string(id) <> ";" <> name <> ";" <> files |> files_to_string
  })
  |> list.fold("", fn(a, b) { a <> "\n" <> b })
}

fn files_to_string(files: FileList) -> String {
  case files {
    database.SingleList(single) -> {
      single
      |> list.map(fn(a) {
        let File(name, _, _) = a
        name
      })
      |> list.fold("", fn(a, b) { a <> ";" <> b })
    }
    database.DoubleList(double) -> {
      double
      |> list.map(fn(b) {
        b
        |> list.map(fn(a) {
          let File(name, _, _) = a
          name
        })
        |> list.fold("", fn(a, b) { a <> ";" <> b })
      })
      |> list.fold("", fn(a, b) { a <> ";" <> b })
    }
  }
}

fn schema_to_string(
  schema: List(#(Int, String, String, Int, dynamic.Dynamic, Int)),
) {
  schema
  |> list.map(fn(a) {
    let #(id, name, type_, notnull, _, pk) = a
    int.to_string(id)
    <> ";"
    <> name
    <> ";"
    <> type_
    <> ";"
    <> int.to_string(notnull)
    <> ";"
    <> int.to_string(pk)
  })
  |> list.fold("", fn(a, b) { a <> "\n" <> b })
  <> "\n"
}
