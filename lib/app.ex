defmodule BulkGcodeUpdater do
  use Application
  alias BulkGcodeUpdater.Temperature

  def start(_type, args) do
    IO.puts "starting"

    [file_path, temp] = args
    Temperature.change_temperature(file_path, temp)

    IO.puts "finished"

    # prevent error
    Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end
end
