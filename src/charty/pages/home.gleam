import charty/models/file.{type File}
import gleam/list
import lustre/attribute.{alt, class, src}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h1, img, li, span, ul}

pub fn root(items: List(File)) -> Element(t) {
  div([class("app")], [
    h1([class("text-xl font-bold")], [text("Charty")]),
    files(items),
  ])
}

fn files(files: List(File)) -> Element(t) {
  ul([class("space-y-4")], files |> list.map(file))
}

fn file(f: File) -> Element(t) {
  //<!-- List Item -->
  //<li class="flex items-center bg-white shadow rounded-lg p-4">
  //  <img src="example.jpg" alt="Preview Image" class="w-16 h-16 object-cover rounded-md mr-4">
  //  <span class="font-medium text-gray-700">example.jpg</span>
  //</li>
  li([class("flex items-center bg-white shadow rounded-lg p-4")], [
    img([
      class("w-16 h-16 object-cover rounded-md mr-4"),
      src(f.serve_path),
      alt(f.name),
    ]),
    span([class("font-medium text-gray-700")], [text(f.name)]),
  ])
}
