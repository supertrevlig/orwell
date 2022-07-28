defmodule Orwell do
  @moduledoc false

  @callback next_id() :: String.t()
  @callback log(timestamp :: DateTime.t(), id :: String.t(), referrer :: String.t()) :: :ok
end
