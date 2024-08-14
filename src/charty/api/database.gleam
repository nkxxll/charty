/// this is the database mock
import charty/models/file.{type File}

// this is a lib for file stuff in gleam should use this
import simplefile

/// save a file in the file system
/// the file is uploaded via a form
/// files are saved in ./files/<title>
pub fn save(file: File, content: BitArray) {
  // A function to write content to a file
  let path = file.path
  // ensure directory is there
  // write the contents to the file
  // -> ok nothing
  // -> error return error i don't care for now
}
