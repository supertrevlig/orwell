defmodule Orwell.IDServer do
  @callback next_id(pid | atom) :: String.t()
end
