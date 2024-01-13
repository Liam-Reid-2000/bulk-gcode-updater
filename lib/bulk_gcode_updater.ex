defmodule BulkGcodeUpdater.Temperature do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(
        %Plug.Conn{params: %{"file_path" => file_path, "temperature" => temperature}} = conn,
        _opts
      ) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, change_temperature(file_path, temperature))
  end

  # M104 Command sets the temperature of the extruder
  # M109 Command makes the printer wait until the extruder reaches the target temperature
  def change_temperature(_file_path, _temperature) do
    file_stream = File.stream!("./priv/resources/benchy.gcode", [])

    res = Enum.at(file_stream, 0) |> IO.inspect()

    res
  end
end
