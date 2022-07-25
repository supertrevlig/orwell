defmodule OrwellTest.OrwellWeb.Plugs.PixelTest do
  use ExUnit.Case
  use Plug.Test

  alias OrwellWeb.Plugs.Pixel

  @gif <<71, 73, 70, 56, 57, 97, 1, 0, 1, 0, 240, 0, 0, 0, 0, 0, 0, 0, 0, 33, 249, 4, 1, 0, 0, 0,
         0, 33, 255, 11, 73, 109, 97, 103, 101, 77, 97, 103, 105, 99, 107, 14, 103, 97, 109, 109,
         97, 61, 48, 46, 52, 53, 52, 53, 52, 53, 0, 44, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 2, 68, 1, 0,
         59>>

  @opts Pixel.init([])

  test "returns pixel.gif" do
    conn = conn(:get, "/pixel.gif")
    conn = Pixel.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp_headers = Enum.into(conn.resp_headers, %{})
    assert resp_headers["content-type"] == "image/gif"

    assert conn.resp_body == @gif
  end

  test "sets id-cookie if no id-cookie is set" do
    conn = conn(:get, "/pixel.gif")
    conn = Pixel.call(conn, @opts)
    assert %{"id" => "dummy_id"} = conn.cookies
  end

  test "preserves id-cookie if id-cookies is set" do
    conn = conn(:get, "/pixel.gif")

    conn =
      Plug.Conn.update_req_header(
        conn,
        "cookie",
        "id=foobar",
        &(&1 <> "; id=foobar")
      )

    conn = Pixel.call(conn, @opts)
    assert %{"id" => "foobar"} = conn.cookies
  end

  test "sets cache-control" do
    conn = conn(:get, "/pixel.gif")
    conn = Pixel.call(conn, @opts)
    resp_headers = Enum.into(conn.resp_headers, %{})
    assert resp_headers["cache-control"] == "no-store"
  end
end
