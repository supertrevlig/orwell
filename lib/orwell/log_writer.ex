defmodule Orwell.LogWriter do
  @moduledoc false

  @callback open(path :: String.t(), header :: String.t()) :: :ok
  @callback puts(path :: String.t(), line :: String.t()) :: :ok
end
