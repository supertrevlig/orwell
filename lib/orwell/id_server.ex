defmodule Orwell.IDServer do
  @moduledoc false

  @callback next_id(pid | atom) :: String.t()
end
