import charty/api/database
import charty/models/file.{create_file}
import charty/web.{type Context}
import gleam/io
import gleam/list
import gleam/option.{None}
import gleam/result
import simplifile.{copy_file}
import wisp.{type Request}

pub fn upload(req: Request, ctx: Context) {
  io.debug(req.headers)
  io.debug(req.body)
  use form <- wisp.require_form(req)

  let current_files = ctx.files
  io.print("current files: ")
  io.debug(current_files)
  io.print("form values: ")
  io.debug(form.values)
  io.print("form files: ")
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

pub fn builder(req: Request, _ctx: Context) {
  use form <- wisp.require_form(req)

  io.print("form values: ")
  io.debug(form.values)
  io.print("form files: ")
  io.debug(form.files)

  let result = {
    use dash_name <- result.try(list.key_find(form.values, "dash_name"))
    let rest =
      form.values
      |> list.filter(fn(a) {
        let #(key, _) = a
        key != dash_name
      })
      |> list.map(fn(a) {
        let #(_key, value) = a
        create_file(value)
      })
    database.insert_dashboard1(dash_name, rest, None)
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
