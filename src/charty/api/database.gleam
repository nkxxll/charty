import charty/models/file.{type File, create_file}
import gleam/dynamic
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import sqlight

const default_database = "default.sqlite"

pub type FileList {
  SingleList(List(File))
  DoubleList(List(List(File)))
}

pub type Identifier {
  ID(Int)
  Name(String)
}

/// save a file in the file system
/// the file is uploaded via a form
/// files are saved in ./files/<title>
pub fn create_tables(db: Option(String)) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)
  let sql =
    "CREATE TABLE IF NOT EXISTS dashboards (
    id INTEGER PRIMARY KEY,
    dash TEXT,
    name TEXT
    )"
  let res = sqlight.exec(sql, conn)
  case res {
    Ok(Nil) -> Nil
    Error(e) -> {
      io.debug(e)
      panic
    }
  }
}

/// insert a one dimensional list to the database
pub fn insert_dashboard1(name: String, flist: List(File), db: Option(String)) {
  let value = db_string_from_flist(flist) |> string.trim
  insert(name, value, db)
}

/// insert a two dimensional list to the database
pub fn insert_dashboard2(
  name: String,
  flist: List(List(File)),
  db: Option(String),
) -> Nil {
  let string =
    flist
    |> list.map(db_string_from_flist)
    |> list.fold("", fn(a, b) { a <> "-" <> b })
  insert(name, string, db)
}

fn insert(name: String, value: String, db: Option(String)) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)

  let sql =
    "INSERT INTO dashboards (name, dash) VALUES ('"
    <> name
    <> "', '"
    <> value
    <> "');"

  io.debug(sql)
  let assert Ok(Nil) = sqlight.exec(sql, conn)
  Nil
}

pub fn delete_by_id(id id: Int, db db: Option(String)) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)

  let sql = "DELETE FROM dashboards WHERE id = '" <> id |> int.to_string <> "';"
  let assert Ok(Nil) = sqlight.exec(sql, conn)
  Nil
}

pub fn delete_by_name(name name: String, db db: Option(String)) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)

  let sql = "DELETE FROM dashboards WHERE name = '" <> name <> "';"
  let assert Ok(Nil) = sqlight.exec(sql, conn)
  Nil
}

fn db_string_from_flist(flist: List(File)) {
  flist
  |> list.map(fn(f) { f.name })
  |> list.fold("", fn(a, b) { a <> " " <> b })
}

pub fn read_dash(
  identifier: Identifier,
  db: Option(String),
) -> #(Int, String, FileList) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)
  let dash_decoder = dynamic.tuple3(dynamic.int, dynamic.string, dynamic.string)
  let list = case identifier {
    ID(id) -> {
      let sql = "SELECT * FROM dashboards WHERE id == ?"
      let assert Ok(list) =
        sqlight.query(
          sql,
          conn,
          with: [sqlight.int(id)],
          expecting: dash_decoder,
        )
      list
    }
    Name(name) -> {
      let sql = "SELECT * FROM dashboards WHERE name == ?"
      let assert Ok(list) =
        sqlight.query(
          sql,
          conn,
          with: [sqlight.text(name)],
          expecting: dash_decoder,
        )
      list
    }
  }
  case list {
    [] -> #(-1, "", SingleList([]))
    [x] -> {
      let #(id, files, name) = x
      let fl = line_to_file_list(files) |> SingleList
      #(id, name, fl)
    }
    _ -> panic
  }
}

pub fn read_all_id_name(db: Option(String)) -> List(#(Int, String)) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)
  let dash_decoder = dynamic.tuple2(dynamic.int, dynamic.string)
  let sql = "SELECT id, name FROM dashboards;"
  let assert Ok(list) =
    sqlight.query(sql, conn, with: [], expecting: dash_decoder)
  list
}

pub fn read_all_dashs(db: Option(String)) -> List(#(Int, String, FileList)) {
  let database = case db {
    Some(database) -> database
    None -> default_database
  }
  use conn <- sqlight.with_connection(database)
  let dash_decoder = dynamic.tuple3(dynamic.int, dynamic.string, dynamic.string)
  let sql = "SELECT * FROM dashboards"
  let assert Ok(list) =
    sqlight.query(sql, conn, with: [], expecting: dash_decoder)
  list
  |> list.map(fn(item) {
    let #(id, dash, name) = item
    let lines = string.split(dash, "-")
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
  line |> string.split(" ") |> list.map(create_file)
}
