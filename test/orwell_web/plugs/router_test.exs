defmodule OrwellTest.OrwellWeb.Plugs.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias OrwellWeb.Plugs.Router

  @opts Router.init([])

  test "returns not found" do
    # Create a test connection
    conn = conn(:get, "/not_found")

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "not found"
  end

  test "returns pixel.gif" do
    # Create a test connection
    conn = conn(:get, "/pixel.gif")

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
  end
end
