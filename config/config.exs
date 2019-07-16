use Mix.Config

config :oauth_mock_server, port: 54_345

import_config "#{Mix.env()}.exs"
