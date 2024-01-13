defmodule BulkGcodeUpdater.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/", to: BulkGcodeUpdater.Plug
  get "/temperature/:file_path/:temperature", to: BulkGcodeUpdater.Temperature

  match _ do
    send_resp(conn, 404, "oops")
  end
end
