defmodule BoatServer.Prometheus do
  use Prometheus.Metric

  def setup do
    Gauge.new(
      name: :wind_speed_apparent,
      labels: [:boat, :source],
      help: "Apparent wind speed"
    )

    Gauge.new(
      name: :wind_angle_apparent,
      labels: [:boat, :source],
      help: "Apparent wind angle"
    )

    Gauge.new(
      name: :wind_angle_apparent_deg,
      labels: [:boat, :source],
      help: "Apparent wind angle in degrees"
    )
  end

  def instrument(%{"environment" => env, "name" => name}) do
    speed = convert(:ms_to_kn, env["wind"]["speedApparent"]["value"])
    deg = convert(:rad_to_degree, env["wind"]["angleApparent"]["value"])
    Gauge.set([name: :wind_speed_apparent, labels: [name, "signalk"]], speed)
    Gauge.set([name: :wind_angle_apparent_deg, labels: [name, "signalk"]], deg)

    Gauge.set(
      [name: :wind_angle_apparent, labels: [name, "signalk"]],
      env["wind"]["angleApparent"]["value"]
    )

  end

  defp convert(:ms_to_kn, value) do
    value * 1.9438444924406
  end
  defp convert(:rad_to_degree, value) do
    value * (180/:math.pi())
  end
end
