defmodule Orwell.LogWriter.Impl do
  @moduledoc false

  @behaviour Orwell.LogWriter

  @impl Orwell.LogWriter
  def open(path, header) do
    if !File.exists?(path) do
      File.open!(path, [:utf8, :write], fn file ->
        IO.puts(file, header)
      end)
    end
  end

  @impl Orwell.LogWriter
  def puts(path, line) do
    File.open!(path, [:utf8, :write, :append], fn file ->
      IO.puts(file, line)
    end)
  end
end
