import charty/api/database
import gleam/dynamic
import gleam/io
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import simplifile
import sqlight

const test_db = "test.sqlite"

const schema_command = ".schema dashboards"

// create and check whether the database is created the right way
pub fn create_database_test() {
  let decode_string = dynamic.string
  database.create_tables(Some(test_db))
  use conn <- sqlight.with_connection(test_db)
  let schema = sqlight.query(schema_command, conn, [], decode_string)
  case schema {
    Ok(s) -> {
      let assert Ok(fixture) = simplifile.read("./fixtures/schema.txt")
      case s {
        [x] -> {
          should.equal(x, fixture)
        }
        _ -> should.fail
      }
    }
    Error(e) -> {
      io.debug(e)
      should.fail
    }
  }
}
