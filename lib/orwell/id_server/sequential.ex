defmodule Orwell.IDServer.Sequential do
  @moduledoc false
  @behaviour Orwell.IDServer

  use Agent

  # Client API

  def start_link(name: name) do
    Agent.start_link(fn -> 1 end, name: name)
  end

  @impl Orwell.IDServer
  def next_id(pid) do
    Agent.get_and_update(pid, fn id -> {id, id + 1} end)
    |> Integer.to_string()
  end
end
