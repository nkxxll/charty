/// this is the database mock
import charty/models/file.{type File, basedir}
import gleam/io
import simplifile.{create_directory, is_directory, read_bits, write_bits}

/// save a file in the file system
/// the file is uploaded via a form
/// files are saved in ./files/<title>
pub fn save(file: File, content: BitArray) {
  // A function to write content to a file
  let path = file.path
  let id_res = is_directory(basedir)
  case id_res {
    Error(_) -> Nil
    Ok(is_dir) -> {
      case is_dir {
        True -> Nil
        False -> {
          let _ = create_directory(basedir)
          Nil
        }
      }
    }
  }

  let res = content |> write_bits(to: path)
  case res {
    Ok(_) -> Nil
    Error(_) -> {
      io.debug("error writing the file")
      Nil
    }
  }
}

pub fn read(file: File) -> Result(BitArray, simplifile.FileError) {
  read_bits(file.path)
}
