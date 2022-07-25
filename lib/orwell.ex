defmodule Orwell do
  @callback next_id() :: String.t()
  @callback log(id :: String.t(), referrer :: String.t(), timestamp :: DateTime.t()) :: :ok
end
