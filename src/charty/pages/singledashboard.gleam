//// Todo: add style

import charty/api/database.{type FileList, DoubleList, Name, SingleList}
import charty/models/file.{type File}
import charty/styles/global.{style}
import gleam/int
import gleam/list
import gleam/option.{None}
import lustre/attribute.{alt, attribute, id, src}
import lustre/element.{type Element}
import lustre/element/html.{div, img, script, span, text}
import wisp

type Dash {
  Dash(id: Int, name: String, files: FileList)
}

pub fn root(name: String) -> Element(t) {
  let dash_tuple = database.read_dash(Name(name), None)
  let #(dash_id, name, files) = dash_tuple
  let dash = Dash(dash_id, name, files)

  div([], [
    dash |> display_dash,
    div([id("fullscreenOverlay"), style([global.fullscreen_img_container])], [
      img([id("fullscreenImage"), style([global.fullscreen_img])]),
    ]),
    script(
      [],
      "function toggleFullscreen(image) {
      const overlay = document.getElementById('fullscreenOverlay');
      const fullscreenImage = document.getElementById('fullscreenImage');

      if (overlay.classList.contains('hidden')) {
        // Show the fullscreen overlay
        fullscreenImage.src = image.src; // Set the source to the clicked image
        overlay.classList.remove('hidden');
      } else {
        // Hide the fullscreen overlay
        overlay.classList.add('hidden');
      }
    }

    // Hide the overlay when the image in fullscreen is clicked
    document.getElementById('fullscreenImage').onclick = function () {
      document.getElementById('fullscreenOverlay').classList.add('hidden');
    };
",
    ),
  ])
}

fn display_dash(dash: Dash) -> Element(t) {
  let mi = dash.files |> max_items
  div([], [
    div([style([global.header_style, "mx-10"])], [
      text("ID: " <> int.to_string(dash.id)),
      text(dash.name),
    ]),
    div(
      [style([global.dash_container, "max-items-" <> int.to_string(mi)])],
      dash.files |> display_images,
    ),
  ])
}

fn display_images(files: FileList) -> List(Element(t)) {
  case files {
    SingleList(single) -> {
      single
      |> list.map(fn(a) { display_single_image(a) })
    }
    DoubleList(double) -> {
      double
      |> list.map(fn(a) {
        a
        |> list.map(fn(b) { display_single_image(b) })
      })
      |> list.concat
    }
  }
}

fn display_single_image(f: File) -> Element(t) {
  let img_src = src(f.serve_path)
  let alt_text = alt(f.name)
  div([style([global.dash_img_container])], [
    img([
      attribute("onclick", "toggleFullscreen(this)"),
      style([global.dash_row_img]),
      img_src,
      alt_text,
    ]),
    span([style([global.dash_img_span])], [text(f.name)]),
  ])
}

fn max_items(fl: FileList) -> Int {
  case fl {
    SingleList(s) -> s |> list.length
    DoubleList(d) -> {
      let first = d |> list.first
      case first {
        Ok(f) -> f |> list.length
        Error(_) -> {
          wisp.log_warning("double list first item lenght was 0")
          0
        }
      }
    }
  }
}
