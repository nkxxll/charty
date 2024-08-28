import charty/styles/global.{style}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(elements: List(Element(t))) -> Element(t) {
  let navbar: Element(t) =
    html.nav([style([global.navbar])], [
      html.a([style([global.navbar_item]), attribute.href("/")], [
        html.text("home"),
      ]),
      html.a([style([global.navbar_item]), attribute.href("/upload")], [
        html.text("upload"),
      ]),
      html.a([style([global.navbar_item]), attribute.href("/builder")], [
        html.text("builder"),
      ]),
      html.a([style([global.navbar_item]), attribute.href("/dashboards")], [
        html.text("dashboards"),
      ]),
    ])
  html.html([], [
    html.head([], [
      html.title([], "Charty a Dashboard Builder"),
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
