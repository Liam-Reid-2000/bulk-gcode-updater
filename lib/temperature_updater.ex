defmodule BulkGcodeUpdater.Temperature do
  def change_temperature(file_path, temp) do
    res =
      file_path
      |> File.stream!([])
      |> Enum.map(&process_instruction(&1, temp))

    File.write(file_path, res)
  end

  defp process_instruction(instruction, temp) do
    if needs_amending?(instruction) do
      [command, _old_temp] = String.split(instruction, " ")
      "#{command} S#{temp}\n"
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
