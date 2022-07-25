defmodule OrwellTest.LogFormatTest do
  use ExUnit.Case

  alias Orwell.LogFormat

  test "parses formatted line" do
    id = "12345"
    referrer = "domain.com"
    timestamp = DateTime.utc_now()

    parsed =
      LogFormat.format_line(timestamp, id, referrer)
      |> LogFormat.parse_line()

    assert parsed == %{
             timestamp: timestamp,
             id: id,
             referrer: referrer
           }
  end

  test "parses badly formatted line" do
    bad_format = LogFormat.parse_line("gibberish")
    assert bad_format == :bad_format
  end
end
