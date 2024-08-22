import charty/api/database
import charty/web.{type Context, Context}
import gleam/io
import gleam/list
import gleam/option.{None}
import wisp.{type Request, type Response}

pub fn dash_middleware(
  _req: Request,
  ctx: Context,
  handle_request: fn(Context) -> Response,
) {
  let dashs =
    database.read_all_id_name(None)
    |> io.debug
    |> list.map(fn(a) {
      let #(id, name) = a
      #(id, name)
    })

  let ctx = Context(..ctx, dashs: dashs)

  handle_request(ctx)
}
