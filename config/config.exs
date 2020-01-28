use Mix.Config

config :boat_server, :signalk, hosts: ["192.168.1.30"]

import_config "#{Mix.env()}.exs"
