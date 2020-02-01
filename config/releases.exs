import Config

config :boat_server, :signalk, System.fetch_env!("boat_server_params")
