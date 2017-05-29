defmodule Ui.Router do
  use Ui.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Ui do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Ui, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      # resources "/sensors", SensorController, only: [:index, :show, :create, :update, :delete]
      post "/sensor/:id/temp/:value", SensorController, :temp_values
      post "/sensor/:id/gas/:value", SensorController, :gas_values
      post "/sensor/:id/switch/:value", SensorController, :switch_values
      post "/sensor/:id/flow/:value", SensorController, :flow_values
      post "/sensor/:id/hits/:value", SensorController, :hits_values

      get "/sensor/:id/need_on", SensorController, :need_on
      get "/get_data", SensorController, :get_data
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Ui do
  #   pipe_through :api
  # end
end
