import gleam/int
import gleam/list
import lustre/attribute.{class, href}
import lustre/element.{type Element}
import lustre/element/html.{a, div, li, span, text, ul}

pub fn root(dashes: List(#(Int, String))) -> Element(t) {
  html.div([], [
    html.h1([], [html.text("Builder"), build_dashboards_list(dashes)]),
  ])
}

fn build_dashboards_list(dashes: List(#(Int, String))) -> Element(t) {
  let div_style = class("max-w-md mx-auto")
  let ul_style = class("bg-white shadow rounded-lg divide-y divide-gray-200")
  div([div_style], [ul([ul_style], dashes |> list.map(dashboard_items))])
}

fn dashboard_items(dashboard: #(Int, String)) -> Element(t) {
  let #(id, name) = dashboard
  let list_item_style =
    class("bg-white shadow rounded-lg divide-y divide-gray-200")
  let span_style = class("text-gray-600 font-medium m-2")
  let a_style = class("text-blue-600 hover:underline m-2")
  li([list_item_style], [
    span([span_style], [text(int.to_string(id))]),
    a([href("/dashboard/" <> name), a_style], [text(name)]),
  ])
}
