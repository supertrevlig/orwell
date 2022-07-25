defmodule Orwell.Dummy do
  @moduledoc false
  @behaviour Orwell

  @impl Orwell
  def next_id do
    "dummy_id"
  end

  @impl Orwell
  def log(_timestamp, _id, _referrer) do
    :ok
  end
end
