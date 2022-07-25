defmodule Orwell.IDServer.Random do
  @moduledoc false
  @behaviour Orwell.IDServer

  use Agent

  # Client API

  def start_link(name: name) do
    Agent.start_link(fn -> random_id() end, name: name)
  end

  @impl Orwell.IDServer
  def next_id(pid) do
    Agent.get_and_update(pid, fn id -> {id, random_id()} end)
  end

  def random_id() do
    :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
  end
end
