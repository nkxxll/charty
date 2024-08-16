import charty/models/file.{type File}
import gleam/list
import lustre/attribute.{action, alt, class, for, id, method, src, type_, value}
import lustre/element.{type Element}
import lustre/element/html.{div, form, img, input, label, text}

pub fn root(files: List(File)) -> Element(t) {
  html.div([], [html.h1([], [html.text("Upload"), file_upload(files)])])
}

fn file_upload(flist) -> Element(t) {
  form(
    [id("add_file"), method("POST"), action("/api/builder")],
    files(flist)
      |> list.append([
        div([class("fg-white bg-blue rounded")], [
          input([type_("submit"), id("add_file"), value("submit")]),
        ]),
      ]),
  )
}

fn files(flist: List(File)) -> List(Element(t)) {
  flist
  |> list.map(fn(f) {
    div([], [
      img([src(f.serve_path), alt(f.name)]),
      label([for(f.name)], [text(f.name)]),
      input([id(f.name), type_("checkbox"), class("")]),
    ])
  })
}
