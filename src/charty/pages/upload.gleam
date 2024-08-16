import lustre/attribute.{
  accept, action, autofocus, class, enctype, id, method, name, placeholder,
  type_, value,
}
import lustre/element.{type Element}
import lustre/element/html.{div, form, input}

pub fn root() -> Element(t) {
  html.div([], [html.h1([], [html.text("Upload"), file_upload()])])
}

fn file_upload() -> Element(t) {
  form(
    [
      id("add_file"),
      method("POST"),
      action("/api/upload"),
      enctype("multipart/form-data"),
      accept(["image/jpg", "image/png", "image/svg"]),
    ],
    [
      input([
        name("file_name"),
        id("add_file"),
        placeholder("How should your image be called?"),
        autofocus(True),
      ]),
      input([
        name("file_content"),
        type_("file"),
        id("add_file"),
        enctype("multipart/form-data"),
      ]),
      div([class("fg-white bg-blue rounded")], [
        input([type_("submit"), id("add_file"), value("submit")]),
      ]),
    ],
  )
}
