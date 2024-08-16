/// directory where files are stored on the file system
pub const basedir = "./priv/uploads"

/// directory where files are served on the server
pub const servedir = "/uploads"

/// file is the data structure for a file
/// a file is stored at ./basedir/<title>
/// a file is served under http://server.com/<servedir>/<title>
/// for now file types are svgs
pub type File {
  File(name: String, path: String, serve_path: String)
}

/// if we have to do fancy stuff we can use this wrapper
pub fn create_file(name: String) {
  File(name, basedir <> "/" <> name, servedir <> "/" <> name)
}
