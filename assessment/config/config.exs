import Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mnesia,
  dir: '.mnesia/#{Mix.env()}/#{node()}'

import_config "#{Mix.env()}.exs"
