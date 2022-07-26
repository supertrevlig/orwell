defmodule Orwell.LogServer do
  @moduledoc false

  use GenServer

  @log_writer Application.compile_env(:orwell, :log_writer)

  alias Orwell.LogFormat

  # Client API

  def start_link(log_file: log_file, name: name) do
    GenServer.start_link(__MODULE__, [log_file], name: name)
  end

  @spec log(pid | atom, DateTime.t(), String.t(), String.t()) :: :ok
  def log(sid, timestamp, id, referrer) do
    GenServer.cast(sid, {:log, timestamp, id, referrer})
  end

  # Callbacks

  @impl true
  def init([log_file] = state) do
    @log_writer.open(log_file, LogFormat.format_header())
    {:ok, state}
  end

  @impl true
  def handle_cast({:log, timestamp, id, referrer}, [log_file] = state) do
    @log_writer.puts(
      log_file,
      LogFormat.format_line(LogFormat.format_timestamp(timestamp), id, referrer)
    )

    {:noreply, state}
  end

  def handle_cast(_request, state) do
    {:noreply, state}
  end
end
