import charty/styles/global.{style}
import gleam/int
import gleam/list
import lustre/attribute.{href}
import lustre/element.{type Element}
import lustre/element/html.{a, div, li, span, text, ul}

pub fn root(dashes: List(#(Int, String))) -> Element(t) {
  html.div([], [
    html.h1([], [html.text("Builder"), build_dashboards_list(dashes)]),
  ])
}

fn build_dashboards_list(dashes: List(#(Int, String))) -> Element(t) {
  div([style([global.unorderd_list_div])], [
    ul([style([global.unorderd_list])], dashes |> list.map(dashboard_items)),
  ])
}

fn dashboard_items(dashboard: #(Int, String)) -> Element(t) {
  let #(id, name) = dashboard
  div([style([global.list_item_div])], [
    li([style([global.list_item])], [
      span([style([global.list_span])], [text(int.to_string(id))]),
      a([href("/dashboard/" <> name), style([global.list_span])], [text(name)]),
    ]),
  ])
}
