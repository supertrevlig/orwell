defmodule OrwellTest.IDServer.Sequential do
  use ExUnit.Case

  alias Orwell.IDServer.Sequential

  setup do
    start_supervised({Sequential, [name: :id_server_test]})
    :ok
  end

  test "generates unique ids" do
    count = 1000

    ids =
      Enum.map(1..count, fn _ ->
        Sequential.next_id(:id_server_test)
      end)

    assert Enum.count(Enum.uniq(ids)) == count
  end
end
