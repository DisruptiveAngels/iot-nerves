defmodule Ui.Store do

  require Logger

  @defaults %{
    data: %{},
    threshold: 50,
    uart_buffer: 0
  }

  def start_link do
    Logger.debug "Initializing store"
    Agent.start_link(fn -> @defaults end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end
end
