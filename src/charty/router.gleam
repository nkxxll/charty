import charty/api
import charty/api/files_middleware.{files_middleware}
import charty/pages
import charty/pages/layout.{layout}
import charty/web.{type Context}
import gleam/http
import gleam/io
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use _req <- web.middleware(req, ctx)
  use ctx <- files_middleware(req, ctx)
  case wisp.path_segments(req) {
    // Homepage
    [] -> {
      [pages.home(ctx.files)]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }

    ["builder"] -> {
      [pages.builder(ctx.files)]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
    // Upload
    ["upload"] -> {
      [pages.upload()]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }

    ["api", "upload"] -> {
      io.debug("calling api upload")
      use <- wisp.require_method(req, http.Post)
      api.upload(req, ctx)
    }

    ["api", "builder"] -> {
      io.debug("calling api builder")
      use <- wisp.require_method(req, http.Post)
      api.builder(req, ctx)
    }

    // All the empty responses
    ["internal-server-error"] -> wisp.internal_server_error()
    ["unprocessable-entity"] -> wisp.unprocessable_entity()
    ["method-not-allowed"] -> wisp.method_not_allowed([])
    ["entity-too-large"] -> wisp.entity_too_large()
    ["bad-request"] -> wisp.bad_request()
    _ -> wisp.not_found()
  }
}
