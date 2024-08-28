import charty/styles/global.{style}

import lustre/attribute.{
  accept, action, autofocus, enctype, id, method, name, placeholder, required,
  type_, value,
}
import lustre/element.{type Element}
import lustre/element/html.{div, form, input, li, ul}

pub fn root() -> Element(t) {
  html.div([], [
    html.h1([style([global.header_style])], [html.text("Upload")]),
    file_upload(),
  ])
}

fn file_upload() -> Element(t) {
  form(
    [
      id("add_file"),
      method("POST"),
      action("/api/upload"),
      enctype("multipart/form-data"),
      accept(["image/jpg", "image/png", "image/svg"]),
      style([global.unorderd_list_div]),
    ],
    [
      ul([style([global.unorderd_list_div])], [
        div([style([global.unorderd_list_div])], [
          input([
            style([global.list_item, global.input_text, "w-1/2"]),
            name("file_name"),
            type_("text"),
            id("add_file"),
            placeholder("How should your image be called?"),
            autofocus(True),
            required(True),
          ]),
        ]),
        div([style([global.unorderd_list_div])], [
          li([style([global.list_item_div])], [
            input([
              style([global.list_item]),
              name("file_content"),
              type_("file"),
              id("add_file"),
              enctype("multipart/form-data"),
            ]),
          ]),
        ]),
        div([style([global.list_item_div])], [
          li([style([global.list_item_div])], [
            input([
              style([global.submit]),
              type_("submit"),
              id("add_file"),
              value("submit"),
            ]),
          ]),
        ]),
      ]),
    ],
  )
}
