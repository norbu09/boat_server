defmodule BoatServer.Web.Router do
  @moduledoc false

  use Plug.Router

  plug(BoatServer.Web.MetricsExporter)

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  match _ do
    send_resp(conn, 404, "Hmmmm...that didn't work")
  end
end
