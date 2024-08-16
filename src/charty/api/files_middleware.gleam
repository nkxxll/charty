import charty/models/file.{type File, basedir, create_file}
import charty/web.{type Context, Context}
import gleam/list
import simplifile.{read_directory}
import wisp.{type Request, type Response}

pub fn files_middleware(
  _req: Request,
  ctx: Context,
  handle_request: fn(Context) -> Response,
) {
  let files = create_files_from_path()

  let ctx = Context(..ctx, files: files)

  handle_request(ctx)
}

/// get files from the database in this case this is the file system for now
fn create_files_from_path() -> List(File) {
  let assert Ok(files) = read_directory(basedir)
  files
  |> list.map(fn(name) { create_file(name) })
}
