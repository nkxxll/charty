import charty/models/file.{type File}
import charty/styles/global.{style}
import gleam/list
import lustre/attribute.{
  action, alt, for, id, method, name, required, src, type_, value,
}
import lustre/element.{type Element}
import lustre/element/html.{div, form, img, input, label, li, text, ul}

pub fn root(files: List(File)) -> Element(t) {
  html.div([], [
    html.h1([style([global.header_style])], [html.text("Builder")]),
    file_upload(files),
  ])
}

fn file_upload(flist) -> Element(t) {
  form([id("add_dash"), method("POST"), action("/api/builder")], [
    div([style([global.unorderd_list_div])], [
      ul(
        [style([global.unorderd_list_div])],
        files(flist)
          |> list.append([
            div([style([global.list_item_div])], [
              li([style([global.list_item])], [
                input([
                  style([global.list_item, global.input_text]),
                  name("dash_name"),
                  type_("text"),
                  id("add_dash"),
                  required(True),
                ]),
              ]),
            ]),
            div([style([global.list_item_div])], [
              li([style([global.list_item])], [
                input([
                  style([global.submit]),
                  type_("submit"),
                  id("add_dash"),
                  value("submit"),
                ]),
              ]),
            ]),
          ]),
      ),
    ]),
  ])
}

fn files(flist: List(File)) -> List(Element(t)) {
  flist
  |> list.map(fn(f) {
    div([style([global.list_item_div])], [
      li([style([global.list_item])], [
        img([style([global.list_img]), src(f.serve_path), alt(f.name)]),
        label([style([global.list_span]), for(f.name)], [text(f.name)]),
        input([
          style([global.list_checkbox]),
          id(f.name),
          name(f.name),
          type_("checkbox"),
        ]),
      ]),
    ])
  })
}
