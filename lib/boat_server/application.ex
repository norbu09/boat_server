defmodule BoatServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # start Prometheus
    BoatServer.Prometheus.setup()
    BoatServer.Web.MetricsExporter.setup()

    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: BoatServer.Web.Router, options: [port: 4000]),
      BoatServer.Signalk
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BoatServer.Supervisor]
    sv = Supervisor.start_link(children, opts)

    BoatServer.start()
    sv
  end
end
