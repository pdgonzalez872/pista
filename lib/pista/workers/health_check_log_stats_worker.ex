defmodule Pista.Workers.HealthCheckLogStatsWorker do
  use GenServer

  require Logger

  # Client

  def get_stats() do
    GenServer.call({:global, __MODULE__}, :get_stats)
  end

  # Server

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: {:global, __MODULE__})
  end

  @impl true
  def init(state) do
    state = do_work(state)
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_call(:get_stats, _from, state) do
    Logger.info("Inside Server, getting state")

    Logger.info("Server state: #{inspect(state)}")

    {:reply, state, state}
  end

  @impl true
  def handle_info(:work, state) do
    state = do_work(state)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.minutes(10))
  end

  defp do_work(_state) do
    count = Pista.Tournaments.tournament_count()
    {live, not_live} = Pista.Livestreams.count_padel_livestreams()

    msg = """

    Health Check! Current stats are:

    Tournament count:      #{count}
    Live Livestreams:      #{live}
    Not Live Livestreams:  #{not_live}
    Results count:         TODO
    Current users:         TODO
    """

    Logger.info(msg)
  end
end
