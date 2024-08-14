import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(elements: List(Element(t))) -> Element(t) {
  let navbar_style =
    attribute.class("bg-gray-800 p-4 flex justify-between items-center")
  let navbar_element_style =
    attribute.class(
      "text-white hover:bg-gray-700 hover:text-gray-300 px-3 py-2 rounded-md text-sm font-medium",
    )
  let navbar: Element(t) =
    html.nav([navbar_style], [
      html.a([navbar_element_style, attribute.href("/")], [html.text("home")]),
      html.a([navbar_element_style, attribute.href("/upload")], [
        html.text("upload"),
      ]),
      html.a([navbar_element_style, attribute.href("/builder")], [
        html.text("builder"),
      ]),
      html.a([navbar_element_style, attribute.href("/dashboards")], [
        html.text("dashboards"),
      ]),
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
