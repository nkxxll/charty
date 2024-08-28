//// Todo: add style

import charty/api/database.{type FileList, DoubleList, Name, SingleList}
import charty/models/file.{type File}
import charty/styles/global.{style}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None}
import lustre/attribute.{alt, src}
import lustre/element.{type Element}
import lustre/element/html.{div, img, span, text}

type Dash {
  Dash(id: Int, name: String, files: FileList)
}

pub fn root(name: String) -> Element(t) {
  let dash_tuple = database.read_dash(Name(name), None)
  let #(id, name, files) = dash_tuple
  let dash = Dash(id, name, files)
  io.debug(id)
  io.debug(name)
  io.debug(files)

  div([], [dash |> display_dash])
}

fn display_dash(dash: Dash) -> Element(t) {
  div([], [
    div([style([global.header_style])], [
      text(int.to_string(dash.id)),
      text(dash.name),
    ]),
    div([style([global.dash_container])], dash.files |> display_images),
  ])
}

fn display_images(files: FileList) -> List(Element(t)) {
  case files {
    SingleList(single) -> {
      let count = list.length(single)
      single
      |> list.map(fn(a) { display_single_image(a, count) })
    }
    DoubleList(double) -> {
      double
      |> list.map(fn(a) {
        let count = list.length(a)
        a
        |> list.map(fn(b) { display_single_image(b, count) })
      })
      |> list.concat
    }
  }
}

fn display_single_image(f: File, rows: Int) -> Element(t) {
  io.debug(f)
  io.debug(rows)
  let img_src = src(f.serve_path)
  let alt_text = alt(f.name)
  div([style([global.dash_img_container])], [
    img([style([global.dash_row_img]), img_src, alt_text]),
    span([style([global.dash_img_span])], [text(f.name)]),
  ])
}
