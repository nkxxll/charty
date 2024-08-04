import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(elements: List(Element(t))) -> Element(t) {
  let navbar: Element(t) =
    html.nav([], [
      html.div([], [html.text("Home")]),
      html.div([], [html.text("Upload")]),
      html.div([], [html.text("Show")]),
    ])
  html.html([], [
    html.head([], [
      html.title([], "Todo App in Gleam"),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
      //html.link([attribute.rel("stylesheet"), attribute.href("/static/styles.css")]),
      html.script([attribute.src("https://cdn.tailwindcss.com")], ""),
    ]),
    html.body([], list.concat([[navbar], elements])),
  ])
}
