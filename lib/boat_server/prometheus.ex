defmodule BoatServer.Prometheus do
  use Prometheus.Metric
  require Logger

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

    Gauge.new(
      name: :position_latitude,
      labels: [:boat, :source],
      help: "Latitude of current position"
    )

    Gauge.new(
      name: :position_longitude,
      labels: [:boat, :source],
      help: "Longitude of current position"
    )

    Gauge.new(
      name: :position_altitude,
      labels: [:boat, :source],
      help: "Altitude of current position"
    )

    Gauge.new(
      name: :course_over_ground_true,
      labels: [:boat, :source],
      help: "Current true course over ground"
    )

    Gauge.new(
      name: :speed_over_ground,
      labels: [:boat, :source],
      help: "Current speed over ground"
    )
  end

  def instrument(%{"navigation" => nav, "environment" => env, "name" => name}) do
    wind_speed = convert(:ms_to_kn, env["wind"]["speedApparent"]["value"])
    wind_deg = convert(:rad_to_degree, env["wind"]["angleApparent"]["value"])
    course = convert(:rad_to_degree, nav["courseOverGroundTrue"]["value"])
    boat_speed = convert(:ms_to_kn, nav["speedOverGround"]["value"])

    Gauge.set([name: :wind_speed_apparent, labels: [name, "signalk"]], wind_speed)
    Gauge.set([name: :wind_angle_apparent_deg, labels: [name, "signalk"]], wind_deg)
    Gauge.set([name: :wind_angle_apparent, labels: [name, "signalk"]], env["wind"]["angleApparent"]["value"])
    Gauge.set([name: :position_longitude, labels: [name, "signalk"]], nav["position"]["longitude"])
    Gauge.set([name: :position_latitude, labels: [name, "signalk"]], nav["position"]["latitude"])
    Gauge.set([name: :position_altitude, labels: [name, "signalk"]], nav["position"]["altitude"])
    Gauge.set([name: :course_over_ground_true, labels: [name, "signalk"]], course)
    Gauge.set([name: :speed_over_ground, labels: [name, "signalk"]], boat_speed)

  end

  defp convert(:ms_to_kn, value) do
    value * 1.9438444924406
  end

  # convert rad to degrees and make the heading 0 deg and port -180 to 0 and
  # starbord 180 - 0
  defp convert(:rad_to_degree, value) do
    deg = value * (180/:math.pi())
    case deg >= 180 do
      true -> deg - 360
      false -> deg
    end
  end
end
