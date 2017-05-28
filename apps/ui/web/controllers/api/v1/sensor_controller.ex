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
    sensor = %{
      id: id,
      type: "temperature",
      val: value
    }

    temperature = [
      id: %{id: "567", type: "temperature", value: value},
      mary: %{id: "Mary", type: "temperature", value: value}
    ]

    Ui.Store.put(:temperature, temperature)

    data = Ui.Store.get(:temperature)
    response = %{
      data: data[:id].value
    }

    json conn, response
  end

  def gas_values(conn, %{"id" => id, "value" => value}) do
    json conn, %{ok: "200", id: id, value: value}
  end

  def switch_values(conn, %{"id" => id, "value" => value}) do
    json conn, %{ok: "200", id: id, value: value}
  end

  def flow_values(conn, %{"id" => id, "value" => value}) do
    json conn, %{ok: "200", id: id, value: value}
  end

  def get_data(conn, %{}) do
    data = Ui.Store.get(:temperature)
    response = %{
      data: data[:id].value
    }
    json conn, response
  end
end
