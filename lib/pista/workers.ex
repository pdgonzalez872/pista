defmodule Pista.Workers do
  @moduledoc """
  Context involving workers
  """

  require Logger

  @doc """
  Does the necessary setup for each of the worker kinds
  """
  def on_boot("genserver" = kind) do
    Logger.info("Booting Workers, kind: #{kind}")

    [
      Pista.Workers.LiveDetectorRedbullWorker,
      Pista.Workers.LiveDetectorYouTubeWorker,
      Pista.Workers.TournamentsWorker,
      Pista.Workers.HealthCheckLogStatsWorker
    ]
    |> Enum.each(fn w -> DynamicSupervisor.start_child(Pista.DynamicSupervisor, {w, []}) end)

    :ok
  end

  def on_boot(other) do
    Logger.error("Unknown worker kind: #{other}")
    :ok
  end
end
