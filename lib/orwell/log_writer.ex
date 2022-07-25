defmodule Orwell.LogWriter do
  @callback open(path :: String.t(), header :: String.t()) :: :ok
  @callback puts(path :: String.t(), line :: String.t()) :: :ok
end
