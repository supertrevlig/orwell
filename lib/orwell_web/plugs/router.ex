defmodule OrwellWeb.Plugs.Router do
  use Plug.Router

  alias OrwellWeb.Plugs.Pixel

  plug :match
  plug :dispatch

  match "/pixel.gif", via: :get, to: Pixel

  match _ do
    send_resp(conn, 404, "not found")
  end
end
