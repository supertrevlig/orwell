defmodule Orwell.LogWriter.Dummy do
  @behaviour Orwell.LogWriter

  @impl Orwell.LogWriter
  def open(_path, _header) do
    :ok
  end

  @impl Orwell.LogWriter
  def puts(_path, _line) do
    :ok
  end
end
