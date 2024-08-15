import lustre/attribute.{autofocus, class, name, placeholder, type_}
import lustre/element.{type Element}
import lustre/element/html.{form, input}

pub fn root() -> Element(t) {
  html.div([], [html.h1([], [html.text("Upload"), file_upload()])])
}

fn file_upload() -> Element(t) {
  form(
    [
      class("add_file"),
      attribute.method("POST"),
      attribute.action("/api/upload"),
    ],
    [
      input([
        name("file_name"),
        class("add_file"),
        placeholder("How should your image be called?"),
        autofocus(True),
      ]),
      input([name("file_content"), type_("file"), class("add_file")]),
    ],
  )
}
