defmodule OrwellTest.LogServerTest do
  use ExUnit.Case

  alias Orwell.LogServer

  setup do
    start_supervised({LogServer, [log_file: "dummy", name: :log_server_test]})
    :ok
  end

  test "starts" do
    assert true
  end

  test "logs" do
    LogServer.log(:log_server_test, DateTime.utc_now(), "1", "domain.com")
    assert true
  end
end
