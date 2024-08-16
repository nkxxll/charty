import charty/models/file.{create_file}
import charty/web.{type Context}
import gleam/io
import gleam/list
import gleam/result
import simplifile.{copy_file}
import wisp.{type Request}

pub fn upload(req: Request, ctx: Context) {
  io.debug(req.headers)
  io.debug(req.body)
  use form <- wisp.require_form(req)

  let current_files = ctx.files
  io.debug(current_files)
  io.debug("form values: ")
  io.debug(form.values)
  io.debug("form files: ")
  io.debug(form.files)

  let result = {
    use file_name <- result.try(list.key_find(form.values, "file_name"))
    use upfile <- result.try(list.key_find(form.files, "file_content"))
    io.debug(
      "upload file path: "
      <> upfile.path
      <> " upfile file name: "
      <> upfile.file_name,
    )
    // TODO: check that file is jpg, png or svg
    let new_item = create_file(file_name)
    // copy the file to files dir does not work
    let _ = copy_file(upfile.path, new_item.path)
    Ok(Nil)
  }

  case result {
    Ok(_) -> {
      wisp.redirect("/")
    }
    Error(_) -> {
      wisp.bad_request()
    }
  }
}
