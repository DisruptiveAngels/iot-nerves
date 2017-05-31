defmodule Ui.Api.V1.SensorController do
  use Ui.Web, :controller

  # def index(conn, _params) do
  #   render(conn, "index.json", movies: movies)
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   render(conn, "show.json", movie: movie)
  # end

  def temp_values(conn, %{"id" => id, "value" => value}) do
    data = Ui.Store.get(:data)

    sensor = data[id]

    if is_nil(sensor) do
      sensor = %{:id => id, :type => "temperature", :value => value}
      data = Map.put(data, id, sensor)
    else
      sensor = %{sensor | :value => value}
      data = %{data | id => sensor}
    end

    Ui.Store.put(:data, data)
    response = %{
      data: sensor
    }

    json conn, response
  end

  def gas_values(conn, %{"id" => id, "value" => value}) do
    data = Ui.Store.get(:data)

    sensor = data[id]

    if is_nil(sensor) do
      sensor = %{:id => id, :type => "gas", :value => value}
      data = Map.put(data, id, sensor)
    else
      sensor = %{sensor | :value => value}
      data = %{data | id => sensor}
    end

    Ui.Store.put(:data, data)
    response = %{
      data: sensor
    }

    json conn, response
  end

  def switch_values(conn, %{"id" => id, "value" => value}) do
    data = Ui.Store.get(:data)

    sensor = data[id]

    if is_nil(sensor) do
      sensor = %{:id => id, :type => "switch", :value => value}
      data = Map.put(data, id, sensor)
    else
      sensor = %{sensor | :value => value}
      data = %{data | id => sensor}
    end

    Ui.Store.put(:data, data)
    response = %{
      data: sensor
    }

    json conn, response
  end

  def flow_values(conn, %{"id" => id, "value" => value}) do
    data = Ui.Store.get(:data)

    sensor = data[id]

    if is_nil(sensor) do
      sensor = %{:id => id, :type => "flow", :value => value}
      data = Map.put(data, id, sensor)
    else
      sensor = %{sensor | :value => value}
      data = %{data | id => sensor}
    end

    Ui.Store.put(:data, data)
    response = %{
      data: sensor
    }

    json conn, response
  end

  def hits_values(conn, %{"id" => id, "value" => value}) do
    data = Ui.Store.get(:data)

    sensor = data[id]

    if is_nil(sensor) do
      sensor = %{:id => id, :type => "hits", :value => value}
      data = Map.put(data, id, sensor)
    else
      sensor = %{sensor | :value => value}
      data = %{data | id => sensor}
    end

    Ui.Store.put(:data, data)
    response = %{
      data: sensor
    }

    json conn, response
  end

  def distance_values(conn, %{"id" => id, "value" => value}) do
    data = Ui.Store.get(:data)

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

    json conn, response
  end

  def need_on(conn, %{"id" => id}) do
    data = Ui.Store.get(:data)
    threshold = Ui.Store.get(:threshold)

    # Need to be our temp sensor ID.
    sensor = data[id]

    response = %{:turn_on => 0}

    if !is_nil(sensor) do
      if String.to_integer(sensor.value) > threshold do
        response = %{:turn_on => 1}
      end
    end

    # response = %{
    #   data: sensor
    # }

    json conn, response
  end

  def get_data(conn, %{}) do
    data = Ui.Store.get(:data)
    response = %{
      data: data
    }
    json conn, response
  end

  def config_threshold(conn, %{"value" => value}) do
    Ui.Store.put(:threshold, String.to_integer(value))
    json conn, %{}
  end
end
