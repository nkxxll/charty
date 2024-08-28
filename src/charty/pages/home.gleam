import charty/models/file.{type File}
import charty/styles/global.{style}
import gleam/list
import lustre/attribute.{alt, class, src}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h1, img, li, span, ul}

pub fn root(items: List(File)) -> Element(t) {
  div([class("app")], [
    h1([style([global.header_style])], [text("Charty")]),
    files(items),
  ])
}

fn files(files: List(File)) -> Element(t) {
  div([style([global.unorderd_list_div])], [
    ul([style([global.unorderd_list])], files |> list.map(file)),
  ])
}

fn file(f: File) -> Element(t) {
  //<!-- List Item -->
  //<li class="flex items-center bg-white shadow rounded-lg p-4">
  //  <img src="example.jpg" alt="Preview Image" class="w-16 h-16 object-cover rounded-md mr-4">
  //  <span class="font-medium text-gray-700">example.jpg</span>
  //</li>
  li([style([global.list_item])], [
    img([style([global.list_img]), src(f.serve_path), alt(f.name)]),
    span([style([global.list_span])], [text(f.name)]),
  ])
}
