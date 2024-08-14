import charty/models/file.{type File, create_file}
import charty/web.{type Context, Context}
import gleam/dynamic
import gleam/json
import gleam/list
import wisp.{type Request, type Response}

type FilesJson {
  FilesJson(name: String, path: String)
}

pub fn files_middleware(
  req: Request,
  ctx: Context,
  handle_request: fn(Context) -> Response,
) {
  let parsed_files = {
    case wisp.get_cookie(req, "files", wisp.PlainText) {
      Ok(json_string) -> {
        let decoder =
          dynamic.decode2(
            FilesJson,
            dynamic.field("name", dynamic.string),
            dynamic.field("path", dynamic.string),
          )
          |> dynamic.list

        let result = json.decode(json_string, decoder)
        case result {
          Ok(files) -> files
          Error(_) -> []
        }
      }
      Error(_) -> []
    }
  }

  let files = create_files_from_json(parsed_files)

  let ctx = Context(..ctx, files: files)

  handle_request(ctx)
}

fn create_files_from_json(files: List(FilesJson)) -> List(File) {
  files
  |> list.map(fn(item) {
    let FilesJson(name, path) = item
    create_file(name, path)
  })
}
