defmodule Orwell.Impl do
  @moduledoc false
  @behaviour Orwell

  @id_server Application.compile_env(:orwell, :id_server)

  @impl Orwell
  def next_id do
    @id_server.next_id(Orwell.IDServer)
  end

  @impl Orwell
  def log(timestamp, id, referrer) do
    Orwell.LogServer.log(Orwell.LogServer, timestamp, id, referrer)
  end
end
