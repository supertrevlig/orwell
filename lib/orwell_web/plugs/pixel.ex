defmodule OrwellWeb.Plugs.Pixel do
  @moduledoc false

  import Plug.Conn

  @orwell Application.compile_env(:orwell, :orwell)

  @gif <<71, 73, 70, 56, 57, 97, 1, 0, 1, 0, 240, 0, 0, 0, 0, 0, 0, 0, 0, 33, 249, 4, 1, 0, 0, 0,
         0, 33, 255, 11, 73, 109, 97, 103, 101, 77, 97, 103, 105, 99, 107, 14, 103, 97, 109, 109,
         97, 61, 48, 46, 52, 53, 52, 53, 52, 53, 0, 44, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 2, 68, 1, 0,
         59>>

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn = fetch_cookies(conn)

    id =
      case conn.req_cookies do
        %{"id" => id} ->
          id

        _ ->
          @orwell.next_id()
      end

    referrer =
      case get_req_header(conn, "referer") do
        [referrer] ->
          referrer

        _ ->
          ""
      end

    timestamp = DateTime.utc_now()

    @orwell.log(timestamp, id, referrer)

    conn
    |> put_resp_content_type("image/gif", nil)
    |> put_resp_cookie("id", id)
    |> put_resp_header("cache-control", "no-store")
    |> send_resp(200, @gif)
  end
end
