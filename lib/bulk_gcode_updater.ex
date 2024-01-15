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
    file_path = "./priv/resources/benchy.gcode"
    temp = 200

    res =
      file_path
      |> File.stream!([])
      |> Enum.map(&process_instruction(&1, temp))

    File.write(file_path, res)
  end

  defp process_instruction(instruction, temp) do
    if needs_amending?(instruction) do
      String.replace(instruction, "S220", "S#{temp}")
    else
      instruction
    end
  end

  defp needs_amending?(instruction) do
    contains_command? =
      String.contains?(instruction, "M104") or String.contains?(instruction, "M109")

    sets_to_zero? = String.contains?(instruction, "S0")

    contains_command? and not sets_to_zero?
  end
end
