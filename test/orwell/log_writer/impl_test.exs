defmodule OrwellTest.LogWriter.ImplTest do
  use ExUnit.Case

  alias Orwell.LogWriter.Impl, as: LogWriter

  @test_dir "/tmp/"

  setup do
    log_file = Path.join(@test_dir, :crypto.strong_rand_bytes(10) |> Base.url_encode64())
    on_exit(fn -> File.rm!(log_file) end)
    {:ok, %{log_file: log_file}}
  end

  test "creates log file", %{log_file: log_file} do
    LogWriter.open(log_file, "headers")
    assert File.exists?(log_file)
  end

  test "writes header", %{log_file: log_file} do
    LogWriter.open(log_file, "headers")

    headers =
      log_file
      |> File.read!()
      |> String.split("\n")
      |> Enum.take(1)

    assert headers == ["headers"]
  end

  test "writes line to log file", %{log_file: log_file} do
    LogWriter.open(log_file, "headers")
    LogWriter.puts(log_file, "log line")

    [_header, line] =
      log_file
      |> File.read!()
      |> String.split("\n")
      |> Enum.take(2)

    assert line == "log line"
  end
end
