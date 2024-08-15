import charty/api/database.{save}
import charty/models/file.{type File, basedir, create_file}
import charty/web.{type Context}
import gleam/io
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import simplifile.{copy_file}
import wisp.{type Request}

pub fn upload(req: Request, ctx: Context) {
  use form <- wisp.require_form(req)

  let current_files = ctx.files
  io.debug(current_files)
  io.debug(form.values)
  io.debug(form.files)

  let result = {
    use file_name <- result.try(list.key_find(form.values, "file_name"))
    // FIXME: this does not work because the file is not transmitted
    use upfile <- result.try(list.key_find(form.values, "file_content"))
    io.debug("upload file path: " <> upfile)
    let path = basedir <> "/" <> file_name
    let new_item = create_file(file_name, path)
    // copy the file to files dir does not work
    let _ = copy_file(upfile, path)
    list.append(current_files, [new_item])
    |> todos_to_json
    |> Ok
  }

  case result {
    Ok(todos) -> {
      wisp.redirect("/")
      |> wisp.set_cookie(req, "files", todos, wisp.PlainText, 60 * 60 * 24)
    }
    Error(_) -> {
      wisp.bad_request()
    }
  }
}

fn todos_to_json(items: List(File)) -> String {
  "["
  <> items
  |> list.map(item_to_json)
  |> string.join(",")
  <> "]"
}

fn item_to_json(item: File) -> String {
  json.object([
    #("name", json.string(item.name)),
    #("path", json.string(item.path)),
  ])
  |> json.to_string
}
