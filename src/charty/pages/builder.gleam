import charty/models/file.{type File}
import gleam/list
import lustre/attribute.{
  action, alt, class, for, id, method, name, src, type_, value,
}
import lustre/element.{type Element}
import lustre/element/html.{div, form, img, input, label, text}

pub fn root(files: List(File)) -> Element(t) {
  html.div([], [html.h1([], [html.text("Builder"), file_upload(files)])])
}

fn file_upload(flist) -> Element(t) {
  form([id("add_dash"), method("POST"), action("/api/builder")], [
    div(
      [class("space-y-4")],
      files(flist)
        |> list.append([
          div([class("fg-black bg-white rounded border")], [
            input([name("dash_name"), type_("text"), id("add_dash")]),
          ]),
          div([class("fg-black bg-white rounded border")], [
            input([type_("submit"), id("add_dash"), value("submit")]),
          ]),
        ]),
    ),
  ])
}

fn files(flist: List(File)) -> List(Element(t)) {
  flist
  |> list.map(fn(f) {
    div([], [
      img([
        class("w-16 h-16 object-cover rounded-md mr-4"),
        src(f.serve_path),
        alt(f.name),
      ]),
      label([class("font-medium text-gray-700"), for(f.name)], [text(f.name)]),
      input([
        class("font-medium text-gray-700"),
        id(f.name),
        name(f.name),
        type_("checkbox"),
      ]),
    ])
  })
}
