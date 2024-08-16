import charty/models/file.{type File}
import charty/pages/builder
import charty/pages/home
import charty/pages/upload

pub fn home(files: List(File)) {
  home.root(files)
}

pub fn upload() {
  upload.root()
}

pub fn builder(files: List(File)) {
  builder.root(files)
}
