defmodule Ui.PageController do
  use Ui.Web, :controller

  def index(conn, _params) do
    render conn, "iot.html"
  end
end
