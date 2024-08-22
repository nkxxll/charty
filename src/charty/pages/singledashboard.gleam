//// Todo: add style

import charty/api/database.{type FileList, DoubleList, Name, SingleList}
import charty/models/file.{type File}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None}
import lustre/attribute.{alt, class, src}
import lustre/element.{type Element}
import lustre/element/html.{div, img, text}

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
  let page_style = class("")
  let header_div_style = class("text-xl")
  let image_container_style =
    class("flex flex-row justify-around items-center gap-4")
  div([page_style], [
    div([header_div_style], [text(int.to_string(dash.id)), text(dash.name)]),
    div([image_container_style], dash.files |> display_images),
  ])
}

fn display_images(files: FileList) -> List(Element(t)) {
  case files {
    SingleList(single) -> {
      io.debug("single")
      io.debug(single)
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
  let img_div_style = class("" <> int.to_string(rows) <> "")
  let img_style = class("rounded-lg shadow-md")
  let img_src = src(f.serve_path)
  let alt_text = alt(f.name)
  div([img_div_style], [img([img_style, img_src, alt_text])])
}
