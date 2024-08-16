import lustre/attribute.{
  accept, action, autofocus, enctype, id, method, name, placeholder, type_,
  value,
}
import lustre/element.{type Element}
import lustre/element/html.{form, input}

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
      accept(["*"]),
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
      input([type_("submit"), id("add_file"), value("submit")]),
    ],
  )
}
