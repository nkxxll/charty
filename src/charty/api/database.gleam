import charty/models/file.{type File, create_file}
import gleam/dynamic
import gleam/list
import gleam/string
import sqlight

const database = ":memory:"

pub type FileList {
  SingleList(List(File))
  DoubleList(List(List(File)))
}

/// save a file in the file system
/// the file is uploaded via a form
/// files are saved in ./files/<title>
pub fn create_tables() {
  use conn <- sqlight.with_connection(database)
  let sql =
    "CREATE TABLE IF NOT EXISTS dashboards (
    id INTEGER PRIMARY KEY
    dash TEXT
    )"
  let assert Ok(Nil) = sqlight.exec(sql, conn)
}

/// insert a one dimensional list to the database
pub fn insert_dashboard1(name: String, flist: List(File)) {
  let string = db_string_from_flist(flist)
  insert(name, string)
}

/// insert a two dimensional list to the database
pub fn insert_dashboard2(name: String, flist: List(List(File))) {
  let string =
    flist
    |> list.map(db_string_from_flist)
    |> list.fold("", fn(a, b) { a <> ";" <> b })
  insert(name, string)
}

fn insert(name: String, string: String) {
  use conn <- sqlight.with_connection(database)

  let sql =
    "INSERT INTO dashboards (name, dash) VALUE ("
    <> name
    <> ", "
    <> string
    <> ")"
  let assert Ok(Nil) = sqlight.exec(sql, conn)
}

fn db_string_from_flist(flist: List(File)) {
  flist
  |> list.map(fn(f) { f.name })
  |> list.fold("", fn(a, b) { a <> "," <> b })
}

pub fn read_dash(id: Int) -> #(Int, String, FileList) {
  use conn <- sqlight.with_connection(database)
  let dash_decoder = dynamic.tuple3(dynamic.int, dynamic.string, dynamic.string)
  let sql = "SELECT * FROM dashboards WHERE id == ?"
  let assert Ok(list) =
    sqlight.query(sql, conn, with: [sqlight.int(id)], expecting: dash_decoder)
  case list {
    [] -> #(-1, "", SingleList([]))
    [x] -> {
      let #(id, name, files) = x
      let fl = line_to_file_list(files) |> SingleList
      #(id, name, fl)
    }
    _ -> panic
  }
}

pub fn read_all_dashs() -> List(#(Int, String, FileList)) {
  use conn <- sqlight.with_connection(database)
  let dash_decoder = dynamic.tuple3(dynamic.int, dynamic.string, dynamic.string)
  let sql = "SELECT * FROM dashboards"
  let assert Ok(list) =
    sqlight.query(sql, conn, with: [], expecting: dash_decoder)
  list
  |> list.map(fn(item) {
    let #(id, name, dash) = item
    let lines = string.split(dash, ";")
    case lines {
      [x] -> {
        let fl = line_to_file_list(x) |> SingleList
        #(id, name, fl)
      }
      li -> {
        let fl = li |> list.map(line_to_file_list) |> DoubleList
        #(id, name, fl)
      }
    }
  })
}

/// assume this is a , separated line
fn line_to_file_list(line: String) -> List(File) {
  line |> string.split(",") |> list.map(create_file)
}
