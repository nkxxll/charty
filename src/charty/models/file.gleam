pub const basedir = "./files"

/// file is the data structure for a file
/// a file is stored at ./files/<title>
/// for now file types are svgs
pub type File {
  File(name: String, path: String)
}

/// if we have to do fancy stuff we can use this wrapper
pub fn create_file(name: String, path: String) {
  File(name, path)
}
