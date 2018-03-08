# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ipx,
  ecto_repos: [Ipx.Repo]

# Configures the endpoint
config :ipx, IpxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WkqyYtFacAraMc2rFIrBDLJxE2rVPSOBH07f4Z4zERUuMTemV7/ELOsFb42KzB+F",
  render_errors: [view: IpxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ipx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :geolix,
  databases: [
    %{
      id:      :geo,
      adapter: Geolix.Adapter.MMDB2,
      source:  "priv/geolocation.mmdb"
    },
    %{
      id:      :asn,
      adapter: Geolix.Adapter.MMDB2,
      source:  "priv/asn.mmdb"
    }

  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
