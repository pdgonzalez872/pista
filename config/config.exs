# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pista,
  ecto_repos: [Pista.Repo]

# Configures the endpoint
config :pista, PistaWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: PistaWeb.ErrorHTML, json: PistaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Pista.PubSub,
  live_view: [signing_salt: "5Sx8t6ig"],
  check_origin: [
    "http://pista.cloud",
    "https://pista.cloud",
    "https://www.pista.cloud"
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :pista, Pista.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:mfa, :request_id],
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pista, Oban,
  repo: Pista.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 86400}
  ],
  queues: [default: 10]

config :pista, :generators,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

config :pista, boot_workers: true

config :pista, :requests_impl, Pista.RequestsReqImpl

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
