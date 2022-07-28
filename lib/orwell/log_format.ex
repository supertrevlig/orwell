defmodule Orwell.LogFormat do
  @moduledoc false

  @spec format_header() :: String.t()
  def format_header() do
    "|timestamp|id|referrer|"
  end

  @spec format_line(String.t(), String.t(), String.t()) :: String.t()
  def format_line(timestamp, id, referrer) do
    "|#{timestamp}|#{id}|#{referrer}|"
  end

  @spec parse_line(String.t()) :: %{
          id: String.t(),
          referrer: String.t(),
          timestamp: DateTime.t()
        }
  def parse_line(line) do
    case String.split(line, "|") do
      ["", timestamp, id, referrer, ""] ->
        case DateTime.from_iso8601(timestamp) do
          {:ok, timestamp, _} ->
            %{
              id: id,
              referrer: referrer,
              timestamp: timestamp
            }

          _ ->
            :bad_format
        end

      _ ->
        :bad_format
    end
  end

  @spec format_timestamp(DateTime.t()) :: String.t()
  def format_timestamp(timestamp) do
    timestamp |> DateTime.to_string()
  end
end
