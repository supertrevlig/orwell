defmodule Orwell.IDServer do
  @callback next_id(pid :: pid()) :: String.t()
end
