defmodule Pista.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PistaWeb.Telemetry,
      # Start the Ecto repository
      Pista.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pista.PubSub},
      # Start Finch
      {Finch, name: Pista.Finch},
      # Start the Endpoint (http/https)
      PistaWeb.Endpoint
      # Start a worker by calling: Pista.Worker.start_link(arg)
      # {Pista.Worker, arg}
    ]

    target_env = System.get_env("MIX_ENV")

    children =
      if target_env in ["dev", "prod"] do
        children ++
          [
            {Pista.Workers.LiveDetectorRedbullWorker, []},
            {Pista.Workers.LiveDetectorYouTubeWorker, []},
            {Pista.Workers.TournamentsWorker, []},
            {Pista.Workers.HealthCheckLogStatsWorker, []}
          ]
      else
        IO.puts("This is a test env")
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pista.Supervisor]
    success = Supervisor.start_link(children, opts)

    # if Application.get_env(:pista, :boot_workers) do
    #   Pista.Workers.on_boot()
    # end

    success
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PistaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
