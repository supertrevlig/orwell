defmodule OrwellCli.Main do
  alias Orwell.LogFormat

  def help() do
    ~S"""
    View Orwell log

    Usage: orwell [OPTION]...

    Mandatory arguments:
      --from      ISO8601 datetime (i.e '2022-07-25T10:04:51Z').
      --to        ISO8601 datetime.
      --log-file  Path to log file.
    """
  end

  def main(args \\ []) do
    args |> parse_args() |> process()
  end

  def parse_args(args) do
    {opts, _unparsed, _invalid} =
      args |> OptionParser.parse(strict: [from: :string, to: :string, log_file: :string])

    options = Enum.into(opts, %{})

    from_date =
      case options[:from] do
        nil ->
          :no_opt

        from ->
          case DateTime.from_iso8601(from) do
            {:ok, date_time, _} -> date_time
            _ -> :invalid
          end
      end

    to_date =
      case options[:to] do
        nil ->
          :no_opt

        to ->
          case DateTime.from_iso8601(to) do
            {:ok, date_time, _} -> date_time
            _ -> :invalid
          end
      end

    log_file =
      case options[:log_file] do
        nil ->
          :no_opt

        log_file ->
          case File.exists?(log_file) do
            true -> log_file
            _ -> :not_found
          end
      end

    {from_date, to_date, log_file}
  end

  def process({:no_opt, _, _}), do: IO.puts(help())
  def process({_, :no_opt, _}), do: IO.puts(help())
  def process({_, _, :no_opt}), do: IO.puts(help())

  def process({:invalid, _, _}), do: IO.puts("invalid 'from' date.")
  def process({_, :invalid, _}), do: IO.puts("invalid 'to' date.")
  def process({_, _, :not_found}), do: IO.puts("log file not found.")

  def process({from_date, to_date, log_file}) do
    stream = File.stream!(log_file, [:utf8, :read])

    result =
      stream
      |> Stream.map(&String.trim/1)
      |> Stream.map(&LogFormat.parse_line/1)
      |> Stream.filter(fn parsed_line -> parsed_line != :bad_format end)
      |> Stream.filter(fn parsed_line ->
        DateTime.compare(from_date, parsed_line.timestamp) == :lt &&
          DateTime.compare(to_date, parsed_line.timestamp) == :gt
      end)
      |> Enum.group_by(fn parsed_line -> parsed_line.referrer end)
      |> Enum.map(fn {referrer, parsed_lines} ->
        %{
          host: host,
          path: path,
          port: port
        } = URI.parse(referrer)

        host =
          if port && port != 80 do
            "#{host}:#{port}"
          else
            host
          end

        %{
          host: host,
          path: path,
          visits: Enum.count(parsed_lines),
          unique: Enum.count(Enum.uniq_by(parsed_lines, fn line -> line.id end))
        }
      end)
      |> Enum.map(&format_result_line/1)

    result = [format_header() | result]

    result |> Enum.each(&IO.puts/1)
  end

  def format_header() do
    h = format_host("host")
    p = format_path("path")
    v = format_visits("visits")
    u = format_unique("unique")

    "|#{h}|#{p}|#{v}|#{u}|"
  end

  def format_result_line(line) do
    h = format_host("#{line.host}")
    p = format_path("#{line.path}")
    v = format_visits("#{line.visits}")
    u = format_unique("#{line.unique}")

    "|#{h}|#{p}|#{v}|#{u}|"
  end

  def format_host(s), do: String.pad_trailing(s, 25)
  def format_path(s), do: String.pad_trailing(s, 25)
  def format_visits(s), do: String.pad_trailing(s, 10)
  def format_unique(s), do: String.pad_trailing(s, 10)
end
