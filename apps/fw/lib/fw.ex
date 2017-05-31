defmodule Fw do
  use Application

  alias Nerves.UART

  require Logger

  @interface :eth0

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Phoenix.PubSub.PG2, [Nerves.PubSub, [poolsize: 1]]),
      worker(Task, [fn -> start_network end], restart: :transient),
      worker(Task, [fn -> init_uart() end], restart: :transient, id: Nerves.Init.Uart),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_network do
    Nerves.Networking.setup @interface, mode: "static", ip: "192.168.1.104", router: "192.168.1.1",
                            mask: "24", subnet: "255.255.255.0", mode: "static", dns: "8.8.8.8",
                            hostname: "nervesiot"
  end

  def init_uart() do
    unless :os.type == {:unix, :darwin} do
      {:ok, pid} = UART.start_link

      UART.open(pid, "ttyACM0", speed: 9600, active: false)

      UART.configure(pid, framing: {Nerves.UART.Framing.Line, separator: "\r\n"})

      # UART.write(pid, "ping\r\n")
      spawn_link fn -> uart_loop(pid) end

      # {:ok, buffer} = Nerves.UART.read(pid, 6000)
      {:ok, self()}
    end
  end

  def uart_loop(pid) do
    # Read UART forever
    UART.write(pid, "P\r\n")
    {:ok, buffer} = Nerves.UART.read(pid, 6000)
    Logger.debug "Sensor data: #{buffer}"

    buffer = String.strip(buffer)

    if String.length(buffer) == 0  do
      buffer = 0
    end

    value = buffer
    # value = String.to_integer(buffer)
    # Ui.Store.put(:uart_buffer, value)

    data = Ui.Store.get(:data)

    id = "rf101"

    sensor = data[id]

    if is_nil(sensor) do
      sensor = %{:id => id, :type => "distance", :value => value}
      data = Map.put(data, id, sensor)
    else
      sensor = %{sensor | :value => value}
      data = %{data | id => sensor}
    end

    Ui.Store.put(:data, data)
    response = %{
      data: sensor
    }

    uart_loop(pid)
  end

end
