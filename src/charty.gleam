import charty/models/file.{servedir}
import charty/router
import charty/web.{Context}
import gleam/erlang/process
import mist
import wisp

pub fn main() {
  wisp.configure_logger()

  let ctx =
    Context(
      static_directory: static_directory(),
      uploads: upload_directory(),
      files: [],
    )

  let handler = router.handle_request(_, ctx)

  let assert Ok(_) =
    // NOTE: the secret_key can be used to store keys for APIs (I guess) don't need it right now
    // the way to do it is shown in https://gleaming.dev/articles/building-your-first-gleam-web-app/
    wisp.mist_handler(handler, "secret_key")
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn upload_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("charty")
  priv_directory <> servedir
}

fn static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("charty")
  priv_directory <> "/static"
}
