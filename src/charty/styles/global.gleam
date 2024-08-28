//// this file holds global styles for the web application

import gleam/int
import gleam/string
import lustre/attribute.{type Attribute, class}

pub const navbar = "bg-gray-800 p-4 flex justify-between items-center"

pub const navbar_item = "text-white hover:bg-gray-700 hover:text-gray-300 px-3 py-2 rounded-md text-sm font-medium"

pub const header_style = "text-3xl font-bold text-gray-800 mb-8 text-center"

pub const list_img = "w-12 h-12 rounded-full object-cover mr-4"

pub const list_span = "flex-1 text-gray-700 font-medium"

pub const dash_img_span = "flex-1 text-gray-700 font-medium"

pub const list_checkbox = "form-checkbox h-5 w-5 text-blue-600"

pub const dash_container = "flex flex-row flex-wrap justify-around items-start gap-8"

pub const dash_img_container = "flex flex-col items-center"

pub const dash_row_img = "rounded-lg shadow-md object-cover"

pub const list_item = "flex items-center p-4"

pub const unorderd_list = "bg-white shadow-lg rounded-lg divide-y divide-gray-200"

pub const unorderd_list_div = "max-w-md mx-auto"

pub const list_item_div = ""

pub fn style(styles: List(String)) -> Attribute(t) {
  styles |> string.join(" ") |> class
}

/// returns the style string for the number of rows give 
pub fn row_width(rows: Int) -> String {
  "w-[" <> int.to_string(100 / rows) <> "]"
}
