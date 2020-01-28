defmodule BoatServer.Signalk do
  require Logger
  use GenServer

  @feed "/signalk/v1/api/"

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def observe(host) do
    GenServer.call(__MODULE__, {:observe, host})
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call({:observe, host}, _from, state) do
    send(self(), {:update, host})
    {:reply, :ok, state}
  end

  @impl true
  def handle_info({:update, host}, state) do
    get(host)
    |> BoatServer.Prometheus.instrument()

    Process.send_after(self(), {:update, host}, 1000)
    {:noreply, state}
  end

  defp get(host) do
    host
    |> get_json
    |> decode
  end

  defp decode(json) do
    case Jason.decode(json) do
      {:error, reason} ->
        Logger.error("Could not parse JSON: #{inspect(reason)}")
        :error

      {:ok, %{"self" => self, "vessels" => vessels}} ->
        # {:ok, Map.get(vessels, self)}
        Map.get(vessels, self)
    end
  end

  defp get_json(host) do
    case :httpc.request(String.to_charlist("http://#{host}#{@feed}")) do
      {:ok, {status, _header, body}} ->
        Logger.debug("Fetched SignalK data: #{inspect(status)}")
        List.to_string(body)

      error ->
        Logger.warn("Could not fetch feed: #{inspect(error)}")
        error
    end
  end
end
