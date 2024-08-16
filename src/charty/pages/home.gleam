import charty/models/file.{type File}
import gleam/list
import lustre/attribute.{class, href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, h1, li, ul}

pub fn root(items: List(File)) -> Element(t) {
  div([class("app")], [
    h1([class("text-xl font-bold")], [text("Charty")]),
    files(items),
  ])
}

fn files(files: List(File)) -> Element(t) {
  ul([], files |> list.map(file))
}

fn file(file: File) -> Element(t) {
  li([], [text(file.name <> " :at: "), a([href(file.path)], [text(file.path)])])
}
